package com.example.remember_me

import android.Manifest
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DailyTrailService : Service(), LocationListener, SensorEventListener {
    private lateinit var locations: LocationManager
    private var previousDay: String? = null
    private val filter = TrailQualityFilter()
    private lateinit var arrivals: ArrivalMonitor
    private lateinit var sensors: SensorManager
    private var lastMotion = 0L
    private var currentInterval = 5000L
    private var currentMinDistance = 10f
    private var lastRateChange = 0L
    private val preferences by lazy { getSharedPreferences("daily", MODE_PRIVATE) }

    private val handler = Handler(Looper.getMainLooper())
    private val heartbeatRunnable = object : Runnable {
        override fun run() {
            preferences.edit().putLong("trail_heartbeat", System.currentTimeMillis()).apply()
            handler.postDelayed(this, 30_000L)
        }
    }

    override fun onCreate() {
        super.onCreate()
        locations = getSystemService(LOCATION_SERVICE) as LocationManager
        arrivals = ArrivalMonitor(this)
        sensors = getSystemService(SENSOR_SERVICE) as SensorManager
        sensors.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION)?.let {
            sensors.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val launch = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java).putExtra("dailyTab", "trail"),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val channelId = NotificationChannels.CHANNEL_TRAIL_STATUS
        @Suppress("DEPRECATION")
        val notification = if (Build.VERSION.SDK_INT >= 26) {
            Notification.Builder(this, channelId)
        } else {
            Notification.Builder(this)
        }
            .setSmallIcon(R.drawable.ic_stat_remember)
            .setContentTitle("Remember Me is recording your trail")
            .setContentText("Locations stay on this phone. Tap to view or stop recording.")
            .setContentIntent(launch)
            .setOngoing(true)
            .build()

        startForeground(41001, notification)

        // Ensure tracking is marked enabled and start heartbeat
        preferences.edit().putBoolean("tracking", true).putLong("trail_heartbeat", System.currentTimeMillis()).apply()
        handler.removeCallbacks(heartbeatRunnable)
        handler.post(heartbeatRunnable)
        DailyTrailWatchdogReceiver.schedule(this)

        if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
        ) {
            preferences.edit().putString("trackingError", "Location permission was removed. Enable it to resume recording.").apply()
            stopSelf()
            return START_NOT_STICKY
        }

        try {
            registerLocationUpdates(currentInterval, currentMinDistance)
        } catch (e: Exception) {
            preferences.edit().putString("trackingError", "Recording paused: ${e.message}").apply()
            stopSelf()
            return START_NOT_STICKY
        }

        return START_STICKY
    }

    private fun registerLocationUpdates(intervalMs: Long, minDistanceMeters: Float) {
        locations.removeUpdates(this)
        var providers = 0
        for (provider in listOf(LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER)) {
            if (locations.isProviderEnabled(provider)) {
                locations.requestLocationUpdates(provider, intervalMs, minDistanceMeters, this)
                providers++
            }
        }
        preferences.edit().putString(
            "trackingError",
            if (providers == 0) "Location is switched off. Turn it on to record your trail." else null
        ).apply()
    }

    override fun onLocationChanged(location: Location) {
        if (!location.hasAccuracy() ||
            location.time < System.currentTimeMillis() - 30000 ||
            location.time > System.currentTimeMillis() + 5000
        ) return

        // Update heartbeat on location reception
        preferences.edit().putLong("trail_heartbeat", System.currentTimeMillis()).apply()

        val day = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date(location.time))
        if (previousDay != null && previousDay != day) {
            filter.reset()
        }
        previousDay = day

        val speedVal = if (location.hasSpeed() &&
            (Build.VERSION.SDK_INT < 26 || !location.hasSpeedAccuracy() || location.speedAccuracyMetersPerSecond < 2.0f)
        ) location.speed.toDouble() else null

        val sample = TrailSample(
            latitude = location.latitude,
            longitude = location.longitude,
            time = location.time,
            accuracy = location.accuracy.toDouble(),
            speed = speedVal,
            motion = android.os.SystemClock.elapsedRealtime() - lastMotion < 5000
        )

        val rejectedBefore = filter.rejected
        val outputs = filter.process(sample)

        // Stationary rate adaptation
        if (filter.isStationary) {
            changeRate(60000L, 100f)
        } else {
            changeRate(5000L, 10f)
        }

        if (filter.rejected == rejectedBefore) {
            arrivals.sample(location)
        }

        if (outputs.isEmpty()) return

        try {
            val directory = File(filesDir, "trails").apply { mkdirs() }
            val trailFile = File(directory, "$day.jsonl")

            for (output in outputs) {
                when (output) {
                    is TrailOutput.Gap -> {
                        val gapJson = JSONObject()
                            .put("type", "gap")
                            .put("start", output.start)
                            .put("end", output.end)
                            .put("reason", output.reason)
                        trailFile.appendText("$gapJson\n")
                    }
                    is TrailOutput.Fix -> {
                        val fixJson = JSONObject()
                            .put("type", "fix")
                            .put("lat", output.latitude)
                            .put("lng", output.longitude)
                            .put("time", output.time)
                            .put("accuracy", output.accuracy)
                            .put("speed", output.speed)
                            .put("gap", output.gap)
                        trailFile.appendText("$fixJson\n")
                    }
                }
            }
            preferences.edit().remove("trackingError").apply()
        } catch (e: Exception) {
            preferences.edit().putString("trackingError", "Could not save location: ${e.message}").apply()
        }
    }

    override fun onProviderDisabled(provider: String) {
        if (!locations.isProviderEnabled(LocationManager.GPS_PROVIDER) &&
            !locations.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        ) {
            preferences.edit().putString("trackingError", "Location is switched off. Turn it on to continue recording.").apply()
        }
    }

    override fun onProviderEnabled(provider: String) {
        try {
            registerLocationUpdates(currentInterval, currentMinDistance)
        } catch (_: SecurityException) {}
    }

    override fun onSensorChanged(event: SensorEvent) {
        val energy = event.values.take(3).sumOf { it.toDouble() * it }
        if (energy > 0.25) {
            lastMotion = android.os.SystemClock.elapsedRealtime()
            if (filter.isStationary) {
                changeRate(5000L, 10f)
            }
        }
    }

    private fun changeRate(intervalMs: Long, minDistanceMeters: Float) {
        val now = android.os.SystemClock.elapsedRealtime()
        if ((currentInterval == intervalMs && currentMinDistance == minDistanceMeters) || now - lastRateChange < 15000) return
        currentInterval = intervalMs
        currentMinDistance = minDistanceMeters
        lastRateChange = now
        try {
            registerLocationUpdates(currentInterval, currentMinDistance)
        } catch (_: SecurityException) {
            preferences.edit().putString("trackingError", "Location permission was removed.").apply()
            stopSelf()
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onDestroy() {
        handler.removeCallbacks(heartbeatRunnable)
        try {
            locations.removeUpdates(this)
        } catch (_: SecurityException) {}
        sensors.unregisterListener(this)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}

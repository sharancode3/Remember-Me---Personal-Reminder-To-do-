package com.example.remember_me

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
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
import android.os.IBinder
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
    private var interval = 3000L
    private var lastRateChange = 0L
    private val preferences by lazy { getSharedPreferences("daily", MODE_PRIVATE) }

    override fun onCreate() {
        super.onCreate()
        locations = getSystemService(LOCATION_SERVICE) as LocationManager
        arrivals = ArrivalMonitor(this)
        sensors = getSystemService(SENSOR_SERVICE) as SensorManager
        sensors.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION)?.let { sensors.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL) }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel(
            "daily_trail", "Daily trail recording", NotificationManager.IMPORTANCE_LOW))
        val launch = PendingIntent.getActivity(this, 0, Intent(this, MainActivity::class.java).putExtra("dailyTab","trail"), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val notification = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, "daily_trail") else Notification.Builder(this)
        startForeground(41001, notification.setSmallIcon(R.drawable.ic_stat_remember)
            .setContentTitle("Remember Me is recording your trail")
            .setContentText("Locations stay on this phone. Tap to view or stop recording.")
            .setContentIntent(launch).setOngoing(true).build())
        if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            preferences.edit().putString("trackingError", "Location permission was removed. Enable it to resume recording.").apply()
            stopSelf()
            return START_NOT_STICKY
        }
        try {
            locations.removeUpdates(this)
            var providers = 0
            for (provider in listOf(LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER)) {
                if (locations.isProviderEnabled(provider)) {
                    locations.requestLocationUpdates(provider, interval, 0f, this)
                    providers++
                }
            }
            preferences.edit().putString("trackingError", if (providers == 0) "Location is switched off. Turn it on to record your trail." else null).apply()
        } catch (e: Exception) {
            preferences.edit().putString("trackingError", "Recording paused: ${e.message}").apply()
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    override fun onLocationChanged(location: Location) {
        if (!location.hasAccuracy() || location.time < System.currentTimeMillis() - 30000 || location.time > System.currentTimeMillis() + 5000) return
        val moving = android.os.SystemClock.elapsedRealtime() - lastMotion < 30000 || (location.hasSpeed() && location.speed > .7f)
        changeRate(if (moving) 3000L else 30000L)
        val day = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date(location.time))
        if (previousDay != null && previousDay != day) filter.reset()
        previousDay = day
        val rejected = filter.rejected
        val clean = filter.accept(TrailSample(location.latitude, location.longitude, location.time, location.accuracy.toDouble(),
            if (location.hasSpeed() && (Build.VERSION.SDK_INT < 26 || !location.hasSpeedAccuracy() || location.speedAccuracyMetersPerSecond < 1.5f)) location.speed.toDouble() else null,
            android.os.SystemClock.elapsedRealtime() - lastMotion < 5000))
        if(filter.rejected == rejected) arrivals.sample(location)
        if(clean == null) return
        try {
            val directory = File(filesDir, "trails").apply { mkdirs() }
            val fix = JSONObject().put("lat", clean.latitude).put("lng", clean.longitude)
                .put("time", clean.time).put("accuracy", clean.accuracy).put("speed", clean.speed).put("gap", clean.gap)
            File(directory, "$day.jsonl").appendText("$fix\n")
            previousDay = day
            preferences.edit().remove("trackingError").apply()
        } catch (e: Exception) {
            preferences.edit().putString("trackingError", "Could not save location: ${e.message}").apply()
        }
    }

    override fun onProviderDisabled(provider: String) {
        if (!locations.isProviderEnabled(LocationManager.GPS_PROVIDER) && !locations.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
            preferences.edit().putString("trackingError", "Location is switched off. Turn it on to continue recording.").apply()
        }
    }
    override fun onProviderEnabled(provider: String) {
        try { locations.requestLocationUpdates(provider, interval, 0f, this) } catch (_: SecurityException) { }
    }
    override fun onSensorChanged(event: SensorEvent) {
        val energy = event.values.take(3).sumOf { it.toDouble() * it }
        if (energy > .25) { lastMotion = android.os.SystemClock.elapsedRealtime(); changeRate(3000L) }
    }
    private fun changeRate(value: Long) {
        val now = android.os.SystemClock.elapsedRealtime()
        if(interval == value || now - lastRateChange < 15000) return
        interval = value; lastRateChange = now
        try {
            locations.removeUpdates(this)
            for(provider in listOf(LocationManager.GPS_PROVIDER,LocationManager.NETWORK_PROVIDER)) if(locations.isProviderEnabled(provider)) locations.requestLocationUpdates(provider, interval, 0f, this)
        } catch(_: SecurityException) { preferences.edit().putString("trackingError","Location permission was removed.").apply(); stopSelf() }
    }
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) { }
    override fun onDestroy() { try { locations.removeUpdates(this) } catch(_: SecurityException) { }; sensors.unregisterListener(this); super.onDestroy() }
    override fun onBind(intent: Intent?): IBinder? = null
}

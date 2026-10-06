package com.example.remember_me

import android.Manifest
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices
import org.json.JSONArray
import org.json.JSONObject

object NativeGeofenceManager {

    const val MAX_WINDOW_SIZE = 20
    private const val GEOFENCE_REQUEST_CODE = 41050

    fun selectActiveWindow(
        candidates: List<PlaceGeofenceData>,
        userLat: Double?,
        userLng: Double?,
        maxWindowSize: Int = MAX_WINDOW_SIZE
    ): List<PlaceGeofenceData> {
        val notifyOnly = candidates.filter { it.notify }
        if (notifyOnly.size <= maxWindowSize) return notifyOnly
        if (userLat == null || userLng == null) return notifyOnly.take(maxWindowSize)

        return notifyOnly.sortedBy { p ->
            TrailQualityFilter.distance(userLat, userLng, p.lat, p.lng)
        }.take(maxWindowSize)
    }

    fun shouldRecenter(
        lastCenterLat: Double?,
        lastCenterLng: Double?,
        currentLat: Double,
        currentLng: Double,
        thresholdMeters: Double = 1000.0
    ): Boolean {
        if (lastCenterLat == null || lastCenterLng == null) return true
        val dist = TrailQualityFilter.distance(lastCenterLat, lastCenterLng, currentLat, currentLng)
        return dist >= thresholdMeters
    }

    private fun getPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, GeofenceBroadcastReceiver::class.java)
        return PendingIntent.getBroadcast(
            context,
            GEOFENCE_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
    }

    fun registerGeofences(context: Context, userLat: Double? = null, userLng: Double? = null) {
        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)

        // Do not register native geofences if trail recording is ON (trail service does GPS-piggyback arrival detection)
        if (prefs.getBoolean("tracking", false)) {
            AppLogger.d("GeofenceManager", "Trail recording is active. Skipping background geofences.")
            return
        }

        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            AppLogger.w("GeofenceManager", "ACCESS_FINE_LOCATION not granted. Cannot register geofences.")
            return
        }

        if (Build.VERSION.SDK_INT >= 29 &&
            ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_BACKGROUND_LOCATION) != PackageManager.PERMISSION_GRANTED
        ) {
            AppLogger.w("GeofenceManager", "ACCESS_BACKGROUND_LOCATION not granted for background geofences.")
            // Still proceed if foreground, but log awareness
        }

        val rawPlaces = JSONArray(prefs.getString("places", "[]"))
        val candidatePlaces = mutableListOf<PlaceGeofenceData>()
        for (i in 0 until rawPlaces.length()) {
            val p = rawPlaces.getJSONObject(i)
            candidatePlaces.add(
                PlaceGeofenceData(
                    id = p.getString("id"),
                    name = p.optString("name", "Saved Place"),
                    lat = p.getDouble("lat"),
                    lng = p.getDouble("lng"),
                    radius = p.optDouble("radius", 100.0),
                    dwellSeconds = p.optInt("dwellSeconds", 90),
                    notify = p.optBoolean("notify", false),
                    message = p.optString("message", "")
                )
            )
        }

        val refLat = userLat ?: prefs.getString("geofence_window_lat", null)?.toDoubleOrNull()
        val refLng = userLng ?: prefs.getString("geofence_window_lng", null)?.toDoubleOrNull()
        val activePlaces = selectActiveWindow(candidatePlaces, refLat, refLng, MAX_WINDOW_SIZE)

        if (activePlaces.isEmpty()) {
            removeGeofences(context)
            return
        }

        if (userLat != null && userLng != null) {
            prefs.edit()
                .putString("geofence_window_lat", userLat.toString())
                .putString("geofence_window_lng", userLng.toString())
                .apply()
        }

        val geofenceList = mutableListOf<Geofence>()
        for (place in activePlaces) {
            val radius = place.radius.coerceIn(75.0, 500.0).toFloat()
            val dwellSeconds = place.dwellSeconds.coerceIn(30, 300)

            geofenceList.add(
                Geofence.Builder()
                    .setRequestId(place.id)
                    .setCircularRegion(place.lat, place.lng, radius)
                    .setExpirationDuration(Geofence.NEVER_EXPIRE)
                    .setTransitionTypes(
                        Geofence.GEOFENCE_TRANSITION_ENTER or
                        Geofence.GEOFENCE_TRANSITION_DWELL or
                        Geofence.GEOFENCE_TRANSITION_EXIT
                    )
                    .setLoiteringDelay(dwellSeconds * 1000)
                    .build()
            )
        }

        val geofencingClient = LocationServices.getGeofencingClient(context)
        val request = GeofencingRequest.Builder()
            .setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER or GeofencingRequest.INITIAL_TRIGGER_DWELL)
            .addGeofences(geofenceList)
            .build()

        try {
            geofencingClient.addGeofences(request, getPendingIntent(context))
                .addOnSuccessListener {
                    AppLogger.i("GeofenceManager", "Successfully registered ${geofenceList.size} native geofences.")
                }
                .addOnFailureListener { e ->
                    AppLogger.e("GeofenceManager", "Failed to add native geofences: ${e.message}", e)
                }
        } catch (e: SecurityException) {
            AppLogger.e("GeofenceManager", "SecurityException adding geofences: ${e.message}", e)
        }
    }

    fun removeGeofences(context: Context) {
        val geofencingClient = LocationServices.getGeofencingClient(context)
        geofencingClient.removeGeofences(getPendingIntent(context))
            .addOnSuccessListener {
                AppLogger.d("GeofenceManager", "Removed native geofences.")
            }
            .addOnFailureListener { e ->
                AppLogger.w("GeofenceManager", "Failed to remove geofences: ${e.message}")
            }
    }
}

package com.example.remember_me

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.Build
import android.Manifest
import android.content.pm.PackageManager
import org.json.JSONArray

class ArrivalMonitor(private val context: Context) {
    private val entered = mutableMapOf<String, Long>()
    private val inside = mutableSetOf<String>()
    fun sample(location: Location) {
        if (Build.VERSION.SDK_INT >= 33 && context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) return
        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
        val places = JSONArray(prefs.getString("places", "[]"))
        for (i in 0 until places.length()) {
            val place = places.getJSONObject(i)
            if (!place.optBoolean("notify")) continue
            val id = place.getString("id")
            val distance = TrailQualityFilter.distance(location.latitude, location.longitude, place.getDouble("lat"), place.getDouble("lng"))
            val radius = place.optDouble("radius", 100.0).coerceIn(75.0, 500.0)
            if (distance - location.accuracy > radius + 35) { entered.remove(id); inside.remove(id); continue }
            if (distance + location.accuracy > radius || location.accuracy > 40) continue
            val since = entered.getOrPut(id) { location.time }
            if (location.time - since < 20000 || inside.contains(id)) continue
            // Persist a cooldown so service restarts cannot spam the same arrival.
            val key = "arrival_$id"
            if (location.time - prefs.getLong(key, 0) < 30 * 60000) { inside.add(id); continue }
            inside.add(id); prefs.edit().putLong(key, location.time).apply()
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel("place_arrivals", "Arrival reminders", NotificationManager.IMPORTANCE_HIGH))
            val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(context, "place_arrivals") else Notification.Builder(context)
            val launch = PendingIntent.getActivity(context, id.hashCode(), Intent(context, MainActivity::class.java).putExtra("dailyTab", "trail"), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            manager.notify(id.hashCode(), builder.setSmallIcon(R.drawable.ic_stat_remember).setContentTitle("You reached ${place.getString("name")}")
                .setContentText(place.optString("message", "Your saved place reminder")).setContentIntent(launch).setAutoCancel(true).build())
        }
    }
}

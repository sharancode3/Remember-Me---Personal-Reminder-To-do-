package com.example.remember_me

import android.Manifest
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import org.json.JSONArray
import org.json.JSONObject

class ArrivalMonitor(private val context: Context) {
    private val engine = ArrivalEngine()

    fun sample(location: Location) {
        if (Build.VERSION.SDK_INT >= 33 &&
            context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) return

        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
        val rawPlaces = JSONArray(prefs.getString("places", "[]") ?: "[]")
        val placesList = mutableListOf<PlaceGeofenceData>()
        for (i in 0 until rawPlaces.length()) {
            val p = rawPlaces.getJSONObject(i)
            placesList.add(
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

        val rawTasks = JSONObject(prefs.getString("tasks_by_place", "{}") ?: "{}")
        val taskMap = mutableMapOf<String, List<String>>()
        val keys = rawTasks.keys()
        while (keys.hasNext()) {
            val k = keys.next()
            val arr = rawTasks.optJSONArray(k)
            if (arr != null) {
                val list = mutableListOf<String>()
                for (j in 0 until arr.length()) {
                    list.add(arr.getString(j))
                }
                taskMap[k] = list
            }
        }

        engine.places = placesList
        engine.tasksByPlace = taskMap

        val alerts = engine.processLocation(
            location.latitude,
            location.longitude,
            location.accuracy,
            location.time
        )

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = NotificationChannels.CHANNEL_PLACE_ALERTS_V2

        for (alert in alerts) {
            val launch = PendingIntent.getActivity(
                context,
                alert.placeId.hashCode(),
                Intent(context, MainActivity::class.java)
                    .putExtra("dailyTab", "today")
                    .putExtra("filterPlace", alert.placeId),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            @Suppress("DEPRECATION")
            val builder = if (Build.VERSION.SDK_INT >= 26) {
                Notification.Builder(context, channelId)
            } else {
                Notification.Builder(context)
            }

            manager.notify(
                alert.placeId.hashCode(),
                builder.setSmallIcon(R.drawable.ic_stat_remember)
                    .setContentTitle(alert.title)
                    .setContentText(alert.content)
                    .setContentIntent(launch)
                    .setAutoCancel(true)
                    .build()
            )
        }
    }
}

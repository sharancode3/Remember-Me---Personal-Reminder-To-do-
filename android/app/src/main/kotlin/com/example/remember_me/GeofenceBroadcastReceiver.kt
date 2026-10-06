package com.example.remember_me

import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent
import org.json.JSONArray
import org.json.JSONObject

class GeofenceBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent == null) return
        val event = GeofencingEvent.fromIntent(intent) ?: return
        if (event.hasError()) {
            AppLogger.e("GeofenceReceiver", "GeofencingEvent error: ${event.errorCode}")
            return
        }

        val transition = event.geofenceTransition
        if (transition != Geofence.GEOFENCE_TRANSITION_ENTER &&
            transition != Geofence.GEOFENCE_TRANSITION_DWELL
        ) {
            return
        }

        val triggeringGeofences = event.triggeringGeofences ?: return
        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
        val places = JSONArray(prefs.getString("places", "[]") ?: "[]")
        val tasksByPlace = JSONObject(prefs.getString("tasks_by_place", "{}") ?: "{}")
        val now = System.currentTimeMillis()

        for (geofence in triggeringGeofences) {
            val placeId = geofence.requestId
            val cooldownKey = "arrival_$placeId"
            val lastFired = prefs.getLong(cooldownKey, 0L)
            // 30 minute cooldown per place
            if (lastFired > 0L && now - lastFired < 30 * 60_000L) {
                continue
            }
            prefs.edit().putLong(cooldownKey, now).apply()

            // Find matching place
            var matchedPlace: JSONObject? = null
            for (i in 0 until places.length()) {
                val p = places.getJSONObject(i)
                if (p.optString("id") == placeId) {
                    matchedPlace = p
                    break
                }
            }
            if (matchedPlace == null) continue

            val placeName = matchedPlace.optString("name", "Saved Place")
            val defaultMessage = matchedPlace.optString("message", "Your saved place reminder")

            // Check linked pending tasks for this place
            val placeTasks = tasksByPlace.optJSONArray(placeId)
                ?: tasksByPlace.optJSONArray(placeName.lowercase())
                ?: tasksByPlace.optJSONArray("@${placeName.lowercase().replace(" ", "")}")

            val (title, content) = if (placeTasks != null && placeTasks.length() > 0) {
                val count = placeTasks.length()
                val taskList = mutableListOf<String>()
                for (t in 0 until count) {
                    taskList.add(placeTasks.getString(t))
                }
                val preview = taskList.take(3).joinToString(", ")
                val suffix = if (count > 3) " +${count - 3} more" else ""
                Pair(
                    "At $placeName: $count task${if (count > 1) "s" else ""} pending",
                    "$preview$suffix"
                )
            } else {
                Pair("You reached $placeName", defaultMessage)
            }

            postArrivalNotification(context, placeId, title, content)
        }
    }

    private fun postArrivalNotification(
        context: Context,
        placeId: String,
        title: String,
        content: String
    ) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = NotificationChannels.CHANNEL_PLACE_ALERTS_V2

        val launch = PendingIntent.getActivity(
            context,
            placeId.hashCode(),
            Intent(context, MainActivity::class.java)
                .putExtra("dailyTab", "today")
                .putExtra("filterPlace", placeId),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        @Suppress("DEPRECATION")
        val builder = if (Build.VERSION.SDK_INT >= 26) {
            Notification.Builder(context, channelId)
        } else {
            Notification.Builder(context)
        }

        val notification = builder
            .setSmallIcon(R.drawable.ic_stat_remember)
            .setContentTitle(title)
            .setContentText(content)
            .setContentIntent(launch)
            .setAutoCancel(true)
            .build()

        manager.notify(placeId.hashCode(), notification)
    }
}

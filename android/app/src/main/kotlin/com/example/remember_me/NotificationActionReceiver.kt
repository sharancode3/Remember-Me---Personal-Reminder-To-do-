package com.example.remember_me

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

/**
 * Handles notification actions (Done / Snooze) natively, completely decoupled
 * from the Flutter runtime. Writes to a persistent durable outbox for Dart to drain.
 */
class NotificationActionReceiver : BroadcastReceiver() {
    companion object {
        const val PREFS_NAME = "notification_outbox_store"
        const val KEY_OUTBOX = "pending_actions"

        fun getPendingOutbox(context: Context): List<Map<String, Any>> {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val jsonStr = prefs.getString(KEY_OUTBOX, "[]") ?: "[]"
            val array = JSONArray(jsonStr)
            val result = mutableListOf<Map<String, Any>>()
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                result.add(
                    mapOf(
                        "uuid" to obj.getString("uuid"),
                        "occurrenceId" to obj.getLong("occurrenceId"),
                        "action" to obj.getString("action"),
                        "timestamp" to obj.getLong("timestamp")
                    )
                )
            }
            return result
        }

        fun acknowledge(context: Context, uuids: List<String>) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val jsonStr = prefs.getString(KEY_OUTBOX, "[]") ?: "[]"
            val array = JSONArray(jsonStr)
            val updated = JSONArray()
            val ackSet = uuids.toSet()
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                if (!ackSet.contains(obj.getString("uuid"))) {
                    updated.put(obj)
                }
            }
            prefs.edit().putString(KEY_OUTBOX, updated.toString()).apply()
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val occurrenceId = intent.getLongExtra("occurrenceId", 0L)
        val action = intent.getStringExtra("action") ?: return
        val notificationId = intent.getIntExtra("notificationId", (0x40000000 + occurrenceId).toInt())
        val taskTitle = intent.getStringExtra("taskTitle") ?: "Task"

        AppLogger.i("NotificationActionReceiver", "Received action=$action for occurrenceId=$occurrenceId")

        // 1. Immediately cancel or update the system notification
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.cancel(notificationId)

        // 2. Persist the action in the durable Outbox
        val actionRecord = JSONObject().apply {
            put("uuid", UUID.randomUUID().toString())
            put("occurrenceId", occurrenceId)
            put("action", action)
            put("timestamp", System.currentTimeMillis())
        }

        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val existing = JSONArray(prefs.getString(KEY_OUTBOX, "[]") ?: "[]")
        existing.put(actionRecord)
        prefs.edit().putString(KEY_OUTBOX, existing.toString()).apply()

        // 3. If action is snooze, schedule a native fallback alarm immediately
        if (action.startsWith("snooze")) {
            val snoozeMinutes = when (action) {
                "snooze_10" -> 10
                "snooze_60" -> 60
                "snooze_tomorrow" -> 14 * 60 // 14 hours
                else -> 10
            }
            scheduleNativeSnooze(context, occurrenceId, taskTitle, snoozeMinutes)
        }
    }

    private fun scheduleNativeSnooze(context: Context, occurrenceId: Long, title: String, minutes: Int) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val triggerTime = System.currentTimeMillis() + (minutes * 60 * 1000L)
        val intent = Intent(context, RepeatReminderReceiver::class.java).apply {
            setAction("remember_me.ALARM_TRIGGER")
            putExtra("occurrenceId", occurrenceId)
            putExtra("title", title)
            putExtra("isSnooze", true)
            putExtra("triggerTime", triggerTime)
        }
        val pending = PendingIntent.getBroadcast(
            context,
            (occurrenceId + 9999).toInt(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            if (Build.VERSION.SDK_INT >= 31 && am.canScheduleExactAlarms()) {
                am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTime, pending)
            } else {
                am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTime, pending)
            }
            AppLogger.i("NotificationActionReceiver", "Scheduled native snooze in $minutes mins for $occurrenceId")
        } catch (e: Exception) {
            AppLogger.e("NotificationActionReceiver", "Failed to schedule native snooze", e)
        }
    }
}

package com.example.remember_me

import android.Manifest
import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject

/**
 * Single Unified Native Alarm Receiver for Remember Me.
 * Schedules and dispatches alarms with sound, vibration, action buttons,
 * and handles system restore events.
 */
object UnifiedAlarmScheduler {
    private const val PREFS_NAME = "unified_reminders"
    private const val KEY_SCHEDULED = "scheduled_occurrences"

    private fun prefs(context: Context) = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun schedule(
        context: Context,
        occurrenceId: Long,
        title: String,
        triggerAtMillis: Long,
        isAlarmStyle: Boolean = false,
        nagMinutes: Int = 0,
        nagMax: Int = 0,
        nagCount: Int = 0
    ) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, RepeatReminderReceiver::class.java).apply {
            setAction("remember_me.ALARM_TRIGGER")
            putExtra("occurrenceId", occurrenceId)
            putExtra("title", title)
            putExtra("isAlarmStyle", isAlarmStyle)
            putExtra("nagMinutes", nagMinutes)
            putExtra("nagMax", nagMax)
            putExtra("nagCount", nagCount)
            putExtra("triggerTime", triggerAtMillis)
        }

        val pending = PendingIntent.getBroadcast(
            context,
            occurrenceId.toInt(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            if (isAlarmStyle) {
                // Use setAlarmClock for guaranteed waking and system lockscreen status
                val showIntent = Intent(context, MainActivity::class.java).apply {
                    putExtra("occurrenceId", occurrenceId)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val showPending = PendingIntent.getActivity(
                    context,
                    occurrenceId.toInt(),
                    showIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerAtMillis, showPending)
                am.setAlarmClock(alarmClockInfo, pending)
                AppLogger.i("UnifiedAlarmScheduler", "Scheduled AlarmClock for occurrence $occurrenceId at $triggerAtMillis")
            } else {
                if (Build.VERSION.SDK_INT >= 31 && am.canScheduleExactAlarms()) {
                    am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pending)
                } else {
                    am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pending)
                }
                AppLogger.i("UnifiedAlarmScheduler", "Scheduled exact alarm for occurrence $occurrenceId at $triggerAtMillis")
            }

            // Persist scheduled record for reconciliation
            saveRecord(context, occurrenceId, title, triggerAtMillis, isAlarmStyle, nagMinutes, nagMax, nagCount)
        } catch (e: Exception) {
            AppLogger.e("UnifiedAlarmScheduler", "Failed to schedule alarm for $occurrenceId", e)
        }
    }

    fun cancel(context: Context, occurrenceId: Long) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, RepeatReminderReceiver::class.java).apply {
            setAction("remember_me.ALARM_TRIGGER")
        }
        val pending = PendingIntent.getBroadcast(
            context,
            occurrenceId.toInt(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        am.cancel(pending)

        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.cancel(notificationId(occurrenceId))

        removeRecord(context, occurrenceId)
        AppLogger.i("UnifiedAlarmScheduler", "Cancelled alarm for occurrence $occurrenceId")
    }

    fun fire(
        context: Context,
        occurrenceId: Long,
        title: String,
        isAlarmStyle: Boolean,
        nagMinutes: Int,
        nagMax: Int,
        nagCount: Int
    ) {
        AppLogger.i("UnifiedAlarmScheduler", "Firing reminder for occurrence $occurrenceId ($title)")

        // Permission check on Android 13+
        if (Build.VERSION.SDK_INT >= 33 &&
            context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) {
            AppLogger.w("UnifiedAlarmScheduler", "POST_NOTIFICATIONS not granted. Cannot display notification.")
            return
        }

        NotificationChannels.init(context)
        val channelId = if (isAlarmStyle) {
            NotificationChannels.CHANNEL_REMINDERS_ALARM_V2
        } else {
            NotificationChannels.CHANNEL_REMINDERS_V2
        }

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            putExtra("occurrenceId", occurrenceId)
            putExtra("dailyTab", "today")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val contentPending = PendingIntent.getActivity(
            context,
            occurrenceId.toInt(),
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Broadcast actions targeting NotificationActionReceiver
        fun actionPending(action: String, requestCode: Int): PendingIntent {
            val intent = Intent(context, NotificationActionReceiver::class.java).apply {
                putExtra("occurrenceId", occurrenceId)
                putExtra("action", action)
                putExtra("notificationId", notificationId(occurrenceId))
                putExtra("taskTitle", title)
            }
            return PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        val builder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.ic_stat_remember)
            .setContentTitle(title)
            .setContentText("Your scheduled reminder")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(if (isAlarmStyle) NotificationCompat.CATEGORY_ALARM else NotificationCompat.CATEGORY_REMINDER)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentIntent(contentPending)
            .setAutoCancel(true)
            .addAction(
                R.drawable.ic_stat_remember,
                "Done",
                actionPending("mark_done", (occurrenceId * 10 + 1).toInt())
            )
            .addAction(
                R.drawable.ic_stat_remember,
                "Snooze 10m",
                actionPending("snooze_10", (occurrenceId * 10 + 2).toInt())
            )

        if (isAlarmStyle) {
            builder.setFullScreenIntent(contentPending, true)
        }

        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(notificationId(occurrenceId), builder.build())

        // Handle "Nag until done" if enabled
        if (nagMinutes > 0 && nagCount < nagMax) {
            val nextNagTime = System.currentTimeMillis() + (nagMinutes * 60 * 1000L)
            schedule(context, occurrenceId, title, nextNagTime, isAlarmStyle, nagMinutes, nagMax, nagCount + 1)
        }
    }

    fun restoreAll(context: Context) {
        val records = getScheduledRecords(context)
        val now = System.currentTimeMillis()
        AppLogger.i("UnifiedAlarmScheduler", "Restoring ${records.length()} alarms after system reboot/update")
        for (i in 0 until records.length()) {
            val rec = records.getJSONObject(i)
            val time = rec.getLong("triggerAt")
            val id = rec.getLong("occurrenceId")
            if (time > now) {
                schedule(
                    context,
                    id,
                    rec.getString("title"),
                    time,
                    rec.optBoolean("isAlarmStyle", false),
                    rec.optInt("nagMinutes", 0),
                    rec.optInt("nagMax", 0),
                    rec.optInt("nagCount", 0)
                )
            }
        }
    }

    fun reconcile(context: Context, desired: List<JSONObject>) {
        val current = getScheduledRecords(context)
        val desiredIds = desired.map { it.getLong("occurrenceId") }.toSet()
        AppLogger.i("UnifiedAlarmScheduler", "Reconciling alarms: ${desired.size} desired, ${current.length()} currently scheduled")

        // 1. Cancel and remove records that are not in desired
        for (i in 0 until current.length()) {
            val rec = current.getJSONObject(i)
            val id = rec.getLong("occurrenceId")
            if (!desiredIds.contains(id)) {
                cancel(context, id)
            }
        }

        // 2. Schedule all desired
        for (item in desired) {
            schedule(
                context,
                item.getLong("occurrenceId"),
                item.getString("title"),
                item.getLong("triggerAt"),
                item.optBoolean("isAlarmStyle", false),
                item.optInt("nagMinutes", 0),
                item.optInt("nagMax", 0),
                item.optInt("nagCount", 0)
            )
        }
    }

    private fun notificationId(occurrenceId: Long): Int = (0x40000000 + (occurrenceId % 1000000)).toInt()

    private fun saveRecord(
        context: Context,
        occurrenceId: Long,
        title: String,
        triggerAt: Long,
        isAlarmStyle: Boolean,
        nagMinutes: Int,
        nagMax: Int,
        nagCount: Int
    ) {
        val p = prefs(context)
        val records = JSONArray(p.getString(KEY_SCHEDULED, "[]") ?: "[]")
        val updated = JSONArray()
        for (i in 0 until records.length()) {
            val item = records.getJSONObject(i)
            if (item.getLong("occurrenceId") != occurrenceId) {
                updated.put(item)
            }
        }
        val newObj = JSONObject().apply {
            put("occurrenceId", occurrenceId)
            put("title", title)
            put("triggerAt", triggerAt)
            put("isAlarmStyle", isAlarmStyle)
            put("nagMinutes", nagMinutes)
            put("nagMax", nagMax)
            put("nagCount", nagCount)
        }
        updated.put(newObj)
        p.edit().putString(KEY_SCHEDULED, updated.toString()).apply()
    }

    private fun removeRecord(context: Context, occurrenceId: Long) {
        val p = prefs(context)
        val records = JSONArray(p.getString(KEY_SCHEDULED, "[]") ?: "[]")
        val updated = JSONArray()
        for (i in 0 until records.length()) {
            val item = records.getJSONObject(i)
            if (item.getLong("occurrenceId") != occurrenceId) {
                updated.put(item)
            }
        }
        p.edit().putString(KEY_SCHEDULED, updated.toString()).apply()
    }

    private fun getScheduledRecords(context: Context): JSONArray {
        val p = prefs(context)
        return JSONArray(p.getString(KEY_SCHEDULED, "[]") ?: "[]")
    }
}

class RepeatReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        AppLogger.i("RepeatReminderReceiver", "Received broadcast action=$action")

        if (action == "remember_me.ALARM_TRIGGER") {
            val occurrenceId = intent.getLongExtra("occurrenceId", 0L)
            val title = intent.getStringExtra("title") ?: "Reminder"
            val isAlarmStyle = intent.getBooleanExtra("isAlarmStyle", false)
            val nagMinutes = intent.getIntExtra("nagMinutes", 0)
            val nagMax = intent.getIntExtra("nagMax", 0)
            val nagCount = intent.getIntExtra("nagCount", 0)

            UnifiedAlarmScheduler.fire(context, occurrenceId, title, isAlarmStyle, nagMinutes, nagMax, nagCount)
        } else {
            // BOOT_COMPLETED, MY_PACKAGE_REPLACED, TIMEZONE_CHANGED, TIME_SET, etc.
            UnifiedAlarmScheduler.restoreAll(context)
        }
    }
}

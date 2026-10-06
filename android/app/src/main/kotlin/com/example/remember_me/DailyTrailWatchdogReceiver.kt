package com.example.remember_me

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class DailyTrailWatchdogReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
        val isTrackingEnabled = prefs.getBoolean("tracking", false)
        if (!isTrackingEnabled) {
            cancel(context)
            return
        }

        val lastHeartbeat = prefs.getLong("trail_heartbeat", 0L)
        val now = System.currentTimeMillis()
        val missedTime = now - lastHeartbeat

        if (missedTime > 90_000L) {
            AppLogger.w("TrailWatchdog", "DailyTrailService missed heartbeat by ${missedTime / 1000}s. Restarting service.")
            try {
                val serviceIntent = Intent(context, DailyTrailService::class.java)
                if (Build.VERSION.SDK_INT >= 26) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            } catch (e: Exception) {
                AppLogger.e("TrailWatchdog", "Failed to restart DailyTrailService: ${e.message}", e)
            }
        }

        // Reschedule watchdog for next 90 seconds
        schedule(context)
    }

    companion object {
        private const val REQUEST_CODE = 41099
        private const val WATCHDOG_INTERVAL_MS = 90_000L

        fun schedule(context: Context) {
            val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
            if (!prefs.getBoolean("tracking", false)) return

            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
            val intent = Intent(context, DailyTrailWatchdogReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val triggerAt = System.currentTimeMillis() + WATCHDOG_INTERVAL_MS
            try {
                if (Build.VERSION.SDK_INT >= 31 && !alarmManager.canScheduleExactAlarms()) {
                    alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pendingIntent)
                } else {
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pendingIntent)
                }
            } catch (e: Exception) {
                try {
                    alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAt, pendingIntent)
                } catch (_: Exception) {}
            }
        }

        fun cancel(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
            val intent = Intent(context, DailyTrailWatchdogReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            )
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
            }
        }
    }
}

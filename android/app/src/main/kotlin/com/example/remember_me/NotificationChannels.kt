package com.example.remember_me

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build

object NotificationChannels {
    const val CHANNEL_REMINDERS_V2 = "reminders_v2"
    const val CHANNEL_REMINDERS_ALARM_V2 = "reminders_alarm_v2"
    const val CHANNEL_PLACE_ALERTS_V2 = "place_alerts_v2"
    const val CHANNEL_TRAIL_STATUS = "trail_status"

    fun init(context: Context) {
        if (Build.VERSION.SDK_INT < 26) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // 1. Delete legacy channels
        deleteLegacyChannels(manager)

        // 2. Create reminders_v2
        val defaultSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val soundAttrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val remindersChannel = NotificationChannel(
            CHANNEL_REMINDERS_V2,
            "Task Reminders",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Reminders for scheduled tasks and checklists"
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 250, 150, 250)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setSound(defaultSound, soundAttrs)
        }
        manager.createNotificationChannel(remindersChannel)

        // 3. Create reminders_alarm_v2 (Alarm-style)
        val alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
        val alarmAttrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val alarmChannel = NotificationChannel(
            CHANNEL_REMINDERS_ALARM_V2,
            "Alarm-Style Reminders",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Urgent high-priority alarms that wake your screen"
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 500, 250, 500, 250, 500)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setSound(alarmSound, alarmAttrs)
        }
        manager.createNotificationChannel(alarmChannel)

        // 4. Create place_alerts_v2
        val placeChannel = NotificationChannel(
            CHANNEL_PLACE_ALERTS_V2,
            "Place & Arrival Alerts",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Geofenced arrival reminders for saved places"
            enableVibration(true)
            setSound(defaultSound, soundAttrs)
        }
        manager.createNotificationChannel(placeChannel)

        // 5. Create trail_status (silent foreground notification)
        val trailChannel = NotificationChannel(
            CHANNEL_TRAIL_STATUS,
            "Trail Recording Status",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Ongoing notification while movement recording is active"
            enableVibration(false)
            setSound(null, null)
        }
        manager.createNotificationChannel(trailChannel)
    }

    private fun deleteLegacyChannels(manager: NotificationManager) {
        val legacy = listOf(
            "remember_me_daily_reminders",
            "remember_me_summary",
            "remember_me_overdue",
            "daily_trail"
        )
        for (id in legacy) {
            try {
                manager.deleteNotificationChannel(id)
            } catch (_: Exception) {}
        }
    }

    fun updateCustomSound(context: Context, soundUriString: String?) {
        if (Build.VERSION.SDK_INT < 26) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val uri = if (soundUriString.isNullOrBlank()) {
            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        } else {
            Uri.parse(soundUriString)
        }
        val soundAttrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val channel = NotificationChannel(
            CHANNEL_REMINDERS_V2,
            "Task Reminders",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Reminders for scheduled tasks and checklists"
            enableVibration(true)
            setSound(uri, soundAttrs)
        }
        manager.createNotificationChannel(channel)
    }
}

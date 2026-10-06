package com.example.remember_me

import android.Manifest
import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import org.json.JSONObject

/** One rolling alarm per series, independent of Flutter and safe across reboots. */
object RepeatReminders {
    private fun prefs(context: Context) = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
    private fun rules(context: Context) = JSONObject(prefs(context).getString("repeatRules", "{}") ?: "{}")
    private fun notificationId(id: Int) = 0x40000000 + id
    private fun alarm(context: Context, id: Int, time: Long = 0L): PendingIntent = PendingIntent.getBroadcast(context, id,
        Intent(context, RepeatReminderReceiver::class.java).setAction("remember_me.REPEAT").putExtra("task", id).putExtra("time", time), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    fun save(context: Context, id: Int, title: String, anchor: Long, rule: String) {
        val all = rules(context)
        val old = all.optJSONObject(id.toString())
        val data = JSONObject(rule).put("title", title).put("anchor", anchor).put("skipped", old?.optJSONArray("skipped") ?: org.json.JSONArray())
        all.put(id.toString(), data); prefs(context).edit().putString("repeatRules", all.toString()).apply()
        schedule(context, id, data)
    }
    fun cancel(context: Context, id: Int) {
        (context.getSystemService(Context.ALARM_SERVICE) as AlarmManager).cancel(alarm(context, id))
        (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).cancel(notificationId(id))
        val all = rules(context); all.remove(id.toString()); prefs(context).edit().putString("repeatRules", all.toString()).apply()
    }
    fun skip(context: Context, id: Int, day: String, value: Boolean) {
        val all = rules(context); val data = all.optJSONObject(id.toString()) ?: return
        val dates = data.optJSONArray("skipped") ?: org.json.JSONArray()
        val kept = (0 until dates.length()).map { dates.getString(it) }.toMutableSet()
        if(value) kept.add(day) else kept.remove(day)
        data.put("skipped", org.json.JSONArray(kept.toList())); all.put(id.toString(), data)
        prefs(context).edit().putString("repeatRules", all.toString()).apply()
        if (value) (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).cancel(notificationId(id))
        schedule(context, id, data)
    }
    private fun schedule(context: Context, id: Int, data: JSONObject) {
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val array = data.getJSONArray("days"); val days = (0 until array.length()).map { array.getInt(it) }.toSet()
        val skip = data.optJSONArray("skipped") ?: org.json.JSONArray(); val skipped = (0 until skip.length()).map { skip.getString(it) }.toSet()
        val next = RepeatClock.next(System.currentTimeMillis(), data.getLong("anchor"), data.getString("kind"), days, skipped)
        manager.cancel(alarm(context,id))
        if(next == null) return
        val pending = alarm(context,id,next)
        if(Build.VERSION.SDK_INT < 31 || manager.canScheduleExactAlarms()) {
            try { manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next, pending); return } catch (_: SecurityException) { }
        }
        manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next, pending)
    }
    fun restore(context: Context) { val all=rules(context); for(key in all.keys()) schedule(context,key.toInt(),all.getJSONObject(key)) }
    fun fire(context: Context, id: Int, time: Long) {
        val data = rules(context).optJSONObject(id.toString()) ?: return
        val day = RepeatClock.day(time)
        val skipped = data.optJSONArray("skipped") ?: org.json.JSONArray()
        val suppress = (0 until skipped.length()).any { skipped.getString(it) == day }
        if(!suppress && (Build.VERSION.SDK_INT < 33 || context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED)) {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if(Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel("remember_me_daily_reminders","Reminders",NotificationManager.IMPORTANCE_HIGH))
            fun intent(action: String, request: Int): PendingIntent = PendingIntent.getActivity(context, request,
                Intent(context,MainActivity::class.java).setAction("remember_me.$action.$id").putExtra("repeatTask",id).putExtra("repeatAction",action).putExtra("repeatDate",day), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            val builder = if(Build.VERSION.SDK_INT >= 26) Notification.Builder(context,"remember_me_daily_reminders") else Notification.Builder(context)
            manager.notify(notificationId(id),builder.setSmallIcon(R.drawable.ic_stat_remember).setContentTitle(data.getString("title"))
                .setContentText("Your scheduled reminder").setCategory(Notification.CATEGORY_REMINDER).setPriority(Notification.PRIORITY_HIGH)
                .setContentIntent(intent("open",id*4)).setAutoCancel(true)
                .addAction(Notification.Action.Builder(null,"Done",intent("mark_done",id*4+1)).build())
                .addAction(Notification.Action.Builder(null,"Snooze 10m",intent("snooze_10",id*4+2)).build()).build())
        }
        schedule(context,id,data)
    }
}
class RepeatReminderReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if(intent.action == "remember_me.REPEAT") RepeatReminders.fire(context,intent.getIntExtra("task",0),intent.getLongExtra("time",System.currentTimeMillis()))
        else RepeatReminders.restore(context)
    }
}

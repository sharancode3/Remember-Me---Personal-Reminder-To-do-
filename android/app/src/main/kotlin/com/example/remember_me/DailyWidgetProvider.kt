package com.example.remember_me

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DailyWidgetProvider : AppWidgetProvider() {
    companion object {
        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, DailyWidgetProvider::class.java))
            DailyWidgetProvider().onUpdate(context, manager, ids)
        }
    }
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
        val snapshot = try { JSONObject(prefs.getString("widget", "{}") ?: "{}") } catch (_: Exception) { JSONObject() }
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        val end = prefs.getLong("focusEnd", 0)
        for (id in ids) {
            val view = RemoteViews(context.packageName, R.layout.daily_widget)
            view.setTextViewText(R.id.widget_title, "Remember Me")
            view.setTextViewText(R.id.widget_next, if (end > System.currentTimeMillis()) "Focus until ${SimpleDateFormat("h:mm a", Locale.getDefault()).format(Date(end))}" else if (snapshot.optString("date") == today) snapshot.optString("next", "Your day is clear") else "Open your day")
            view.setTextViewText(R.id.widget_count, if (snapshot.optString("date") == today) snapshot.optString("summary", "") else "")
            fun launch(tab: String, request: Int) = PendingIntent.getActivity(context, request, Intent(context, MainActivity::class.java).putExtra("dailyTab", tab).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            view.setOnClickPendingIntent(R.id.widget_root, launch("today", 520))
            view.setOnClickPendingIntent(R.id.widget_add, launch("add", 521))
            view.setOnClickPendingIntent(R.id.widget_focus, launch("focus", 522))
            manager.updateAppWidget(id, view)
        }
    }
}

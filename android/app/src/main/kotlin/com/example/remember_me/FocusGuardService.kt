package com.example.remember_me

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import org.json.JSONArray
import org.json.JSONObject

object FocusState {
    fun finish(context: Context) {
        val prefs = context.getSharedPreferences("daily", Context.MODE_PRIVATE)
        val start = prefs.getLong("focusStart", 0)
        if (start == 0L) return
        val end = minOf(System.currentTimeMillis(), prefs.getLong("focusEnd", System.currentTimeMillis())).coerceAtLeast(start)
        val history = JSONArray(prefs.getString("focusHistory", "[]"))
        history.put(JSONObject().put("start", start).put("end", end))
        prefs.edit().putString("focusHistory", history.toString()).remove("focusStart").remove("focusEnd").remove("focusPin").putBoolean("focusBlock", false).apply()
        DailyWidgetProvider.updateAll(context)
    }
}

/** Observes app package changes only. It never reads screen content or key input. */
class FocusGuardService : AccessibilityService() {
    companion object { var instance: FocusGuardService? = null; private set }
    private val handler = Handler(Looper.getMainLooper())
    private val prefs by lazy { getSharedPreferences("daily", MODE_PRIVATE) }
    private val windows by lazy { getSystemService(WINDOW_SERVICE) as WindowManager }
    private var overlay: View? = null
    private var timerLabel: TextView? = null
    private var currentPackage = ""
    private var mode = ""
    private val ticker = object : Runnable {
        override fun run() {
            if (prefs.getLong("focusEnd", 0) <= System.currentTimeMillis()) {
                FocusState.finish(this@FocusGuardService)
                removeOverlay()
                return
            }
            timerLabel?.text = remaining()
            handler.postDelayed(this, 1000)
        }
    }
    override fun onServiceConnected() { instance = this }
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val pkg = event.packageName?.toString() ?: return
        if (pkg == packageName && event.className?.toString() != MainActivity::class.java.name) return
        currentPackage = pkg
        refresh()
    }
    fun refresh() {
        val end = prefs.getLong("focusEnd", 0)
        if (end <= System.currentTimeMillis() || !prefs.getBoolean("focusBlock", false)) {
            if (end > 0 && end <= System.currentTimeMillis()) FocusState.finish(this)
            removeOverlay(); return
        }
        val home = packageManager.resolveActivity(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME), 0)?.activityInfo?.packageName
        val allowed = prefs.getStringSet("allowedApps", emptySet()) ?: emptySet()
        val essential = currentPackage == packageName || currentPackage == home || currentPackage == "android" ||
            currentPackage == "com.android.settings" || currentPackage.contains("permissioncontroller") || currentPackage.contains("packageinstaller") ||
            currentPackage == (getSystemService(TELECOM_SERVICE) as android.telecom.TelecomManager).defaultDialerPackage
        if (currentPackage.contains("systemui") || currentPackage.isEmpty() || currentPackage == packageName) { removeOverlay(); return }
        if (essential || allowed.contains(currentPackage)) showBubble() else {
            if (packageManager.getLaunchIntentForPackage(currentPackage) != null) showBlocker() else removeOverlay()
        }
    }
    private fun remaining(): String {
        val seconds = ((prefs.getLong("focusEnd", 0) - System.currentTimeMillis()) / 1000).coerceAtLeast(0)
        return "%02d:%02d".format(seconds / 60, seconds % 60)
    }
    private fun label(text: String, size: Float): TextView = TextView(this).apply {
        this.text = text; textSize = size; setTextColor(Color.rgb(29, 53, 44)); gravity = Gravity.CENTER
        setPadding(16, 12, 16, 12)
    }
    fun ownAppVisible() { currentPackage = packageName; removeOverlay() }
    private fun openRemember() { removeOverlay(); startActivity(Intent(this, MainActivity::class.java).putExtra("dailyTab", "focus").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)) }
    private fun showBubble() {
        if (mode == "bubble") return
        removeOverlay(); mode = "bubble"
        val text = label(remaining(), 18f).apply {
            background = GradientDrawable().apply { setColor(Color.rgb(229, 245, 236)); cornerRadius = 24f }
            setOnClickListener { openRemember() }
            contentDescription = "Open focus timer"
        }
        timerLabel = text; overlay = text
        windows.addView(text, WindowManager.LayoutParams(110.dp, 48.dp, WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, PixelFormat.TRANSLUCENT).apply { gravity = Gravity.TOP or Gravity.END; x = 12.dp; y = 60.dp })
        handler.post(ticker)
    }
    private fun showBlocker() {
        if (mode == "block:$currentPackage") return
        removeOverlay(); mode = "block:$currentPackage"
        val column = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL; gravity = Gravity.CENTER; setPadding(28.dp, 48.dp, 28.dp, 48.dp)
            setBackgroundColor(Color.rgb(241, 248, 244))
        }
        column.addView(label("Remember Me", 18f))
        column.addView(label("Stay with your focus", 28f).apply { setTypeface(typeface, Typeface.BOLD) })
        val name = try { packageManager.getApplicationLabel(packageManager.getApplicationInfo(currentPackage, 0)).toString() } catch (_: Exception) { "This app" }
        column.addView(label("$name is paused until your timer finishes.", 15f))
        timerLabel = label(remaining(), 48f); column.addView(timerLabel)
        val allowed = prefs.getStringSet("allowedApps", emptySet()) ?: emptySet()
        for (pkg in allowed.take(5)) {
            val launch = packageManager.getLaunchIntentForPackage(pkg) ?: continue
            val nameAllowed = packageManager.getApplicationLabel(packageManager.getApplicationInfo(pkg, 0)).toString()
            column.addView(Button(this).apply { text = "Open $nameAllowed"; setOnClickListener { removeOverlay(); startActivity(launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)) } })
        }
        column.addView(Button(this).apply { text = "Focus timer"; setOnClickListener { removeOverlay(); openRemember() } })
        column.addView(Button(this).apply { text = "Home"; setOnClickListener { performGlobalAction(GLOBAL_ACTION_HOME) } })
        overlay = column
        windows.addView(column, WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN, PixelFormat.TRANSLUCENT))
        handler.post(ticker)
    }
    private val Int.dp: Int get() = (this * resources.displayMetrics.density).toInt()
    private fun removeOverlay() {
        handler.removeCallbacks(ticker)
        overlay?.let { try { windows.removeView(it) } catch (_: Exception) { } }
        overlay = null; timerLabel = null; mode = ""
    }
    override fun onInterrupt() { removeOverlay() }
    override fun onDestroy() { removeOverlay(); instance = null; super.onDestroy() }
}

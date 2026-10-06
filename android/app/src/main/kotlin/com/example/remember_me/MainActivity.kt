package com.example.remember_me

import android.content.Intent
import android.content.ComponentName
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private val handler = Handler(Looper.getMainLooper())
    private val preferences by lazy { getSharedPreferences("daily", MODE_PRIVATE) }
    private val focusExpiry = Runnable { finishFocus() }
    private var trailMaps: GoogleTrailMapFactory? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        trailMaps = GoogleTrailMapFactory(flutterEngine.dartExecutor.binaryMessenger)
        flutterEngine.platformViewsController.registry.registerViewFactory("remember_me/google_map", trailMaps!!)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "remember_me/daily")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "scheduleRepeat" -> { RepeatReminders.save(this, call.argument<Number>("id")!!.toInt(), call.argument<String>("title")!!, call.argument<Number>("anchor")!!.toLong(), call.argument<String>("rule")!!); result.success(null) }
                        "cancelRepeat" -> { RepeatReminders.cancel(this, call.argument<Number>("id")!!.toInt()); result.success(null) }
                        "skipRepeat" -> { RepeatReminders.skip(this,call.argument<Number>("id")!!.toInt(),call.argument<String>("day")!!,call.argument<Boolean>("value") == true); result.success(null) }
                        "consumeRepeatAction" -> {
                            val id = intent.getIntExtra("repeatTask",0)
                            val action = intent.getStringExtra("repeatAction")
                            val day = intent.getStringExtra("repeatDate")
                            if(id != 0 && (action == "mark_done" || action == "snooze_10")) (getSystemService(NOTIFICATION_SERVICE) as android.app.NotificationManager).cancel(0x40000000 + id)
                            intent.removeExtra("repeatTask"); intent.removeExtra("repeatAction"); intent.removeExtra("repeatDate")
                            result.success(if(id == 0) null else mapOf("id" to id,"action" to action,"day" to day))
                        }
                        "timeZone" -> result.success(TimeZone.getDefault().id)
                        "openAttribution" -> { startActivity(Intent(Intent.ACTION_VIEW, android.net.Uri.parse("https://www.openstreetmap.org/copyright"))); result.success(null) }
                        "readTheme" -> result.success(preferences.getString("theme", "mint"))
                        "writeTheme" -> { preferences.edit().putString("theme", call.argument<String>("value")).apply(); result.success(null) }
                        "getPlaces" -> result.success(preferences.getString("places", "[]"))
                        "savePlaces" -> {
                            val data = call.argument<String>("data") ?: "[]"
                            JSONArray(data)
                            preferences.edit().putString("places", data).apply(); result.success(null)
                        }
                        "googleConfigured" -> result.success(packageManager.getApplicationInfo(packageName, android.content.pm.PackageManager.GET_META_DATA).metaData?.getString("com.google.android.geo.API_KEY")?.isNotBlank() == true)
                        "focusGuardEnabled" -> result.success(focusGuardEnabled())
                        "openFocusPermission" -> {
                            val settings = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                            startActivity(settings); result.success(null)
                        }
                        "installedApps" -> {
                            val apps = packageManager.queryIntentActivities(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER), 0)
                                .distinctBy { it.activityInfo.packageName }.filter { it.activityInfo.packageName != packageName }
                                .map { mapOf("package" to it.activityInfo.packageName, "name" to it.loadLabel(packageManager).toString()) }
                                .sortedBy { it["name"]?.lowercase() }
                            result.success(apps)
                        }
                        "allowedApps" -> result.success((preferences.getStringSet("allowedApps", emptySet()) ?: emptySet()).toList())
                        "launchAllowedApp" -> {
                            val pkg = call.argument<String>("package") ?: error("Missing app")
                            require(preferences.getStringSet("allowedApps", emptySet())?.contains(pkg) == true)
                            val launch = packageManager.getLaunchIntentForPackage(pkg) ?: error("App is no longer installed")
                            startActivity(launch); result.success(null)
                        }
                        "saveAllowedApps" -> { preferences.edit().putStringSet("allowedApps", (call.argument<List<String>>("packages") ?: emptyList()).toSet()).apply(); result.success(null) }
                        "updateWidget" -> { preferences.edit().putString("widget", call.argument<String>("data")).apply(); DailyWidgetProvider.updateAll(this); result.success(null) }
                        "pinWidget" -> {
                            if (Build.VERSION.SDK_INT >= 26) {
                                val manager = getSystemService(android.appwidget.AppWidgetManager::class.java)
                                result.success(manager.isRequestPinAppWidgetSupported && manager.requestPinAppWidget(ComponentName(this, DailyWidgetProvider::class.java), null, null))
                            } else result.success(false)
                        }
                        "consumeNavigation" -> { val tab = intent?.getStringExtra("dailyTab"); intent?.removeExtra("dailyTab"); result.success(tab) }
                        "trackingEnabled" -> result.success(preferences.getBoolean("tracking", false))
                        "startTracking" -> {
                            val intent = Intent(this, DailyTrailService::class.java)
                            if (Build.VERSION.SDK_INT >= 26) startForegroundService(intent) else startService(intent)
                            preferences.edit().putBoolean("tracking", true).apply()
                            result.success(null)
                        }
                        "stopTracking" -> {
                            preferences.edit().putBoolean("tracking", false).apply()
                            stopService(Intent(this, DailyTrailService::class.java))
                            result.success(null)
                        }
                        "trackingStatus" -> result.success(mapOf("error" to preferences.getString("trackingError", null)))
                        "readTrail" -> {
                            val file = trailFile(call.argument<String>("day"))
                            val array = JSONArray()
                            if (file.exists()) file.forEachLine { line ->
                                try { array.put(JSONObject(line)) } catch (_: Exception) { /* Ignore a partially written final fix. */ }
                            }
                            result.success(array.toString())
                        }
                        "deleteTrail" -> {
                            val file = trailFile(call.argument<String>("day"))
                            if (file.exists() && !file.delete()) error("Could not delete this trail")
                            result.success(null)
                        }
                        "shareTrail" -> {
                            val bytes = call.argument<ByteArray>("bytes") ?: error("Missing trail image")
                            val directory = File(cacheDir, "shared_trails").apply { mkdirs() }
                            val file = File(directory, "daily-trail.png").apply { writeBytes(bytes) }
                            val uri = FileProvider.getUriForFile(this, "$packageName.trails", file)
                            val share = Intent(Intent.ACTION_SEND).apply {
                                type = "image/png"
                                putExtra(Intent.EXTRA_STREAM, uri)
                                putExtra(Intent.EXTRA_TEXT, "My trail - ${call.argument<String>("date")}")
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }
                            startActivity(Intent.createChooser(share, "Share your trail"))
                            result.success(null)
                        }
                        "startFocus" -> {
                            finishFocus()
                            val start = call.argument<Number>("start")!!.toLong()
                            val end = call.argument<Number>("end")!!.toLong()
                            val pin = call.argument<Boolean>("pin") == true
                            val block = call.argument<Boolean>("block") == true
                            if (block && !focusGuardEnabled()) error("Enable Remember Me Focus in Android Accessibility settings first.")
                            if (pin) startLockTask()
                            preferences.edit().putLong("focusStart", start).putLong("focusEnd", end).putBoolean("focusPin", pin).putBoolean("focusBlock", block).apply()
                            FocusGuardService.instance?.refresh()
                            DailyWidgetProvider.updateAll(this)
                            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                            handler.postDelayed(focusExpiry, (end - System.currentTimeMillis()).coerceAtLeast(0))
                            result.success(null)
                        }
                        "readFocus" -> {
                            expireFocusIfDue()
                            val start = preferences.getLong("focusStart", 0)
                            result.success(if (start == 0L) emptyMap<String, Any>() else mapOf(
                                "start" to start, "end" to preferences.getLong("focusEnd", 0), "pin" to preferences.getBoolean("focusPin", false), "block" to preferences.getBoolean("focusBlock", false)))
                        }
                        "stopFocus" -> { finishFocus(); result.success(null) }
                        "focusMinutes" -> {
                            expireFocusIfDue()
                            val start = call.argument<Number>("start")!!.toLong()
                            val end = call.argument<Number>("end")!!.toLong()
                            val history = JSONArray(preferences.getString("focusHistory", "[]"))
                            var duration = 0L
                            for (i in 0 until history.length()) {
                                val session = history.getJSONObject(i)
                                duration += (minOf(end, session.getLong("end")) - maxOf(start, session.getLong("start"))).coerceAtLeast(0)
                            }
                            result.success((duration / 60000).toInt())
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) { result.error("daily_error", e.message ?: "Phone action failed", null) }
            }
    }

    private fun trailFile(day: String?): File {
        require(day != null && Regex("\\d{4}-\\d{2}-\\d{2}").matches(day)) { "Invalid trail date" }
        val directory = File(filesDir, "trails").apply { mkdirs() }
        return File(directory, "$day.jsonl")
    }

    private fun expireFocusIfDue() {
        val end = preferences.getLong("focusEnd", 0)
        if (end > 0 && end <= System.currentTimeMillis()) finishFocus()
    }

    private fun finishFocus() {
        handler.removeCallbacks(focusExpiry)
        val start = preferences.getLong("focusStart", 0)
        if (start == 0L) return
        FocusState.finish(this)
        FocusGuardService.instance?.refresh()
        try { stopLockTask() } catch (_: Exception) { }
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }
    private fun focusGuardEnabled(): Boolean {
        val manager = getSystemService(ACCESSIBILITY_SERVICE) as AccessibilityManager
        return manager.getEnabledAccessibilityServiceList(android.accessibilityservice.AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
            .any { it.resolveInfo.serviceInfo.packageName == packageName && it.resolveInfo.serviceInfo.name == FocusGuardService::class.java.name }
    }
    override fun onNewIntent(intent: Intent) { super.onNewIntent(intent); setIntent(intent) }

    override fun onResume() {
        super.onResume()
        FocusGuardService.instance?.ownAppVisible()
        trailMaps?.resume()
        expireFocusIfDue()
        val end = preferences.getLong("focusEnd", 0)
        if (end > System.currentTimeMillis()) {
            handler.removeCallbacks(focusExpiry)
            handler.postDelayed(focusExpiry, end - System.currentTimeMillis())
        }
    }
    override fun onPause() { trailMaps?.pause(); super.onPause() }
    override fun onDestroy() { trailMaps?.destroy(); handler.removeCallbacks(focusExpiry); super.onDestroy() }
}

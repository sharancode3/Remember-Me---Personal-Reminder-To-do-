package com.example.remember_me

import android.content.Context
import android.util.Log
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Production ring-buffered structured logger for Remember Me native layer.
 * Caps disk logs at 2 MB to protect user storage.
 */
object AppLogger {
    private const val TAG = "RememberMeNative"
    private const val MAX_LOG_SIZE_BYTES = 2L * 1024L * 1024L // 2 MB
    private val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US)
    private var logFile: File? = null

    fun init(context: Context) {
        try {
            val logDir = File(context.filesDir, "logs").apply { mkdirs() }
            logFile = File(logDir, "app_diagnostics.log")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize native diagnostic log file", e)
        }
    }

    fun d(tag: String, message: String) {
        Log.d(tag, message)
        append("DEBUG", tag, message)
    }

    fun i(tag: String, message: String) {
        Log.i(tag, message)
        append("INFO", tag, message)
    }

    fun w(tag: String, message: String, throwable: Throwable? = null) {
        Log.w(tag, message, throwable)
        append("WARN", tag, message, throwable)
    }

    fun e(tag: String, message: String, throwable: Throwable? = null) {
        Log.e(tag, message, throwable)
        append("ERROR", tag, message, throwable)
    }

    @Synchronized
    private fun append(level: String, tag: String, message: String, throwable: Throwable? = null) {
        val file = logFile ?: return
        try {
            val timestamp = dateFormat.format(Date())
            val sb = java.lang.StringBuilder()
            sb.append(timestamp).append(" [").append(level.padEnd(5)).append("] [").append(tag).append("]: ").append(message).append("\n")
            if (throwable != null) {
                sb.append("  Exception: ").append(Log.getStackTraceString(throwable)).append("\n")
            }
            file.appendText(sb.toString())

            if (file.length() > MAX_LOG_SIZE_BYTES) {
                trimRingBuffer(file)
            }
        } catch (_: Exception) {
            // Never crash the background service due to logging errors
        }
    }

    private fun trimRingBuffer(file: File) {
        try {
            val lines = file.readLines()
            if (lines.size > 1000) {
                val preserved = lines.takeLast(1000).joinToString("\n") + "\n"
                file.writeText(preserved)
            }
        } catch (_: Exception) { }
    }
}

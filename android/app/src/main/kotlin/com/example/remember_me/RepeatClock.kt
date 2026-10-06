package com.example.remember_me

import java.time.Instant
import java.time.ZoneId

object RepeatClock {
    fun next(after: Long, anchor: Long, kind: String, days: Set<Int>, skipped: Set<String>, zone: ZoneId = ZoneId.systemDefault()): Long? {
        val start = Instant.ofEpochMilli(anchor).atZone(zone)
        var date = Instant.ofEpochMilli(after).atZone(zone).toLocalDate()
        repeat(740) {
            val selected = when(kind) {
                "daily" -> true
                "weekly" -> days.contains(date.dayOfWeek.value)
                "monthly" -> days.contains(date.dayOfMonth)
                else -> false
            }
            val time = date.atTime(start.hour, start.minute).atZone(zone).toInstant().toEpochMilli()
            if (!date.isBefore(start.toLocalDate()) && selected && !skipped.contains(date.toString()) && time > after) return time
            date = date.plusDays(1)
        }
        return null
    }
    fun day(time: Long): String = Instant.ofEpochMilli(time).atZone(ZoneId.systemDefault()).toLocalDate().toString()
}

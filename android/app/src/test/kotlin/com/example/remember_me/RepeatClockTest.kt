package com.example.remember_me

import java.time.ZoneId
import java.time.ZonedDateTime
import org.junit.Assert.*
import org.junit.Test

class RepeatClockTest {
    private val zone = ZoneId.of("Asia/Kolkata")
    private fun time(date: String) = ZonedDateTime.parse("${date}+05:30[Asia/Kolkata]").toInstant().toEpochMilli()
    @Test fun futureStartIsRespected() {
        assertEquals(time("2026-10-10T09:00:00"), RepeatClock.next(time("2026-10-01T10:00:00"),time("2026-10-10T09:00:00"),"daily",emptySet(),emptySet(),zone))
    }
    @Test fun completionSkipsTodayNotTomorrow() {
        assertEquals(time("2026-10-04T09:00:00"), RepeatClock.next(time("2026-10-03T08:00:00"),time("2026-10-01T09:00:00"),"daily",emptySet(),setOf("2026-10-03"),zone))
    }
    @Test fun monthly31DoesNotClamp() {
        assertEquals(time("2026-03-31T09:00:00"),RepeatClock.next(time("2026-01-31T10:00:00"),time("2026-01-01T09:00:00"),"monthly",setOf(31),emptySet(),zone))
    }
    @Test fun weekdaySelectionWorks() {
        assertEquals(time("2026-10-07T09:00:00"),RepeatClock.next(time("2026-10-05T10:00:00"),time("2026-10-01T09:00:00"),"weekly",setOf(1,3),emptySet(),zone))
    }
    @Test fun springClockChangeStillUsesLocalReminderTime() {
        val zone = ZoneId.of("America/New_York")
        val anchor = ZonedDateTime.of(2026,3,7,9,0,0,0,zone).toInstant().toEpochMilli()
        val next = RepeatClock.next(anchor,anchor,"daily",emptySet(),emptySet(),zone)!!
        assertEquals(23*3600000L,next-anchor)
    }
}

package com.example.remember_me

import org.junit.Assert.*
import org.junit.Test
import kotlin.math.sin

class TrailQualityFilterTest {
    @Test fun stationaryJitterDoesNotCreateMovement() {
        val filter = TrailQualityFilter()
        val accepted = (0..120).mapNotNull { i -> filter.accept(TrailSample(12.0 + sin(i.toDouble()) * .00008, 77.0, i * 3000L, 12.0, 0.0, false)) }
        assertEquals(1, accepted.size)
    }
    @Test fun realWalkProducesFilteredTrail() {
        val filter = TrailQualityFilter()
        val accepted = (0..20).mapNotNull { i -> filter.accept(TrailSample(12.0 + i * .00007, 77.0, i * 5000L, 4.0, 1.5, true)) }
        assertTrue(accepted.size > 10)
        assertTrue(accepted.last().latitude > 12.001)
        assertTrue(accepted.last().speed in .5..3.0)
    }
    @Test fun inaccurateAndTeleportSamplesAreRejected() {
        val filter = TrailQualityFilter()
        assertNull(filter.accept(TrailSample(12.0, 77.0, 0, 90.0, 0.0, false)))
        filter.accept(TrailSample(12.0, 77.0, 1000, 5.0, 0.0, false))
        assertNull(filter.accept(TrailSample(13.0, 77.0, 4000, 5.0, 1.0, true)))
        assertEquals(2, filter.rejected)
    }
    @Test fun longGapStartsANewSegmentAndOldTimeIsIgnored() {
        val filter = TrailQualityFilter()
        filter.accept(TrailSample(12.0, 77.0, 1000, 5.0, 0.0, false))
        assertNull(filter.accept(TrailSample(12.0, 77.0, 500, 5.0, 0.0, false)))
        assertTrue(filter.accept(TrailSample(12.5, 77.0, 181000, 5.0, 0.0, false))!!.gap)
    }
    @Test fun walkingWithoutReportedSpeedUsesMotionAndDisplacement() {
        val filter = TrailQualityFilter()
        val accepted = (0..30).mapNotNull { i ->
            filter.accept(TrailSample(12.0 + i * .00007, 77.0, i * 5000L, 4.0, null, true))
        }
        assertTrue(accepted.size > 15)
        assertTrue(accepted.last().speed in .5..3.0)
    }
    @Test fun drivingDoesNotRequireAccelerometerEvidence() {
        val filter = TrailQualityFilter()
        val accepted = (0..30).mapNotNull { i ->
            filter.accept(TrailSample(12.0 + i * .00036, 77.0, i * 5000L, 5.0, 8.0, false))
        }
        assertTrue(accepted.size > 20)
        assertEquals(8.0, accepted.last().speed, 1.0)
        assertFalse(accepted.last().gap)
    }
    @Test fun walkingRecoversAfterOneTeleport() {
        val filter = TrailQualityFilter()
        for (i in 0..10) filter.accept(TrailSample(12.0 + i * .00007, 77.0, i * 5000L, 4.0, 1.5, true))
        assertNull(filter.accept(TrailSample(13.0, 78.0, 55000, 4.0, 1.5, true)))
        val accepted = (12..25).mapNotNull { i ->
            filter.accept(TrailSample(12.0 + i * .00007, 77.0, i * 5000L, 4.0, 1.5, true))
        }
        assertTrue(accepted.size > 8)
        assertEquals(1, filter.rejected)
        assertTrue(accepted.last().latitude < 12.002)
    }
    @Test fun invalidCoordinatesAndUncertaintyCannotPoisonTheNextFix() {
        val filter = TrailQualityFilter()
        assertNull(filter.accept(TrailSample(Double.NaN, 77.0, 0, 5.0, null, false)))
        assertNull(filter.accept(TrailSample(91.0, 77.0, 1000, 5.0, null, false)))
        assertNull(filter.accept(TrailSample(12.0, 181.0, 2000, 5.0, null, false)))
        assertNull(filter.accept(TrailSample(12.0, 77.0, 3000, Double.NaN, null, false)))
        assertNotNull(filter.accept(TrailSample(12.0, 77.0, 4000, 5.0, null, false)))
        assertEquals(4, filter.rejected)
    }
    @Test fun resetAtMidnightStartsAFreshAnchor() {
        val filter = TrailQualityFilter()
        filter.accept(TrailSample(12.0, 77.0, 1000, 5.0, 0.0, false))
        filter.reset()
        val first = filter.accept(TrailSample(13.0, 78.0, 4000, 5.0, 0.0, false))!!
        assertEquals(13.0, first.latitude, 0.0)
        assertFalse(first.gap)
        assertEquals(0.0, first.speed, 0.0)
    }
}

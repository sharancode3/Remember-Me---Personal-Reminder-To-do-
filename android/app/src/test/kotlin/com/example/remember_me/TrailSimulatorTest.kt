package com.example.remember_me

import org.junit.Assert.*
import org.junit.Test
import kotlin.math.sin

class TrailSimulatorTest {

    @Test
    fun testScenarioA_NormalWalk() {
        val filter = TrailQualityFilter()
        // 5 m/s walk/jog, 5m accuracy, 5s interval = 25m displacement per sample
        // 1m in latitude ≈ 0.000009 degrees -> 25m ≈ 0.000225 degrees
        val accepted = mutableListOf<CleanFix>()
        for (i in 0..100) {
            val sample = TrailSample(
                latitude = 12.0 + (i * 25.0 * 0.000009),
                longitude = 77.0,
                time = i * 5000L,
                accuracy = 5.0,
                speed = 5.0,
                motion = true
            )
            filter.accept(sample)?.let { accepted.add(it) }
        }
        println("Scenario A (Normal Walk): 101 samples, accepted=${accepted.size}, rejected=${filter.rejected}")
        assertTrue("Normal walk should accept almost all samples", accepted.size > 95)
        assertEquals(0, filter.rejected)
    }

    @Test
    fun testScenarioB_StationaryAtDeskFor2Hours() {
        val filter = TrailQualityFilter()
        // 2 hours = 7200 seconds, 5s interval = 1440 samples
        // Accuracy bouncing between 8m and 35m, 0 real displacement
        val accepted = mutableListOf<CleanFix>()
        var accumulatedDistance = 0.0
        var prevFix: CleanFix? = null

        for (i in 0..1440) {
            val noise = sin(i.toDouble()) * 0.00008 // ~9m GPS drift noise
            val acc = 8.0 + (i % 28) // bounces 8m to 35m
            val sample = TrailSample(
                latitude = 12.0 + noise,
                longitude = 77.0,
                time = i * 5000L,
                accuracy = acc,
                speed = 0.0,
                motion = false
            )
            val outputs = filter.process(sample)
            for (out in outputs) {
                if (out is TrailOutput.Fix) {
                    accepted.add(out)
                    if (prevFix != null) {
                        accumulatedDistance += TrailQualityFilter.distance(
                            prevFix!!.latitude, prevFix!!.longitude,
                            out.latitude, out.longitude
                        )
                    }
                    prevFix = out
                }
            }
        }
        println("Scenario B (Stationary 2h): accepted=${accepted.size}, accumulatedDistance=${accumulatedDistance}m, isStationary=${filter.isStationary}")
        assertTrue("Stationary detector must engage", filter.isStationary)
        assertEquals("Stationary must suppress all jitter points after initial anchor", 1, accepted.size)
        assertEquals("Phantom distance must be 0", 0.0, accumulatedDistance, 0.001)
    }

    @Test
    fun testScenarioC_MetroRideTunnelRecovery() {
        val filter = TrailQualityFilter()
        // 1. Entry fix before tunnel: t=0, lat=12.0, lng=77.0, acc=5m
        val entryFixes = filter.process(TrailSample(12.0, 77.0, 0L, 5.0, 15.0, true))
        assertEquals(1, entryFixes.size)
        assertTrue(entryFixes.first() is TrailOutput.Fix)

        // 2. 12-minute tunnel blackout (zero fixes)
        // Tunnel exit fix: t=720s (12 mins), 8km away (approx 0.072 degrees lat), initial coarse accuracy 60m
        val postTunnelSample1 = TrailSample(
            latitude = 12.072,
            longitude = 77.0,
            time = 720_000L,
            accuracy = 60.0, // initial cellular/coarse post-tunnel fix
            speed = 18.0, // 65 km/h
            motion = true
        )

        // First fix after tunnel gap is accepted on probation (accuracy <= 100m)
        val exitEvents1 = filter.process(postTunnelSample1)
        assertEquals(0, filter.rejected)
        assertEquals("Should emit gap and probation fix", 2, exitEvents1.size)

        val gapEvent = exitEvents1[0] as TrailOutput.Gap
        assertEquals(0L, gapEvent.start)
        assertEquals(720_000L, gapEvent.end)
        assertEquals("tunnel_or_loss", gapEvent.reason)

        val fix1 = exitEvents1[1] as TrailOutput.Fix
        assertEquals(720_000L, fix1.time)
        assertTrue(fix1.gap)

        // 3. Second fix arrives 5s later at t=725s with 20m accuracy, confirming track
        val postTunnelSample2 = TrailSample(
            latitude = 12.0728, // ~90m further (18 m/s * 5s)
            longitude = 77.0,
            time = 725_000L,
            accuracy = 20.0,
            speed = 18.0,
            motion = true
        )

        val exitEvents2 = filter.process(postTunnelSample2)
        assertEquals("Should emit confirming fix", 1, exitEvents2.size)

        val fix2 = exitEvents2[0] as TrailOutput.Fix
        assertEquals(725_000L, fix2.time)
        assertFalse(fix2.gap)
    }

    @Test
    fun testScenarioD_BadTeleportOutlier() {
        val filter = TrailQualityFilter()
        // Base fixes
        filter.process(TrailSample(12.0, 77.0, 0L, 5.0, 1.0, true))
        filter.process(TrailSample(12.00005, 77.0, 5000L, 5.0, 1.0, true))

        // Single 500m outlier fix with 15m reported accuracy at t=10s (500m in 5s = 100 m/s > 45 m/s)
        val outlierSample = TrailSample(
            latitude = 12.0045,
            longitude = 77.0,
            time = 10000L,
            accuracy = 15.0,
            speed = 1.0,
            motion = true
        )
        val outlierOutputs = filter.process(outlierSample)
        assertTrue("Bad teleport outlier must not produce any emitted fixes", outlierOutputs.isEmpty())
        assertEquals(1, filter.rejected)

        // Next fix back at normal position (t=15s, lat=12.00010)
        val normalSample = TrailSample(
            latitude = 12.00010,
            longitude = 77.0,
            time = 15000L,
            accuracy = 5.0,
            speed = 1.0,
            motion = true
        )
        val normalOutputs = filter.process(normalSample)
        assertEquals(1, normalOutputs.size)
        val fix = normalOutputs.first() as TrailOutput.Fix
        assertEquals(15000L, fix.time)
        // Ensure distance to original is tiny (~11m, not 500m!)
        val distToOrigin = TrailQualityFilter.distance(12.0, 77.0, fix.latitude, fix.longitude)
        assertTrue("Track must continue near original position: ${distToOrigin}m", distToOrigin < 20.0)
    }

    @Test
    fun testRdpDecimationAndCap() {
        val lines = mutableListOf<String>()
        // Generate a 3000-point straight line with tiny noise
        for (i in 0 until 3000) {
            val json = "{\"type\":\"fix\",\"lat\":${12.0 + (i * 0.00001)},\"lng\":77.0,\"time\":${i * 1000L},\"accuracy\":5.0,\"speed\":1.0,\"gap\":false}"
            lines.add(json)
        }
        val decimated = TrailDecimator.decimateTrail(lines, epsilon = 5.0, maxPoints = 2000)
        val pointCount = decimated.split("\"lat\"").size - 1
        println("RDP Decimation: input=3000, output points=$pointCount")
        assertTrue("Decimated points must be <= 2000", pointCount <= 2000)
        // Since it's a straight line, RDP with 5m epsilon reduces it to 2 points!
        assertTrue("Straight line should reduce dramatically", pointCount < 10)
    }
}

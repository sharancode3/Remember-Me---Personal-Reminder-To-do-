package com.example.remember_me

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class ArrivalAndGeofenceTest {

    @Test
    fun drivePastPlaceDoesNotTriggerArrivalAlert() {
        // Place at lat 12.9716, lng 77.5946 with radius 100m, 90s dwell
        val place = PlaceGeofenceData(
            id = "work",
            name = "Work",
            lat = 12.9716,
            lng = 77.5946,
            radius = 100.0,
            dwellSeconds = 90,
            notify = true
        )
        val engine = ArrivalEngine(places = listOf(place))

        // Vehicle driving past at ~50 km/h (14 m/s).
        // Enters circle, spends 15 seconds passing through, then leaves.
        val baseTime = 1000000L
        var alerts = mutableListOf<ArrivalAlert>()

        // 1. Approaching: 120m away (outside circle)
        alerts.addAll(engine.processLocation(12.97268, 77.5946, 10f, baseTime))
        assertEquals(0, alerts.size)
        assertFalse(engine.isInside("work"))

        // 2. Enters perimeter: ~50m from center at t = 5s
        alerts.addAll(engine.processLocation(12.97205, 77.5946, 10f, baseTime + 5000L))
        assertEquals(0, alerts.size) // No alert yet (dwell not met)
        assertNotNull(engine.getEnteredTime("work"))

        // 3. Passing center: ~10m from center at t = 10s
        alerts.addAll(engine.processLocation(12.97169, 77.5946, 10f, baseTime + 10000L))
        assertEquals(0, alerts.size) // No alert yet (10s < 90s dwell)

        // 4. Exits circle: 160m away (beyond radius 100m + 50m hysteresis) at t = 20s
        alerts.addAll(engine.processLocation(12.97305, 77.5946, 10f, baseTime + 20000L))
        assertEquals(0, alerts.size) // Exited!

        // Verify entry was cleared by exit hysteresis
        assertEquals(null, engine.getEnteredTime("work"))
        assertFalse(engine.isInside("work"))
    }

    @Test
    fun stoppingForTwoMinutesTriggersArrivalAlertWithLinkedTasks() {
        val place = PlaceGeofenceData(
            id = "work",
            name = "Work",
            lat = 12.9716,
            lng = 77.5946,
            radius = 100.0,
            dwellSeconds = 90,
            notify = true
        )
        val tasks = mapOf(
            "work" to listOf("Review PR #42", "Submit timesheet", "Sync with lead")
        )
        val engine = ArrivalEngine(places = listOf(place), tasksByPlace = tasks)

        val baseTime = 1000000L

        // t = 0s: arrives inside place (distance ~20m)
        val at0 = engine.processLocation(12.97178, 77.5946, 10f, baseTime)
        assertEquals(0, at0.size) // Dwell not reached (0s < 90s)

        // t = 30s: still inside
        val at30 = engine.processLocation(12.97175, 77.5946, 10f, baseTime + 30000L)
        assertEquals(0, at30.size) // Dwell not reached (30s < 90s)

        // t = 60s: still inside
        val at60 = engine.processLocation(12.97176, 77.5946, 10f, baseTime + 60000L)
        assertEquals(0, at60.size) // Dwell not reached (60s < 90s)

        // t = 95s: dwell duration exceeded (95s >= 90s)! Alert must fire!
        val at95 = engine.processLocation(12.97177, 77.5946, 10f, baseTime + 95000L)
        assertEquals(1, at95.size)

        val alert = at95.first()
        assertEquals("work", alert.placeId)
        assertEquals("At Work: 3 tasks pending", alert.title)
        assertTrue(alert.content.contains("Review PR #42"))
        assertTrue(alert.content.contains("Submit timesheet"))
        assertTrue(engine.isInside("work"))

        // t = 120s (2 minutes): still inside, duplicate alert must NOT fire
        val at120 = engine.processLocation(12.97177, 77.5946, 10f, baseTime + 120000L)
        assertEquals(0, at120.size)
    }

    @Test
    fun exitHysteresisPreventsEdgeBounce() {
        val place = PlaceGeofenceData(
            id = "gym",
            name = "Gym",
            lat = 12.9716,
            lng = 77.5946,
            radius = 100.0,
            dwellSeconds = 30,
            notify = true
        )
        val engine = ArrivalEngine(places = listOf(place))
        val baseTime = 1000000L

        // Arrive and satisfy 30s dwell
        engine.processLocation(12.9716, 77.5946, 10f, baseTime)
        val alerts = engine.processLocation(12.9716, 77.5946, 10f, baseTime + 35000L)
        assertEquals(1, alerts.size)
        assertTrue(engine.isInside("gym"))

        // Move to 120m away: outside radius (100m) but inside hysteresis buffer (100 + 50 = 150m)
        // lat diff 0.00108 is ~120 meters
        engine.processLocation(12.97268, 77.5946, 10f, baseTime + 40000L)
        assertTrue("Must remain inside during hysteresis buffer", engine.isInside("gym"))

        // Move to 170m away: beyond radius + 50m
        // lat diff 0.00153 is ~170 meters
        engine.processLocation(12.97313, 77.5946, 10f, baseTime + 45000L)
        assertFalse("Must exit after crossing radius + 50m", engine.isInside("gym"))
    }

    @Test
    fun slidingWindowSelectsTwentyNearestPlacesAndRecenters() {
        // Create 30 places distributed around Bangalore from south to north
        val places = (1..30).map { i ->
            PlaceGeofenceData(
                id = "place_$i",
                name = "Place $i",
                lat = 12.9000 + (i * 0.005), // ~550 meters apart
                lng = 77.5946,
                radius = 100.0,
                notify = true
            )
        }
        assertEquals(30, places.size)

        // User is near place 1 (12.9050, 77.5946)
        val activeWindow = NativeGeofenceManager.selectActiveWindow(
            candidates = places,
            userLat = 12.9050,
            userLng = 77.5946,
            maxWindowSize = 20
        )

        // Must cap at 20 active geofences
        assertEquals(20, activeWindow.size)
        // Nearest places should be places 1 through 20
        assertEquals("place_1", activeWindow.first().id)
        assertFalse(activeWindow.any { it.id == "place_30" })

        // Check recentering logic:
        // Movement < 1000m should NOT recenter
        assertFalse(
            NativeGeofenceManager.shouldRecenter(
                lastCenterLat = 12.9050,
                lastCenterLng = 77.5946,
                currentLat = 12.9100, // ~550m away
                currentLng = 77.5946,
                thresholdMeters = 1000.0
            )
        )

        // Movement > 1000m SHOULD recenter
        assertTrue(
            NativeGeofenceManager.shouldRecenter(
                lastCenterLat = 12.9050,
                lastCenterLng = 77.5946,
                currentLat = 12.9250, // ~2.2 km away
                currentLng = 77.5946,
                thresholdMeters = 1000.0
            )
        )

        // After moving 10km north to place 30 (12.9000 + 30*0.005 = 13.0500)
        val recenteredWindow = NativeGeofenceManager.selectActiveWindow(
            candidates = places,
            userLat = 13.0500,
            userLng = 77.5946,
            maxWindowSize = 20
        )
        assertEquals(20, recenteredWindow.size)
        assertEquals("place_30", recenteredWindow.first().id)
        assertFalse(recenteredWindow.any { it.id == "place_1" })
    }
}

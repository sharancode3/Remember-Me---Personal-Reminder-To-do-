package com.example.remember_me

import kotlin.math.*

data class TrailSample(val latitude: Double, val longitude: Double, val time: Long, val accuracy: Double, val speed: Double?, val motion: Boolean)
data class CleanFix(val latitude: Double, val longitude: Double, val time: Long, val accuracy: Double, val speed: Double, val gap: Boolean)

/** Accuracy-weighted scalar Kalman filter with a stationary anchor and innovation gate. */
class TrailQualityFilter {
    private var estimate: TrailSample? = null
    private var emitted: CleanFix? = null
    private var variance = 0.0
    private var movementVotes = 0
    var rejected = 0; private set
    fun reset() { estimate = null; emitted = null; variance = 0.0; movementVotes = 0 }
    fun accept(sample: TrailSample): CleanFix? {
        if (!sample.latitude.isFinite() || !sample.longitude.isFinite() || abs(sample.latitude) > 90 || abs(sample.longitude) > 180 || sample.accuracy !in 0.5..40.0) { rejected++; return null }
        val prior = estimate
        val seconds = if (prior == null) 0.0 else (sample.time - prior.time) / 1000.0
        if (prior != null && seconds <= 0) { rejected++; return null }
        val gap = prior != null && seconds > 120
        if (prior == null || gap) {
            estimate = sample; variance = max(9.0, sample.accuracy * sample.accuracy); movementVotes = 0
            return CleanFix(sample.latitude, sample.longitude, sample.time, sample.accuracy, 0.0, gap).also { emitted = it }
        }
        val drift = distance(prior.latitude, prior.longitude, sample.latitude, sample.longitude)
        val speed = sample.speed?.takeIf { it.isFinite() && it in 0.0..65.0 }
        val uncertainty = sqrt(variance + sample.accuracy * sample.accuracy)
        if (drift / seconds > 65 || drift > max(30.0, 3 * uncertainty + (speed ?: 3.0) * seconds * 1.5)) { rejected++; return null }
        val anchor = emitted!!
        val displacement = distance(anchor.latitude, anchor.longitude, sample.latitude, sample.longitude)
        val credibleMovement = (speed != null && speed >= 0.7) || (sample.motion && displacement > max(6.0, sample.accuracy * 1.2))
        movementVotes = if (credibleMovement) (movementVotes + 1).coerceAtMost(4) else 0
        if (movementVotes < 2) {
            // Keep the anchor fixed; jitter must not add distance while stationary.
            estimate = prior.copy(time = sample.time)
            return null
        }
        variance += seconds * (2 + (speed ?: 1.5).pow(2) * 0.3)
        val measurement = max(9.0, sample.accuracy.pow(2))
        val gain = variance / (variance + measurement)
        val lat = prior.latitude + gain * (sample.latitude - prior.latitude)
        val lng = prior.longitude + gain * (sample.longitude - prior.longitude)
        variance *= 1 - gain
        estimate = sample.copy(latitude = lat, longitude = lng)
        val meters = distance(anchor.latitude, anchor.longitude, lat, lng)
        if (meters < max(3.0, min(8.0, sample.accuracy * .55))) return null
        val dt = (sample.time - anchor.time) / 1000.0
        val derived = if (dt > 0) meters / dt else 0.0
        val validatedSpeed = if (speed != null && abs(speed - derived) < max(2.0, speed * .6)) speed else derived
        return CleanFix(lat, lng, sample.time, sqrt(variance).coerceAtLeast(3.0), validatedSpeed, false).also { emitted = it }
    }
    companion object {
        fun distance(a: Double, b: Double, c: Double, d: Double): Double {
            val lat = Math.toRadians(c - a); val lng = Math.toRadians(d - b)
            val h = sin(lat / 2).pow(2) + cos(Math.toRadians(a)) * cos(Math.toRadians(c)) * sin(lng / 2).pow(2)
            return 6371000 * 2 * asin(sqrt(h.coerceIn(0.0, 1.0)))
        }
    }
}

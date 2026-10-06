package com.example.remember_me

import kotlin.math.*

data class TrailSample(
    val latitude: Double,
    val longitude: Double,
    val time: Long,
    val accuracy: Double,
    val speed: Double?,
    val motion: Boolean
)

sealed class TrailOutput {
    data class Fix(
        val latitude: Double,
        val longitude: Double,
        val time: Long,
        val accuracy: Double,
        val speed: Double,
        val gap: Boolean = false
    ) : TrailOutput()

    data class Gap(
        val start: Long,
        val end: Long,
        val reason: String = "tunnel_or_loss"
    ) : TrailOutput()
}

typealias CleanFix = TrailOutput.Fix

/**
 * Production 2D Metric Kalman Filter Pipeline in Local ENU Tangent Plane.
 *
 * Features:
 * 1. Constant-velocity 2D Kalman filter tracking [x, y, vx, vy] in meters & m/s.
 * 2. Gap detector: Resets filter when timeSinceLastFix > 60s and emits explicit gap.
 * 3. Tunnel / metro recovery: After gap > 60s, does not compare against pre-gap fix for speed.
 *    Accepts first fix on probation (accuracy <= 100m); confirms track with second fix within 30s.
 * 4. Speed gating: Rejects fixes with implied speed > 45 m/s (~160 km/h) unless accuracy < 15m
 *    and 2 consecutive fixes agree.
 * 5. Stationary detector: Windowed displacement standard deviation over last 5 fixes < 12m.
 *    Anchors location to eliminate phantom GPS jitter distance when stationary.
 */
class TrailQualityFilter {
    // Tangent plane reference
    private var refLat = 0.0
    private var refLng = 0.0
    private var isInitialized = false

    // State vector [x, y, vx, vy] in meters and m/s
    private var stateX = 0.0
    private var stateY = 0.0
    private var stateVx = 0.0
    private var stateVy = 0.0

    // Covariance matrix P
    private var p00 = 0.0
    private var p11 = 0.0
    private var p22 = 0.0
    private var p33 = 0.0
    private var p02 = 0.0
    private var p13 = 0.0

    // History & tracking state
    private var lastEmittedFix: TrailOutput.Fix? = null
    private var lastSampleTime: Long? = null
    private var probationFix: TrailOutput.Fix? = null
    private var highSpeedCandidate: TrailSample? = null

    // Windowed stationary detection (last 5 fixes in ENU)
    private val windowEnu = ArrayDeque<Pair<Double, Double>>(5)
    var isStationary = false; private set
    private var stationaryAnchor: TrailOutput.Fix? = null
    private var movementVotes = 0

    var rejected = 0; private set

    fun reset() {
        isInitialized = false
        lastEmittedFix = null
        lastSampleTime = null
        probationFix = null
        highSpeedCandidate = null
        windowEnu.clear()
        isStationary = false
        stationaryAnchor = null
        movementVotes = 0
        rejected = 0
    }

    /**
     * Backward-compatible convenience method.
     * Returns the latest emitted CleanFix (or null if rejected / stationary).
     */
    fun accept(sample: TrailSample): CleanFix? {
        val outputs = process(sample)
        return outputs.filterIsInstance<TrailOutput.Fix>().lastOrNull()
    }

    /**
     * Full pipeline method returning all emitted events (Fixes and Gaps).
     */
    fun process(sample: TrailSample): List<TrailOutput> {
        // Sanity checks on coordinates & accuracy
        if (!sample.latitude.isFinite() || !sample.longitude.isFinite() ||
            !sample.accuracy.isFinite() || sample.accuracy < 0.5 ||
            abs(sample.latitude) > 90.0 || abs(sample.longitude) > 180.0
        ) {
            rejected++
            return emptyList()
        }

        val priorTime = lastSampleTime
        val timeSinceLastSample = if (priorTime != null) (sample.time - priorTime) / 1000.0 else 0.0
        if (priorTime != null && timeSinceLastSample <= 0.0) {
            rejected++
            return emptyList()
        }

        val lastFix = lastEmittedFix

        // 1. Initial fix
        if (lastFix == null) {
            if (sample.accuracy > 40.0) {
                rejected++
                return emptyList()
            }
            lastSampleTime = sample.time
            initKalman(sample.latitude, sample.longitude, sample.accuracy)
            val fix = TrailOutput.Fix(
                latitude = sample.latitude,
                longitude = sample.longitude,
                time = sample.time,
                accuracy = sample.accuracy,
                speed = sample.speed?.coerceIn(0.0, 45.0) ?: 0.0,
                gap = false
            )
            lastEmittedFix = fix
            stationaryAnchor = fix
            updateStationaryWindow(0.0, 0.0)
            return listOf(fix)
        }

        // 2. Gap Detection & Tunnel Recovery (> 60s blackout elapsed since last sample)
        if (priorTime != null && timeSinceLastSample > 60.0) {
            lastSampleTime = sample.time
            // Tunnel / metro recovery:
            // Do NOT compare against pre-gap fix for speed.
            // Accept first fix on probation (accuracy <= 100m).
            if (sample.accuracy <= 100.0) {
                val gapEvent = TrailOutput.Gap(
                    start = lastFix.time,
                    end = sample.time,
                    reason = "tunnel_or_loss"
                )
                initKalman(sample.latitude, sample.longitude, sample.accuracy)
                val fix = TrailOutput.Fix(
                    latitude = sample.latitude,
                    longitude = sample.longitude,
                    time = sample.time,
                    accuracy = sample.accuracy,
                    speed = sample.speed?.coerceIn(0.0, 45.0) ?: 0.0,
                    gap = true
                )
                lastEmittedFix = fix
                probationFix = fix
                stationaryAnchor = fix
                movementVotes = 1
                updateStationaryWindow(0.0, 0.0)
                return listOf(gapEvent, fix)
            } else {
                rejected++
                return emptyList()
            }
        }

        lastSampleTime = sample.time

        // 3. Ongoing track checks: Accuracy gate for continuous tracking
        if (sample.accuracy > 45.0) {
            rejected++
            return emptyList()
        }

        val dt = (sample.time - lastFix.time) / 1000.0
        val dist = distance(lastFix.latitude, lastFix.longitude, sample.latitude, sample.longitude)
        val impliedSpeed = if (dt > 0) dist / dt else 0.0

        // 4. Pending probation verification
        val currentProbation = probationFix
        if (currentProbation != null) {
            val dtProb = (sample.time - currentProbation.time) / 1000.0
            if (dtProb <= 30.0) {
                if (impliedSpeed <= 45.0) {
                    // Confirmed track!
                    probationFix = null
                } else {
                    // Outlier immediately after tunnel
                    rejected++
                    return emptyList()
                }
            } else {
                probationFix = null
            }
        }

        // 5. Speed Gating: reject fixes with implied speed > 45 m/s (~160 km/h)
        // unless accuracy < 15m and 2 consecutive fixes agree.
        if (impliedSpeed > 45.0) {
            val candidate = highSpeedCandidate
            if (sample.accuracy < 15.0) {
                if (candidate == null) {
                    highSpeedCandidate = sample
                    rejected++
                    return emptyList()
                } else {
                    val dtCand = (sample.time - candidate.time) / 1000.0
                    val distCand = distance(candidate.latitude, candidate.longitude, sample.latitude, sample.longitude)
                    val speedCand = if (dtCand > 0) distCand / dtCand else 0.0
                    if (dtCand in 0.1..30.0 && speedCand <= 45.0) {
                        // 2 consecutive high speed fixes agree!
                        highSpeedCandidate = null
                        initKalman(candidate.latitude, candidate.longitude, candidate.accuracy)
                        val fix1 = TrailOutput.Fix(candidate.latitude, candidate.longitude, candidate.time, candidate.accuracy, speedCand, false)
                        val fix2 = updateKalman(sample, dtCand)
                        lastEmittedFix = fix2
                        stationaryAnchor = fix2
                        movementVotes = 2
                        return listOf(fix1, fix2)
                    } else {
                        highSpeedCandidate = sample
                        rejected++
                        return emptyList()
                    }
                }
            } else {
                highSpeedCandidate = null
                rejected++
                return emptyList()
            }
        } else {
            // Normal speed; clear any stale candidate
            highSpeedCandidate = null
        }

        // 6. Stationary Detector:
        // Windowed displacement standard deviation over last 5 fixes < 12m,
        // and credible movement voting against stationary anchor.
        val anchor = stationaryAnchor ?: lastFix
        val displacementFromAnchor = distance(anchor.latitude, anchor.longitude, sample.latitude, sample.longitude)

        val credibleMovement = (sample.speed != null && sample.speed >= 0.7) ||
            (sample.motion && displacementFromAnchor > max(6.0, sample.accuracy * 1.2))

        movementVotes = if (credibleMovement) (movementVotes + 1).coerceAtMost(4) else 0

        val (sampleX, sampleY) = toENU(sample.latitude, sample.longitude, refLat, refLng)
        updateStationaryWindow(sampleX, sampleY)

        if (movementVotes < 2) {
            // Keep anchor fixed; suppress GPS jitter while stationary
            isStationary = true
            stateVx = 0.0
            stateVy = 0.0
            return emptyList()
        }

        // Movement confirmed!
        isStationary = false

        // 7. Update 2D Kalman filter
        val cleanFix = updateKalman(sample, if (dt > 0) dt else 1.0)
        lastEmittedFix = cleanFix
        stationaryAnchor = cleanFix
        return listOf(cleanFix)
    }

    private fun updateStationaryWindow(x: Double, y: Double) {
        if (windowEnu.size >= 5) {
            windowEnu.removeFirst()
        }
        windowEnu.addLast(Pair(x, y))

        if (windowEnu.size == 5) {
            var sumX = 0.0
            var sumY = 0.0
            for (p in windowEnu) {
                sumX += p.first
                sumY += p.second
            }
            val meanX = sumX / 5.0
            val meanY = sumY / 5.0

            var varSum = 0.0
            for (p in windowEnu) {
                val dx = p.first - meanX
                val dy = p.second - meanY
                varSum += (dx * dx + dy * dy)
            }
            val displacementVariance = varSum / 5.0
            val displacementStdDev = sqrt(displacementVariance)
            if (displacementStdDev < 12.0 && movementVotes < 2) {
                isStationary = true
            }
        }
    }

    private fun initKalman(lat: Double, lng: Double, accuracy: Double) {
        refLat = lat
        refLng = lng
        isInitialized = true
        stateX = 0.0
        stateY = 0.0
        stateVx = 0.0
        stateVy = 0.0

        val posVar = max(accuracy * accuracy, 9.0)
        p00 = posVar
        p11 = posVar
        p22 = 25.0
        p33 = 25.0
        p02 = 0.0
        p13 = 0.0

        windowEnu.clear()
        isStationary = false
        movementVotes = 0
    }

    private fun updateKalman(sample: TrailSample, dt: Double): TrailOutput.Fix {
        // 1. Predict
        stateX += stateVx * dt
        stateY += stateVy * dt

        val sigmaA2 = 2.0 // acceleration process noise variance
        val qPos = (dt * dt * dt / 3.0) * sigmaA2
        val qVel = dt * sigmaA2
        val qPv = (dt * dt / 2.0) * sigmaA2

        p00 += 2 * dt * p02 + dt * dt * p22 + qPos
        p11 += 2 * dt * p13 + dt * dt * p33 + qPos
        p02 += dt * p22 + qPv
        p13 += dt * p33 + qPv
        p22 += qVel
        p33 += qVel

        // 2. Measurement
        val (zx, zy) = toENU(sample.latitude, sample.longitude, refLat, refLng)
        val rm = max(sample.accuracy * sample.accuracy, 9.0)

        // 3. Innovation
        val yx = zx - stateX
        val yy = zy - stateY
        val sx = p00 + rm
        val sy = p11 + rm

        // 4. Gain
        val kx0 = p00 / sx
        val kx2 = p02 / sx
        val ky1 = p11 / sy
        val ky3 = p13 / sy

        // 5. Update state
        stateX += kx0 * yx
        stateVx += kx2 * yx
        stateY += ky1 * yy
        stateVy += ky3 * yy

        // 6. Update covariance
        p00 *= (1.0 - kx0)
        p02 *= (1.0 - kx0)
        p22 -= kx2 * p02
        p11 *= (1.0 - ky1)
        p13 *= (1.0 - ky1)
        p33 -= ky3 * p13

        val (estLat, estLng) = toLatLng(stateX, stateY, refLat, refLng)
        val filteredSpeed = sqrt(stateVx * stateVx + stateVy * stateVy)
        val finalSpeed = sample.speed?.coerceIn(0.0, 45.0) ?: filteredSpeed

        return TrailOutput.Fix(
            latitude = estLat,
            longitude = estLng,
            time = sample.time,
            accuracy = sqrt(max(p00, p11)).coerceIn(1.0, 50.0),
            speed = finalSpeed,
            gap = false
        )
    }

    companion object {
        private const val EARTH_RADIUS = 6371000.0

        fun distance(lat1: Double, lon1: Double, lat2: Double, lon2: Double): Double {
            val dLat = Math.toRadians(lat2 - lat1)
            val dLon = Math.toRadians(lon2 - lon1)
            val a = sin(dLat / 2).pow(2) + cos(Math.toRadians(lat1)) * cos(Math.toRadians(lat2)) * sin(dLon / 2).pow(2)
            return EARTH_RADIUS * 2 * asin(sqrt(a.coerceIn(0.0, 1.0)))
        }

        fun toENU(lat: Double, lng: Double, refLat: Double, refLng: Double): Pair<Double, Double> {
            val dLat = Math.toRadians(lat - refLat)
            val dLng = Math.toRadians(lng - refLng)
            val x = EARTH_RADIUS * dLng * cos(Math.toRadians(refLat))
            val y = EARTH_RADIUS * dLat
            return Pair(x, y)
        }

        fun toLatLng(x: Double, y: Double, refLat: Double, refLng: Double): Pair<Double, Double> {
            val dLat = Math.toDegrees(y / EARTH_RADIUS)
            val cosLat = cos(Math.toRadians(refLat))
            val dLng = if (abs(cosLat) > 1e-6) Math.toDegrees(x / (EARTH_RADIUS * cosLat)) else 0.0
            return Pair(refLat + dLat, refLng + dLng)
        }
    }
}

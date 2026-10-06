package com.example.remember_me

import kotlin.math.*

object TrailDecimator {

    data class Point(
        val lat: Double,
        val lng: Double,
        val time: Long,
        val accuracy: Double,
        val speed: Double,
        val gap: Boolean,
        val rawLine: String
    )

    private val latRegex = Regex("\"lat\"\\s*:\\s*([0-9.-]+)")
    private val lngRegex = Regex("\"lng\"\\s*:\\s*([0-9.-]+)")
    private val timeRegex = Regex("\"time\"\\s*:\\s*([0-9]+)")
    private val accRegex = Regex("\"accuracy\"\\s*:\\s*([0-9.-]+)")
    private val speedRegex = Regex("\"speed\"\\s*:\\s*([0-9.-]+)")
    private val gapRegex = Regex("\"gap\"\\s*:\\s*(true|false)")
    private val typeRegex = Regex("\"type\"\\s*:\\s*\"([^\"]+)\"")

    private fun perpendicularDistance(p: Point, lineStart: Point, lineEnd: Point): Double {
        val (x, y) = TrailQualityFilter.toENU(p.lat, p.lng, lineStart.lat, lineStart.lng)
        val (x2, y2) = TrailQualityFilter.toENU(lineEnd.lat, lineEnd.lng, lineStart.lat, lineStart.lng)
        val lengthSq = x2 * x2 + y2 * y2
        if (lengthSq < 1e-6) {
            return sqrt(x * x + y * y)
        }
        val crossProduct = abs(x * y2 - y * x2)
        return crossProduct / sqrt(lengthSq)
    }

    fun rdp(points: List<Point>, epsilon: Double = 5.0): List<Point> {
        if (points.size <= 2) return points
        var maxDist = 0.0
        var index = 0
        val pFirst = points.first()
        val pLast = points.last()

        for (i in 1 until points.size - 1) {
            val dist = perpendicularDistance(points[i], pFirst, pLast)
            if (dist > maxDist) {
                maxDist = dist
                index = i
            }
        }

        return if (maxDist > epsilon) {
            val left = rdp(points.subList(0, index + 1), epsilon)
            val right = rdp(points.subList(index, points.size), epsilon)
            left.dropLast(1) + right
        } else {
            listOf(pFirst, pLast)
        }
    }

    /**
     * Decimates trail lines preserving gap markers.
     * Uses RDP with epsilon = 5.0m and caps total points to maxPoints (<= 2000).
     * Returns a valid JSON array string representing the decimated trail.
     */
    fun decimateTrail(lines: List<String>, epsilon: Double = 5.0, maxPoints: Int = 2000): String {
        val segments = mutableListOf<MutableList<Point>>()
        val gapEntries = mutableMapOf<Int, String>() // maps segment index to raw gap line
        var currentSegment = mutableListOf<Point>()

        for (line in lines) {
            val trimmed = line.trim()
            if (trimmed.isEmpty()) continue

            val typeMatch = typeRegex.find(trimmed)?.groupValues?.get(1)
            val isExplicitGap = typeMatch == "gap"
            val latMatch = latRegex.find(trimmed)?.groupValues?.get(1)?.toDoubleOrNull()
            val lngMatch = lngRegex.find(trimmed)?.groupValues?.get(1)?.toDoubleOrNull()

            if (isExplicitGap || (latMatch == null || lngMatch == null)) {
                if (currentSegment.isNotEmpty()) {
                    segments.add(currentSegment)
                    currentSegment = mutableListOf()
                }
                gapEntries[segments.size] = trimmed
            } else {
                val timeVal = timeRegex.find(trimmed)?.groupValues?.get(1)?.toLongOrNull() ?: 0L
                val accVal = accRegex.find(trimmed)?.groupValues?.get(1)?.toDoubleOrNull() ?: 0.0
                val speedVal = speedRegex.find(trimmed)?.groupValues?.get(1)?.toDoubleOrNull() ?: 0.0
                val isGapFlag = gapRegex.find(trimmed)?.groupValues?.get(1) == "true"

                val point = Point(
                    lat = latMatch,
                    lng = lngMatch,
                    time = timeVal,
                    accuracy = accVal,
                    speed = speedVal,
                    gap = isGapFlag,
                    rawLine = trimmed
                )

                if (isGapFlag && currentSegment.isNotEmpty()) {
                    segments.add(currentSegment)
                    currentSegment = mutableListOf()
                }
                currentSegment.add(point)
            }
        }

        if (currentSegment.isNotEmpty()) {
            segments.add(currentSegment)
        }

        // Apply RDP to each continuous segment
        val simplifiedSegments = segments.map { segment ->
            if (segment.size > 2) rdp(segment, epsilon) else segment
        }

        var totalPoints = simplifiedSegments.sumOf { it.size }
        var currentEpsilon = epsilon

        // If total points exceeds maxPoints, increase epsilon adaptively
        var refinedSegments = simplifiedSegments
        while (totalPoints > maxPoints && currentEpsilon < 50.0) {
            currentEpsilon *= 1.5
            refinedSegments = segments.map { segment ->
                if (segment.size > 2) rdp(segment, currentEpsilon) else segment
            }
            totalPoints = refinedSegments.sumOf { it.size }
        }

        // If still exceeding maxPoints, downsample uniformly
        val finalSegments = if (totalPoints > maxPoints) {
            val scale = maxPoints.toDouble() / totalPoints
            refinedSegments.map { segment ->
                val targetCount = max(2, (segment.size * scale).toInt())
                if (segment.size <= targetCount) segment
                else {
                    val step = segment.size.toDouble() / targetCount
                    val downsampled = mutableListOf<Point>()
                    for (i in 0 until targetCount) {
                        downsampled.add(segment[(i * step).toInt().coerceAtMost(segment.lastIndex)])
                    }
                    downsampled
                }
            }
        } else {
            refinedSegments
        }

        // Build output JSON array
        val sb = StringBuilder("[")
        var first = true

        for (i in finalSegments.indices) {
            val gapLine = gapEntries[i]
            if (gapLine != null) {
                if (!first) sb.append(",")
                sb.append(gapLine)
                first = false
            }
            for (pt in finalSegments[i]) {
                if (!first) sb.append(",")
                sb.append(pt.rawLine)
                first = false
            }
        }

        sb.append("]")
        return sb.toString()
    }
}

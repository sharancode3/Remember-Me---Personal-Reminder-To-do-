package com.example.remember_me

data class PlaceGeofenceData(
    val id: String,
    val name: String,
    val lat: Double,
    val lng: Double,
    val radius: Double = 100.0,
    val dwellSeconds: Int = 90,
    val notify: Boolean = true,
    val message: String = ""
)

data class ArrivalAlert(
    val placeId: String,
    val placeName: String,
    val title: String,
    val content: String,
    val timeMillis: Long
)

class ArrivalEngine(
    var places: List<PlaceGeofenceData> = emptyList(),
    var tasksByPlace: Map<String, List<String>> = emptyMap(),
    val cooldownMillis: Long = 30 * 60_000L
) {
    private val entered = mutableMapOf<String, Long>()
    private val inside = mutableSetOf<String>()
    private val lastFired = mutableMapOf<String, Long>()

    fun processLocation(
        lat: Double,
        lng: Double,
        accuracy: Float,
        timeMillis: Long
    ): List<ArrivalAlert> {
        val triggered = mutableListOf<ArrivalAlert>()

        for (place in places) {
            if (!place.notify) continue

            val id = place.id
            val distance = TrailQualityFilter.distance(lat, lng, place.lat, place.lng)
            val radius = place.radius.coerceIn(75.0, 500.0)
            val dwellMillis = place.dwellSeconds.coerceIn(30, 300) * 1000L

            // Exit hysteresis: trigger exit only when distance > radius + 50m to avoid edge bounce
            if (distance > radius + 50.0) {
                entered.remove(id)
                inside.remove(id)
                continue
            }

            // Must be within radius and acceptable accuracy (< 40m)
            if (distance > radius || accuracy > 40.0f) {
                continue
            }

            val since = entered.getOrPut(id) { timeMillis }

            // Dwell check: must stay inside for at least dwellMillis
            if (timeMillis - since < dwellMillis || inside.contains(id)) {
                continue
            }

            // Cooldown check
            val last = lastFired[id]
            if (last != null && timeMillis - last < cooldownMillis) {
                inside.add(id)
                continue
            }

            inside.add(id)
            lastFired[id] = timeMillis

            // Resolve linked tasks
            val placeName = place.name
            val placeTasks = tasksByPlace[id]
                ?: tasksByPlace[placeName.lowercase()]
                ?: tasksByPlace["@${placeName.lowercase().replace(" ", "")}"]

            val (title, content) = if (!placeTasks.isNullOrEmpty()) {
                val count = placeTasks.size
                val preview = placeTasks.take(3).joinToString(", ")
                val suffix = if (count > 3) " +${count - 3} more" else ""
                Pair(
                    "At $placeName: $count task${if (count > 1) "s" else ""} pending",
                    "$preview$suffix"
                )
            } else {
                Pair(
                    "You reached $placeName",
                    if (place.message.isNotBlank()) place.message else "Your saved place reminder"
                )
            }

            triggered.add(ArrivalAlert(id, placeName, title, content, timeMillis))
        }

        return triggered
    }

    fun isInside(placeId: String): Boolean = inside.contains(placeId)
    fun getEnteredTime(placeId: String): Long? = entered[placeId]
    fun getLastFiredTime(placeId: String): Long? = lastFired[placeId]
}

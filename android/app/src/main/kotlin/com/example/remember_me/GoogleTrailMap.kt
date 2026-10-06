package com.example.remember_me

import android.content.Context
import android.graphics.Color
import android.graphics.Bitmap
import android.view.View
import com.google.android.gms.maps.MapView
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.model.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.ByteArrayOutputStream

class GoogleTrailMapFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val maps = mutableSetOf<GoogleTrailMap>()
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val view = GoogleTrailMap(context, messenger, viewId, args as? Map<*, *> ?: emptyMap<Any, Any>())
        maps.add(view); view.onDispose = { maps.remove(view) }; return view
    }
    fun resume() = maps.toList().forEach { it.mapView.onResume() }
    fun pause() = maps.toList().forEach { it.mapView.onPause() }
    fun destroy() = maps.toList().forEach { it.dispose() }
}
class GoogleTrailMap(context: Context, messenger: BinaryMessenger, id: Int, initial: Map<*, *>) : PlatformView {
    val mapView = MapView(context)
    private val channel = MethodChannel(messenger, "remember_me/map/$id")
    private var map: GoogleMap? = null
    private var data = initial
    private var disposed = false
    private var lastDay = ""
    var onDispose: (() -> Unit)? = null
    init {
        mapView.onCreate(null); mapView.onResume()
        mapView.getMapAsync { google ->
            map = google; google.uiSettings.isMapToolbarEnabled = false
            val density = context.resources.displayMetrics.density
            google.setPadding((12*density).toInt(), (112*density).toInt(), (72*density).toInt(), (320*density).toInt())
            google.setOnMapLongClickListener { p -> channel.invokeMethod("pin", mapOf("lat" to p.latitude, "lng" to p.longitude)) }
            google.setOnMarkerClickListener { marker ->
                (marker.tag as? String)?.let { channel.invokeMethod("place", mapOf("id" to it)) }
                false
            }
            render(); fit()
        }
        channel.setMethodCallHandler { call, result ->
            when(call.method) {
                "update" -> { data = call.arguments as? Map<*, *> ?: data; render(); result.success(null) }
                "fit" -> { fit(); result.success(null) }
                "center" -> { val lat = call.argument<Number>("lat")!!.toDouble(); val lng = call.argument<Number>("lng")!!.toDouble(); map?.animateCamera(CameraUpdateFactory.newLatLngZoom(LatLng(lat, lng), 17f)); result.success(null) }
                "getCenter" -> { val target = map?.cameraPosition?.target; result.success(if(target == null) null else mapOf("lat" to target.latitude,"lng" to target.longitude)) }
                "snapshot" -> map?.snapshot { bitmap ->
                    if (bitmap == null) result.error("snapshot", "Map image is unavailable", null)
                    else { val out = ByteArrayOutputStream(); bitmap.compress(Bitmap.CompressFormat.PNG, 100, out); result.success(out.toByteArray()) }
                } ?: result.error("map", "Map is still loading", null)
                else -> result.notImplemented()
            }
        }
    }
    private fun points() = (data["points"] as? List<*>)?.mapNotNull { value ->
        val point = value as? Map<*, *> ?: return@mapNotNull null
        LatLng((point["lat"] as Number).toDouble(), (point["lng"] as Number).toDouble())
    } ?: emptyList()
    private fun render() {
        val google = map ?: return
        google.clear(); google.mapType = if (data["satellite"] == true) GoogleMap.MAP_TYPE_SATELLITE else GoogleMap.MAP_TYPE_NORMAL
        val raw = data["points"] as? List<*> ?: emptyList<Any>()
        var segment = mutableListOf<LatLng>()
        var lastTime = 0L
        for (value in raw) {
            val fix = value as Map<*, *>
            val time = (fix["time"] as Number).toLong()
            if (fix["gap"] == true || (lastTime > 0 && time - lastTime > 120000)) {
                if (segment.size > 1) google.addPolyline(PolylineOptions().addAll(segment).color(Color.rgb(22, 119, 94)).width(9f))
                segment = mutableListOf()
            }
            segment.add(LatLng((fix["lat"] as Number).toDouble(), (fix["lng"] as Number).toDouble())); lastTime = time
        }
        if (segment.size > 1) google.addPolyline(PolylineOptions().addAll(segment).color(Color.rgb(22, 119, 94)).width(9f))

        val rawGaps = data["gaps"] as? List<*> ?: emptyList<Any>()
        for (value in rawGaps) {
            val gap = value as? Map<*, *> ?: continue
            val from = gap["from"] as? Map<*, *>
            val to = gap["to"] as? Map<*, *>
            if (from != null && to != null) {
                val p1 = LatLng((from["lat"] as Number).toDouble(), (from["lng"] as Number).toDouble())
                val p2 = LatLng((to["lat"] as Number).toDouble(), (to["lng"] as Number).toDouble())
                google.addPolyline(
                    PolylineOptions()
                        .add(p1, p2)
                        .color(Color.DKGRAY)
                        .width(6f)
                        .pattern(listOf(Dash(20f), Gap(15f)))
                )
            }
        }

        val points = points()
        if (points.isNotEmpty()) {
            google.addMarker(MarkerOptions().position(points.first()).title("Start").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE)))
            google.addMarker(MarkerOptions().position(points.last()).title("Latest location").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN)))
        }
        for (value in data["places"] as? List<*> ?: emptyList<Any>()) {
            val place = value as Map<*, *>
            google.addMarker(MarkerOptions().position(LatLng((place["lat"] as Number).toDouble(), (place["lng"] as Number).toDouble())).title(place["name"] as? String))?.tag = place["id"] as? String
        }
        val day = data["day"]?.toString() ?: ""
        if (day != lastDay && points.isNotEmpty()) { lastDay = day; fit() }
    }
    private fun fit() {
        val google = map ?: return
        val points = points()
        if (points.isEmpty()) { google.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(20.0, 0.0), 2f)); return }
        if (points.size == 1 || points.all { it == points.first() }) google.moveCamera(CameraUpdateFactory.newLatLngZoom(points.first(), 16f))
        else mapView.post { if (!disposed && mapView.width > 0) google.animateCamera(CameraUpdateFactory.newLatLngBounds(LatLngBounds.builder().apply { points.forEach { include(it) } }.build(), 60)) }
    }
    override fun getView(): View = mapView
    override fun dispose() { if (!disposed) { disposed = true; channel.setMethodCallHandler(null); mapView.onPause(); mapView.onDestroy(); onDispose?.invoke() } }
}

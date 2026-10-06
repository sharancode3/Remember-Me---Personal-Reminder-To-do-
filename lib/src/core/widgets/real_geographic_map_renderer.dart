import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../theme/neo_colors.dart';
import '../theme/neo_shadows.dart';
import '../theme/neo_typography.dart';
import '../../services/journey_models_and_processor.dart';

/// Real OpenStreetMap Geographic Map Renderer
/// Renders authentic OpenStreetMap street tiles with dynamic polyline route tracing,
/// start pin, live tracking dot, and recenter controls.
class RealGeographicMapRenderer extends StatefulWidget {
  const RealGeographicMapRenderer({
    super.key,
    required this.trackPoints,
    required this.currentLocation,
    this.stops = const [],
    this.showVelocityBands = false,
    this.isCompleted = false,
    this.height = 280,
    this.accuracyMeters,
    this.onRecenter,
  });

  final List<TrackPoint> trackPoints;
  final TrackPoint? currentLocation;
  final List<JourneyStopEvent> stops;
  final bool showVelocityBands;
  final bool isCompleted;
  final double height;
  final double? accuracyMeters;
  final VoidCallback? onRecenter;

  @override
  State<RealGeographicMapRenderer> createState() => _RealGeographicMapRendererState();
}

class _RealGeographicMapRendererState extends State<RealGeographicMapRenderer> {
  final MapController _mapController = MapController();

  ll.LatLng get _centerCoord {
    if (widget.currentLocation != null) {
      return ll.LatLng(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
      );
    }
    if (widget.trackPoints.isNotEmpty) {
      return ll.LatLng(
        widget.trackPoints.last.latitude,
        widget.trackPoints.last.longitude,
      );
    }
    return const ll.LatLng(12.9716, 77.5946); // Default location
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final currentCenter = _centerCoord;

    final polylinePoints = widget.trackPoints
        .map((p) => ll.LatLng(p.latitude, p.longitude))
        .toList();

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9EC),
        border: Border.all(color: colors.border, width: 3.5),
        boxShadow: NeoShadows.small(colors.shadow),
      ),
      child: Stack(
        children: [
          // 1. Real OpenStreetMap Map Tile & Vector Layers
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentCenter,
              initialZoom: 16.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.rememberme.app',
                maxZoom: 19,
              ),

              // Polyline layer tracing the actual GPS trail
              if (polylinePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      strokeWidth: 5.0,
                      color: colors.accentRed,
                    ),
                  ],
                ),

              // Markers: Start Pin & Current Location
              MarkerLayer(
                markers: [
                  // Start Pin
                  if (widget.trackPoints.isNotEmpty)
                    Marker(
                      point: ll.LatLng(
                        widget.trackPoints.first.latitude,
                        widget.trackPoints.first.longitude,
                      ),
                      width: 32,
                      height: 32,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.accentYellow,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border, width: 2.5),
                        ),
                        child: const Icon(Icons.flag, size: 16, color: Colors.black),
                      ),
                    ),

                  // Current Live Pin
                  if (widget.currentLocation != null)
                    Marker(
                      point: ll.LatLng(
                        widget.currentLocation!.latitude,
                        widget.currentLocation!.longitude,
                      ),
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.accentRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.navigation, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 2. Map HUD Overlay: GPS Status & Mode
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: colors.border, width: 2),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.accentRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.accuracyMeters != null
                        ? 'GPS: ±${widget.accuracyMeters!.toStringAsFixed(0)}M (OSM)'
                        : 'OPENSTREETMAP (OFFLINE-CACHED GNSS)',
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Recenter Button
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                _mapController.move(currentCenter, 16.5);
                widget.onRecenter?.call();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.accentYellow,
                  border: Border.all(color: colors.border, width: 2.5),
                  boxShadow: NeoShadows.small(colors.shadow),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.my_location, size: 14, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      'RECENTER',
                      style: NeoTypography.label(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

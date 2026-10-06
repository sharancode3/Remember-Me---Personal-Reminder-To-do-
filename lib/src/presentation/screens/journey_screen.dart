import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../../core/widgets/real_geographic_map_renderer.dart';
import '../../domain/repositories/provider_abstractions.dart';
import '../../services/journey_models_and_processor.dart';
import '../../services/master_journey_engine.dart';
import 'journey_history_screen.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({
    super.key,
    required this.journeyService,
    required this.onClose,
  });

  final MasterJourneyEngine journeyService;
  final VoidCallback onClose;

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  JourneySummary? _completedSummary;
  bool _isPreJourney = true;
  bool _isRequestingLocation = false;
  String? _locationErrorMessage;
  JourneyType _selectedType = JourneyType.walk;
  JourneyTargetType _selectedTargetType = JourneyTargetType.justTrack;
  double _distanceTargetKm = 5.0;
  int _durationTargetMinutes = 45;
  int _stepTarget = 10000;
  bool _showVelocityBands = false;
  final TextEditingController _sessionTitleController = TextEditingController();

  @override
  void dispose() {
    _sessionTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        backgroundColor: colors.canvas,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.textPrimary),
          onPressed: widget.onClose,
        ),
        title: Text(
          _isPreJourney
              ? 'PRE-JOURNEY SETUP'
              : (_completedSummary == null ? 'LIVE JOURNEY' : 'JOURNEY SUMMARY'),
          style: NeoTypography.headline(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (_isPreJourney)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.history, color: Colors.black, size: 24),
                tooltip: 'Walk / Run History',
                onPressed: () => JourneyHistoryScreen.show(context),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: colors.border, height: 3.5),
        ),
      ),
      body: _isPreJourney
          ? _buildPreJourneySetup(context)
          : (_completedSummary != null
              ? _buildSummaryView(context, _completedSummary!)
              : StreamBuilder<JourneyLiveState>(
                  stream: widget.journeyService.watchLiveJourney(),
                  initialData: widget.journeyService.currentLiveState,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state == null) {
                      return Center(
                        child: Text(
                          'CONNECTING TO GNSS...',
                          style: NeoTypography.headline(color: colors.textPrimary),
                        ),
                      );
                    }
                    return _buildLiveTrackingView(context, state);
                  },
                )),
    );
  }

  // =========================================================================
  // 1. PRE-JOURNEY CONFIGURATION (Section 11: Mode, Targets, Weather context)
  // =========================================================================
  Widget _buildPreJourneySetup(BuildContext context) {
    final colors = context.neo;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Title Input
          Text(
            'SESSION NAME (OPTIONAL)',
            style: NeoTypography.label(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.border, width: 2.5),
              boxShadow: NeoShadows.small(colors.shadow),
            ),
            child: TextField(
              controller: _sessionTitleController,
              decoration: InputDecoration(
                hintText: 'e.g. Morning Neighborhood Walk',
                hintStyle: NeoTypography.body(color: colors.textSecondary, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: InputBorder.none,
              ),
              style: NeoTypography.headline(color: colors.textPrimary, fontSize: 14),
            ),
          ),
          const SizedBox(height: 18),

          // Activity Selection
          Text(
            'SELECT ACTIVITY',
            style: NeoTypography.label(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildTypeSelector(JourneyType.walk, 'WALK', Icons.directions_walk),
              const SizedBox(width: 8),
              _buildTypeSelector(JourneyType.run, 'RUN', Icons.directions_run),
              const SizedBox(width: 8),
              _buildTypeSelector(JourneyType.cycling, 'CYCLE', Icons.directions_bike),
            ],
          ),
          const SizedBox(height: 20),

          // Target Selection
          Text(
            'CHOOSE TARGET',
            style: NeoTypography.label(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTargetChip(JourneyTargetType.justTrack, 'JUST TRACK'),
              _buildTargetChip(JourneyTargetType.hitDistance, '5.0 KM'),
              _buildTargetChip(JourneyTargetType.hitDuration, '45 MIN'),
              _buildTargetChip(JourneyTargetType.hitSteps, '10,000 STEPS'),
            ],
          ),
          const SizedBox(height: 20),

          // GNSS & Privacy Context Card
          NeoCard(
            backgroundColor: colors.surface,
            borderColor: colors.border,
            borderWidth: 3.0,
            shadowOffset: const Offset(4, 4),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: colors.accentYellow,
                      child: Text(
                        'LOCAL & PRIVATE GNSS',
                        style: NeoTypography.label(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: const Color(0xFF1040C0),
                      child: Text(
                        'OPENSTREETMAP',
                        style: NeoTypography.label(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'GPS Movement & Route Tracing',
                  style: NeoTypography.headline(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Location, live speed, and distance are computed directly from real GPS deltas on device with 0 telemetry.',
                  style: NeoTypography.body(
                    color: colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (_locationErrorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.accentRed,
                border: Border.all(color: colors.border, width: 2.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'LOCATION ACCESS NEEDED',
                        style: NeoTypography.headline(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _locationErrorMessage!,
                    style: NeoTypography.body(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: () => openAppSettings(),
                        child: const Text('OPEN APP SETTINGS', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: () => Geolocator.openLocationSettings(),
                        child: const Text('DEVICE GPS SETTINGS', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Explicit Permission & Start Button
          NeoButton(
            text: _isRequestingLocation ? 'ACQUIRING GPS...' : 'ENABLE LOCATION & START →',
            variant: NeoButtonVariant.accentRed,
            isFullWidth: true,
            padding: const EdgeInsets.symmetric(vertical: 18),
            fontSize: 15,
            onPressed: _isRequestingLocation ? null : _handleStartJourney,
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartJourney() async {
    setState(() {
      _isRequestingLocation = true;
      _locationErrorMessage = null;
    });

    try {
      // 1. Check if device location service toggle is on
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isRequestingLocation = false;
          _locationErrorMessage = 'Device GPS/Location services are turned off. Please enable device location.';
        });
        return;
      }

      // 2. Check app permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isRequestingLocation = false;
            _locationErrorMessage = 'Location permission was denied. Please grant location access to trace your route.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isRequestingLocation = false;
          _locationErrorMessage = 'Location permission is permanently blocked in settings. Please tap below to enable it.';
        });
        return;
      }

      // 3. Get initial fix
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      widget.journeyService.configureIntent(
        JourneyIntentTarget(
          type: _selectedTargetType,
          targetDistanceKm: _distanceTargetKm,
          targetDurationMinutes: _durationTargetMinutes,
          targetSteps: _stepTarget,
        ),
      );

      await widget.journeyService.startJourney(_selectedType, initialPosition: initialPosition);

      if (mounted) {
        setState(() {
          _isRequestingLocation = false;
          _isPreJourney = false;
        });
      }
    } catch (e) {
      // Fallback: start with standard offline default coordinate if fix times out
      widget.journeyService.configureIntent(
        JourneyIntentTarget(
          type: _selectedTargetType,
          targetDistanceKm: _distanceTargetKm,
          targetDurationMinutes: _durationTargetMinutes,
          targetSteps: _stepTarget,
        ),
      );
      await widget.journeyService.startJourney(_selectedType);
      if (mounted) {
        setState(() {
          _isRequestingLocation = false;
          _isPreJourney = false;
        });
      }
    }
  }

  int _estimateDurationMinutes() {
    if (_selectedTargetType == JourneyTargetType.hitDuration) return _durationTargetMinutes;
    if (_selectedTargetType == JourneyTargetType.hitDistance) {
      final speed = _selectedType == JourneyType.run ? 9.5 : (_selectedType == JourneyType.cycling ? 20.0 : 5.0);
      return ((_distanceTargetKm / speed) * 60).round();
    }
    return 35;
  }

  Widget _buildTypeSelector(JourneyType type, String label, IconData icon) {
    final colors = context.neo;
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colors.accentYellow : colors.surface,
            border: Border.all(color: colors.border, width: 2.5),
            boxShadow: isSelected ? NeoShadows.small(colors.shadow) : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.black, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: NeoTypography.label(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetChip(JourneyTargetType type, String label) {
    final colors = context.neo;
    final isSelected = _selectedTargetType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedTargetType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentViolet : colors.surface,
          border: Border.all(color: colors.border, width: 2),
        ),
        child: Text(
          label,
          style: NeoTypography.label(
            color: isSelected ? Colors.white : colors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 2. LIVE TRACKING VIEW (Sections 8, 9, 13, 24: Real Map & Live Metrics)
  // =========================================================================
  Widget _buildLiveTrackingView(BuildContext context, JourneyLiveState state) {
    final colors = context.neo;
    final mins = (state.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (state.elapsedSeconds % 60).toString().padLeft(2, '0');
    final processor = widget.journeyService.processor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real Geographic Map View
          RealGeographicMapRenderer(
            height: 260,
            trackPoints: processor.acceptedPoints,
            currentLocation: processor.acceptedPoints.isNotEmpty ? processor.acceptedPoints.last : null,
            stops: processor.stops,
            showVelocityBands: false,
            isCompleted: false,
            accuracyMeters: state.liveAccuracyMeters,
          ),
          const SizedBox(height: 14),

          // Primary Distance & Time Card
          NeoCard(
            backgroundColor: colors.accentYellow,
            borderColor: colors.border,
            borderWidth: 3.5,
            shadowOffset: const Offset(6, 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISTANCE',
                        style: NeoTypography.label(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${state.distanceKm.toStringAsFixed(2)} KM',
                        style: NeoTypography.display(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 2.5, height: 45, color: colors.border),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ELAPSED TIME',
                        style: NeoTypography.label(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '$mins:$secs',
                        style: NeoTypography.display(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Metric Grid: Moving Avg, Peak Speed, Pace, Steps
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'MOVING AVG',
                  value: '${state.averageSpeedKmh.toStringAsFixed(1)} km/h',
                  accent: colors.surface,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'PACE',
                  value: '${state.currentPaceMinPerKm.toStringAsFixed(1)} m/km',
                  accent: colors.surface,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'STEPS',
                  value: '${state.stepsCount}',
                  accent: colors.surface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Live Velocity Profile Strip (Section 22)
          _buildLiveVelocityStrip(context, processor.acceptedPoints),
          const SizedBox(height: 20),

          // Action Controls: [ PAUSE / RESUME ] & [ FINISH ]
          Row(
            children: [
              Expanded(
                child: NeoButton(
                  text: state.isPaused ? 'RESUME' : 'PAUSE',
                  variant: state.isPaused
                      ? NeoButtonVariant.accentYellow
                      : NeoButtonVariant.surface,
                  onPressed: () {
                    if (state.isPaused) {
                      widget.journeyService.resumeJourney();
                    } else {
                      widget.journeyService.pauseJourney();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeoButton(
                  text: 'FINISH ✓',
                  variant: NeoButtonVariant.accentRed,
                  onPressed: () async {
                    final title = _sessionTitleController.text.trim();
                    final summary = await widget.journeyService.finishJourney(
                      customTitle: title.isNotEmpty ? title : null,
                    );
                    setState(() {
                      _completedSummary = summary;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveVelocityStrip(BuildContext context, List<TrackPoint> points) {
    final colors = context.neo;
    final recent = points.reversed.take(15).toList().reversed.toList();

    return NeoCard(
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 2.5,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVE VELOCITY PROFILE (KM/H)',
            style: NeoTypography.label(color: colors.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: recent.map((p) {
                final h = (p.validatedSpeedKmh * 3.5).clamp(4.0, 36.0);
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    height: h,
                    color: p.validatedSpeedKmh >= 8.0
                        ? colors.accentRed
                        : (p.validatedSpeedKmh >= 4.5 ? colors.accentYellow : colors.accentViolet),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. POST-JOURNEY ANALYSIS (Sections 25, 26, 28, 29: Splits, Map, Replay)
  // =========================================================================
  Widget _buildSummaryView(BuildContext context, JourneySummary summary) {
    final colors = context.neo;
    final processor = widget.journeyService.processor;
    final totalMins = summary.totalDuration.inMinutes;
    final movingMins = summary.movingDuration.inMinutes;
    final stoppedMins = summary.stoppedDuration.inMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Completed Map with Velocity Bands and Stops
          RealGeographicMapRenderer(
            height: 240,
            trackPoints: processor.acceptedPoints,
            currentLocation: null,
            stops: processor.stops,
            showVelocityBands: _showVelocityBands,
            isCompleted: true,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'ROUTE COLORING:',
                style: NeoTypography.label(color: colors.textSecondary, fontSize: 10),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('VELOCITY BANDS'),
                selected: _showVelocityBands,
                onSelected: (val) => setState(() => _showVelocityBands = val),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Hero Summary Card
          NeoCard(
            backgroundColor: colors.accentYellow,
            borderColor: colors.border,
            borderWidth: 3.5,
            shadowOffset: const Offset(6, 6),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.type.name.toUpperCase()} COMPLETED',
                  style: NeoTypography.label(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.totalDistanceKm.toStringAsFixed(2)} KM',
                  style: NeoTypography.display(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'DURATION: ${totalMins}m  (MOVING: ${movingMins}m · STOPPED: ${stoppedMins}m)',
                  style: NeoTypography.body(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SPEED: ${summary.averageSpeedKmh.toStringAsFixed(1)} KM/H AVG · ${summary.peakSpeedKmh.toStringAsFixed(1)} KM/H PEAK',
                  style: NeoTypography.body(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Splits Section (Section 28)
          if (processor.splits.isNotEmpty) ...[
            Text(
              'KILOMETER SPLITS',
              style: NeoTypography.label(
                color: colors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            ...processor.splits.map((s) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border.all(color: colors.border, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: colors.accentViolet,
                      child: Text(
                        'KM ${s.splitIndex}',
                        style: NeoTypography.label(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${s.paceMinPerKm.toStringAsFixed(1)} min/km',
                      style: NeoTypography.headline(
                        color: colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${s.avgSpeedKmh.toStringAsFixed(1)} km/h',
                      style: NeoTypography.body(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Save & Return Action
          NeoButton(
            text: 'SAVE ACTIVITY & UPDATE PLANNER →',
            variant: NeoButtonVariant.accentRed,
            isFullWidth: true,
            padding: const EdgeInsets.symmetric(vertical: 16),
            fontSize: 14,
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String title,
    required String value,
    required Color accent,
  }) {
    final colors = context.neo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: accent,
        border: Border.all(color: colors.border, width: 2.5),
        boxShadow: NeoShadows.small(colors.shadow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: NeoTypography.label(
              color: colors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: NeoTypography.headline(
              color: colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

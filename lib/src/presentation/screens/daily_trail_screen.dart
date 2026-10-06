import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../core/theme/daily_theme.dart';
import '../../services/daily_trail_service.dart';
import '../providers/providers.dart';
import 'daily_home_screen.dart';

class DailyTrailScreen extends ConsumerStatefulWidget {
  const DailyTrailScreen({super.key});
  @override
  ConsumerState<DailyTrailScreen> createState() => _DailyTrailScreenState();
}

class _DailyTrailScreenState extends ConsumerState<DailyTrailScreen> {
  final _controller = MapController();
  final _mapImage = GlobalKey();
  MethodChannel? _googleChannel;
  bool _ready = false,
      _google = false,
      _satellite = false,
      _busy = false,
      _tileError = false;
  DateTime? _fittedDay;
  Map<String, dynamic> _data(DailyTrailService trail) => {
    'day': trail.selectedDay.toIso8601String(),
    'points': trail.fixes.map((p) => p.toJson()).toList(),
    'places': trail.places.map((p) => p.toJson()).toList(),
    'satellite': _satellite,
  };
  void _fit() {
    final trail = ref.read(dailyTrailProvider);
    if (_google) {
      _googleChannel?.invokeMethod<void>('fit');
      return;
    }
    if (!_ready) return;
    final points = trail.fixes.map((p) => p.point).toList();
    if (points.isEmpty) return;
    if (points.length == 1 || points.every((p) => p == points.first)) {
      _controller.move(points.first, 16);
    } else {
      _controller.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(points),
          padding: const EdgeInsets.fromLTRB(40, 150, 84, 330),
          maxZoom: 17,
        ),
      );
    }
  }

  Future<void> _share() async {
    try {
      Uint8List? bytes;
      if (_google) {
        bytes = await _googleChannel?.invokeMethod<Uint8List>('snapshot');
      } else {
        final boundary =
            _mapImage.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        final image = await boundary?.toImage(pixelRatio: 2);
        final data = await image?.toByteData(format: ui.ImageByteFormat.png);
        image?.dispose();
        bytes = data?.buffer.asUint8List();
      }
      if (bytes == null) return;
      await DailyTrailService.channel.invokeMethod<void>('shareTrail', {
        'bytes': bytes,
        'date': DateFormat.yMMMd().format(
          ref.read(dailyTrailProvider).selectedDay,
        ),
      });
    } catch (e) {
      if (mounted) showMessage(context, readableError(e));
    }
  }

  Future<void> _pinCenter() async {
    if (_google) {
      final point = await _googleChannel?.invokeMapMethod<String, dynamic>(
        'getCenter',
      );
      if (point == null || !mounted) return;
      await _place(
        point: LatLng(
          (point['lat'] as num).toDouble(),
          (point['lng'] as num).toDouble(),
        ),
      );
    } else {
      await _place(point: _ready ? _controller.camera.center : null);
    }
  }

  Future<void> _toggle(bool enabled) async {
    if (_busy) return;
    if (enabled) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Record your daily trail?'),
          content: Text(
            ref.read(dailyTrailProvider).android
                ? 'Your location is saved on this phone, including in the background. Recording also powers saved-place arrival alerts. A persistent notification shows when recording is on. A new trail starts at midnight. You can stop or delete it anytime. Reopen the app after a phone restart.'
                : 'This preview records location while the app is open. Background recording requires Android.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enable recording'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() => _busy = true);
    try {
      if (enabled) {
        await ref
            .read(localNotificationServiceProvider)
            .requestPermissions(precise: false);
        await ref.read(dailyTrailProvider).start();
      } else {
        await ref.read(dailyTrailProvider).stop();
      }
    } catch (e) {
      if (mounted) showMessage(context, readableError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _place({LatLng? point, SavedPlace? place}) async {
    final trail = ref.read(dailyTrailProvider);
    final position =
        point ??
        place?.point ??
        (trail.fixes.isNotEmpty ? trail.fixes.last.point : const LatLng(0, 0));
    final name = TextEditingController(text: place?.name);
    final message = TextEditingController(text: place?.message);
    final latitude = TextEditingController(
      text: position.latitude.toStringAsFixed(6),
    );
    final longitude = TextEditingController(
      text: position.longitude.toStringAsFixed(6),
    );
    var notify = place?.notify ?? false;
    var radius = place?.radius ?? 100.0;
    String? error;
    final route = ModalBottomSheetRoute<void>(
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place == null ? 'Save a place' : 'Edit place',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: name,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    labelText: 'Place name',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: latitude,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: longitude,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                        ),
                      ),
                    ),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Notify on arrival'),
                  value: notify,
                  onChanged: (value) => update(() => notify = value),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  child: notify
                      ? Column(
                          children: [
                            TextField(
                              controller: message,
                              maxLength: 180,
                              decoration: const InputDecoration(
                                labelText: 'Reminder message',
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.radar),
                                const SizedBox(width: 8),
                                Text('${radius.round()} m'),
                                Expanded(
                                  child: Slider(
                                    value: radius,
                                    min: 75,
                                    max: 500,
                                    divisions: 17,
                                    onChanged: (value) =>
                                        update(() => radius = value),
                                  ),
                                ),
                              ],
                            ),
                            if (!trail.enabled)
                              const Text(
                                'Arrival alerts are paused while daily recording is off.',
                                style: TextStyle(color: Color(0xFF9B4B39)),
                              ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (place != null)
                      IconButton(
                        tooltip: 'Delete saved place',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await trail.removePlace(place.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Save place'),
                        onPressed: () async {
                          final lat = double.tryParse(latitude.text),
                              lng = double.tryParse(longitude.text);
                          if (name.text.trim().isEmpty ||
                              lat == null ||
                              lng == null ||
                              !lat.isFinite ||
                              !lng.isFinite ||
                              lat.abs() > 90 ||
                              lng.abs() > 180) {
                            update(
                              () =>
                                  error = 'Enter a name and valid coordinates.',
                            );
                            return;
                          }
                          try {
                            if (notify) {
                              await ref
                                  .read(localNotificationServiceProvider)
                                  .requestPermissions(precise: false);
                            }
                            await trail.savePlace(
                              SavedPlace(
                                id:
                                    place?.id ??
                                    DateTime.now().microsecondsSinceEpoch
                                        .toString(),
                                name: name.text.trim(),
                                point: LatLng(lat, lng),
                                radius: radius,
                                notify: notify,
                                message: message.text.trim(),
                              ),
                            );
                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            update(() => error = readableError(e));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await Navigator.of(context).push(route);
    await route.completed;
    name.dispose();
    message.dispose();
    latitude.dispose();
    longitude.dispose();
  }

  Future<void> _places() async {
    final place = await showModalBottomSheet<SavedPlace>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text(
                'Saved places',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            ...ref
                .read(dailyTrailProvider)
                .places
                .map(
                  (p) => ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(p.name),
                    subtitle: Text(
                      p.notify
                          ? 'Arrival alert - ${p.radius.round()} m'
                          : 'Pinned place',
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => Navigator.pop(context, p),
                  ),
                ),
            ListTile(
              leading: const Icon(Icons.add_location_alt_outlined),
              title: const Text('Add a place'),
              onTap: () {
                Navigator.pop(context);
                _place();
              },
            ),
          ],
        ),
      ),
    );
    if (place != null && mounted) await _place(place: place);
  }

  Future<void> _options() async {
    final trail = ref.read(dailyTrailProvider);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Daily recording'),
                  subtitle: Text(
                    trail.enabled ? 'On - saves as you move' : 'Off',
                  ),
                  value: trail.enabled,
                  onChanged: (value) async {
                    Navigator.pop(context);
                    await _toggle(value);
                  },
                ),
                RadioGroup<bool>(
                  groupValue: _google,
                  onChanged: (value) {
                    _googleChannel?.setMethodCallHandler(null);
                    _googleChannel = null;
                    setState(() {
                      _google = value!;
                      _ready = false;
                      _fittedDay = null;
                    });
                    update(() {});
                  },
                  child: Column(
                    children: [
                      const RadioListTile<bool>(
                        value: false,
                        title: Text('OpenStreetMap'),
                      ),
                      RadioListTile<bool>(
                        value: true,
                        enabled: trail.googleConfigured,
                        title: const Text('Google Maps'),
                        subtitle: trail.googleConfigured
                            ? null
                            : const Text(
                                'Optional Android API key not configured',
                              ),
                      ),
                    ],
                  ),
                ),
                if (_google)
                  SwitchListTile.adaptive(
                    title: const Text('Satellite'),
                    value: _satellite,
                    onChanged: (value) {
                      setState(() => _satellite = value);
                      _googleChannel?.invokeMethod<void>(
                        'update',
                        _data(trail),
                      );
                      update(() {});
                    },
                  ),
                if (trail.fixes.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.copy_outlined),
                    title: const Text('Copy trail coordinates'),
                    onTap: () async {
                      final csv = trail.fixes
                          .map(
                            (p) =>
                                '${p.time.toIso8601String()},${p.point.latitude},${p.point.longitude},${p.accuracy},${p.speed},${p.gap}',
                          )
                          .join('\n');
                      await Clipboard.setData(
                        ClipboardData(
                          text:
                              'time,latitude,longitude,accuracy_m,speed_mps,gap\n$csv',
                        ),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                if (trail.fixes.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Delete this day\'s trail'),
                    onTap: () async {
                      Navigator.pop(context);
                      final yes = await showDialog<bool>(
                        context: this.context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete this trail?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (yes == true) {
                        try {
                          await trail.deleteDay();
                        } catch (e) {
                          if (mounted) {
                            showMessage(this.context, readableError(e));
                          }
                        }
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _googleChannel?.setMethodCallHandler(null);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trail = ref.watch(dailyTrailProvider);
    final fixes = trail.fixes;
    final stats = TrailStats(fixes);
    ref.listen(dailyTrailProvider, (_, next) {
      _googleChannel?.invokeMethod<void>('update', _data(next));
      if (_fittedDay != next.selectedDay && next.fixes.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _fit();
            _fittedDay = next.selectedDay;
          }
        });
      }
    });
    final segments = <List<LatLng>>[];
    for (var i = 0; i < fixes.length; i++) {
      if (i == 0 ||
          fixes[i].gap ||
          fixes[i].time.difference(fixes[i - 1].time).inSeconds > 120) {
        segments.add([]);
      }
      segments.last.add(fixes[i].point);
    }
    return RepaintBoundary(
      key: _mapImage,
      child: Stack(
        children: [
          Positioned.fill(
            child: _google && trail.googleConfigured
                ? AndroidView(
                    viewType: 'remember_me/google_map',
                    creationParams: _data(trail),
                    creationParamsCodec: const StandardMessageCodec(),
                    onPlatformViewCreated: (id) {
                      _googleChannel = MethodChannel('remember_me/map/$id')
                        ..setMethodCallHandler((call) async {
                          final data = Map<String, dynamic>.from(
                            call.arguments as Map,
                          );
                          if (call.method == 'pin') {
                            await _place(
                              point: LatLng(
                                (data['lat'] as num).toDouble(),
                                (data['lng'] as num).toDouble(),
                              ),
                            );
                          }
                          if (call.method == 'place') {
                            final place = trail.places
                                .where((p) => p.id == data['id'])
                                .firstOrNull;
                            if (place != null) await _place(place: place);
                          }
                        });
                    },
                  )
                : FlutterMap(
                    mapController: _controller,
                    options: MapOptions(
                      initialCenter:
                          fixes.firstOrNull?.point ?? const LatLng(20, 0),
                      initialZoom: fixes.isEmpty ? 2 : 16,
                      onLongPress: (_, point) => _place(point: point),
                      onMapReady: () {
                        _ready = true;
                        _fit();
                        _fittedDay = fixes.isEmpty ? null : trail.selectedDay;
                      },
                    ),
                    children: [
                      _OsmTiles(
                        onFailure: () {
                            if (!_tileError && mounted) {
                              setState(() => _tileError = true);
                            }
                        },
                      ),
                      PolylineLayer(
                        polylines: segments
                            .where((s) => s.length > 1)
                            .map(
                              (points) => Polyline(
                                points: points,
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 4,
                              ),
                            )
                            .toList(),
                      ),
                      MarkerLayer(
                        markers: [
                          if (fixes.isNotEmpty)
                            Marker(
                              point: fixes.first.point,
                              width: 30,
                              height: 30,
                              child: const _Pin(
                                icon: Icons.flag,
                                color: Color(0xFF3577B5),
                              ),
                            ),
                          if (fixes.isNotEmpty)
                            Marker(
                              point: fixes.last.point,
                              width: 30,
                              height: 30,
                              child: _Pin(
                                icon: Icons.my_location,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ...trail.places.map(
                            (p) => Marker(
                              point: p.point,
                              width: 42,
                              height: 42,
                              child: IconButton.filled(
                                tooltip: p.name,
                                icon: const Icon(Icons.place, size: 22),
                                onPressed: () => _place(place: p),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 16,
            right: 16,
            child: GlassPanel(
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your trail',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            DateFormat('EEE, MMM d').format(trail.selectedDay),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Choose trail date',
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () async {
                        final day = await showDatePicker(
                          context: context,
                          initialDate: trail.selectedDay,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (day != null) await trail.select(day);
                      },
                    ),
                    IconButton(
                      tooltip: 'Trail settings',
                      icon: const Icon(Icons.tune),
                      onPressed: _options,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 88,
            right: 16,
            child: GlassPanel(
              child: Column(
                children: [
                  IconButton(
                    tooltip: 'Fit entire trail',
                    icon: const Icon(Icons.fit_screen),
                    onPressed: _fit,
                  ),
                  IconButton(
                    tooltip: 'Saved places',
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: _places,
                  ),
                  IconButton(
                    tooltip: 'Pin map center',
                    icon: const Icon(Icons.add_location_alt_outlined),
                    onPressed: _pinCenter,
                  ),
                  if (trail.android && fixes.isNotEmpty)
                    IconButton(
                      tooltip: 'Share trail image',
                      icon: const Icon(Icons.ios_share_outlined),
                      onPressed: _share,
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 16,
            right: 16,
            child: GlassPanel(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          trail.enabled
                              ? Icons.fiber_manual_record
                              : Icons.pause_circle_outline,
                          size: 14,
                          color: trail.enabled
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            trail.enabled
                                ? fixes.isEmpty
                                      ? 'Waiting for GPS'
                                      : 'Recording'
                                : fixes.isEmpty
                                ? 'No trail for this day'
                                : 'Recording paused',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (!trail.enabled)
                          IconButton(
                            tooltip: 'Start daily recording',
                            icon: const Icon(Icons.play_arrow),
                            onPressed: _busy ? null : () => _toggle(true),
                          ),
                        Text(
                          '${fixes.length} marks',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    if (trail.error != null || _tileError)
                      Text(
                        trail.error ??
                            'Map tiles unavailable. Your saved trail remains visible.',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9B4B39),
                        ),
                      ),
                    if (fixes.isNotEmpty)
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _MiniTrail(
                            segments,
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _stat((stats.distance / 1000).toStringAsFixed(2), 'km'),
                        _stat(
                          (stats.averageSpeed * 3.6).toStringAsFixed(1),
                          'avg km/h',
                        ),
                        _stat(
                          (stats.maximumSpeed * 3.6).toStringAsFixed(1),
                          'max km/h',
                        ),
                        _stat(
                          stats.metersPerMinute.toStringAsFixed(0),
                          'm/min',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _google
                          ? null
                          : () async {
                              try {
                                await DailyTrailService.channel
                                    .invokeMethod<void>('openAttribution');
                              } catch (_) {}
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          _google
                              ? 'Google Maps'
                              : 'Map data: OpenStreetMap contributors',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF68756E),
                          ),
                        ),
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

  Widget _stat(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF68756E)),
        ),
      ],
    ),
  );
}

class _Pin extends StatelessWidget {
  const _Pin({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Icon(icon, color: Colors.white, size: 16),
  );
}

class _OsmTiles extends StatefulWidget {
  const _OsmTiles({required this.onFailure});
  final VoidCallback onFailure;
  @override
  State<_OsmTiles> createState() => _OsmTilesState();
}

class _OsmTilesState extends State<_OsmTiles> {
  late final _provider = NetworkTileProvider(
    silenceExceptions: true,
    httpClient: _TileClient(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onFailure();
      });
    }),
  );
  @override
  Widget build(BuildContext context) => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.remember_me',
    maxZoom: 19,
    tileProvider: _provider,
  );
}

class _TileClient extends http.BaseClient {
  _TileClient(this.onFailure);
  final VoidCallback onFailure;
  final _client = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final response = await _client
          .send(request)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode >= 400) onFailure();
      return response;
    } catch (_) {
      onFailure();
      rethrow;
    }
  }

  @override
  void close() => _client.close();
}

class _MiniTrail extends CustomPainter {
  _MiniTrail(this.segments, this.color);
  final List<List<LatLng>> segments;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final points = segments.expand((s) => s).toList();
    if (points.isEmpty) return;
    final latitude = points.first.latitude * math.pi / 180;
    double x(LatLng p) => p.longitude * math.cos(latitude);
    final minX = points.map(x).reduce(math.min),
        maxX = points.map(x).reduce(math.max);
    final minY = points.map((p) => p.latitude).reduce(math.min),
        maxY = points.map((p) => p.latitude).reduce(math.max);
    final scale = math.min(
      (size.width - 8) / math.max(maxX - minX, 0.000001),
      (size.height - 8) / math.max(maxY - minY, 0.000001),
    );
    Offset position(LatLng p) => Offset(
      size.width / 2 + (x(p) - (minX + maxX) / 2) * scale,
      size.height / 2 - (p.latitude - (minY + maxY) / 2) * scale,
    );
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final segment in segments) {
      if (segment.isEmpty) continue;
      final path = ui.Path()
        ..moveTo(position(segment.first).dx, position(segment.first).dy);
      for (final p in segment.skip(1)) {
        final at = position(p);
        path.lineTo(at.dx, at.dy);
      }
      canvas.drawPath(path, paint);
    }
    canvas.drawCircle(
      position(points.first),
      3,
      Paint()..color = const Color(0xFF3577B5),
    );
    canvas.drawCircle(position(points.last), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MiniTrail old) =>
      old.segments != segments || old.color != color;
}

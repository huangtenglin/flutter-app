import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_multi_platform_app/app/theme.dart';
import 'package:my_multi_platform_app/features/playback/playback_engine.dart';
import 'package:my_multi_platform_app/models/track_point.dart';
import 'package:my_multi_platform_app/utils/calculate/geo.dart';
import 'package:my_multi_platform_app/widgets/stateful/tracker_map_models.dart';

class TrackerMap extends StatefulWidget {
  const TrackerMap({
    super.key,
    required this.mode,
    this.markers = const [],
    this.track = const [],
    this.engine,
    this.height,
    this.freshnessLabel,
    this.onTap,
    this.interactive = true,
  });

  final TrackerMapMode mode;
  final List<MapMarkerData> markers;
  final List<TrackPoint> track;
  final PlaybackEngine? engine;
  final double? height;
  final String? freshnessLabel;
  final VoidCallback? onTap;
  final bool interactive;

  @override
  State<TrackerMap> createState() => TrackerMapState();
}

class TrackerMapState extends State<TrackerMap>
    with SingleTickerProviderStateMixin {
  final MapController _map = MapController();
  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  bool _follow = true;
  var _ready = false;

  PlaybackEngine? get _engine => widget.engine;

  @override
  void initState() {
    super.initState();
    _engine?.addListener(_onEngine);
    _ticker = createTicker(_onTick);
  }

  @override
  void didUpdateWidget(covariant TrackerMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.engine != widget.engine) {
      oldWidget.engine?.removeListener(_onEngine);
      widget.engine?.addListener(_onEngine);
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _engine?.removeListener(_onEngine);
    _map.dispose();
    super.dispose();
  }

  void recenter() {
    _follow = true;
    final target = _center;
    if (_ready) {
      _map.move(target, _map.camera.zoom);
    }
  }

  LatLng get _center {
    if (widget.mode == TrackerMapMode.playback && _engine != null) {
      final s = _engine!.sample();
      return LatLng(s.lat, s.lng);
    }
    if (widget.markers.isNotEmpty) {
      final m = widget.markers.last;
      return LatLng(m.lat, m.lng);
    }
    if (widget.track.isNotEmpty) {
      final p = widget.track.last;
      return LatLng(p.lat, p.lng);
    }
    return const LatLng(21.597872, 39.250257);
  }

  void _onEngine() {
    final engine = _engine;
    if (engine == null) return;
    if (engine.state == PlayState.playing) {
      if (_ticker != null && !_ticker!.isTicking) {
        _lastElapsed = Duration.zero;
        _ticker!.start();
      }
    } else {
      _ticker?.stop();
      _lastElapsed = Duration.zero;
    }
    if (mounted) setState(() {});
    if (_follow && _ready && widget.mode == TrackerMapMode.playback) {
      final s = engine.sample();
      _map.move(LatLng(s.lat, s.lng), _map.camera.zoom);
    }
  }

  void _onTick(Duration elapsed) {
    final delta = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    _engine?.tick(delta);
  }

  @override
  Widget build(BuildContext context) {
    final map = ClipRRect(
      borderRadius: widget.height == null
          ? BorderRadius.zero
          : BorderRadius.circular(22),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: widget.mode == TrackerMapMode.markersOnly ? 15 : 13,
              minZoom: 3,
              maxZoom: 19,
              interactionOptions: InteractionOptions(
                flags: widget.interactive
                    ? InteractiveFlag.drag |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.pinchMove |
                        InteractiveFlag.doubleTapZoom |
                        InteractiveFlag.scrollWheelZoom
                    : InteractiveFlag.none,
              ),
              onTap: widget.onTap == null ? null : (_, _) => widget.onTap!(),
              onMapReady: () => _ready = true,
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture) _follow = false;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.my_multi_platform_app',
              ),
              if (widget.mode == TrackerMapMode.playback) ..._playbackLayers(),
              MarkerLayer(markers: _markers()),
            ],
          ),
          if (widget.freshnessLabel != null)
            Positioned(
              top: 9,
              left: 9,
              child: _Chip(label: 'Last reported ${widget.freshnessLabel}'),
            ),
          Positioned(
            right: 9,
            bottom: 9,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: recenter,
                child: const SizedBox(
                  width: 31,
                  height: 31,
                  child: Icon(Icons.my_location, size: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.height == null) return map;
    return SizedBox(height: widget.height, child: map);
  }

  List<Widget> _playbackLayers() {
    final engine = _engine;
    if (engine == null || engine.points.isEmpty) return const [];
    final all = [
      for (final p in engine.points) LatLng(p.lat, p.lng),
    ];
    final sample = engine.sample();
    final walked = <LatLng>[
      for (var i = 0; i <= sample.segmentIndex; i++) all[i],
    ];
    final prev = engine.points[sample.segmentIndex];
    if (Geo.haversine(prev.lat, prev.lng, sample.lat, sample.lng) < 200) {
      walked.add(LatLng(sample.lat, sample.lng));
    }
    return [
      PolylineLayer(
        polylines: [
          Polyline(
            points: all,
            color: const Color(0xFFD6D6DB),
            strokeWidth: 4,
          ),
          Polyline(
            points: walked,
            color: AppColors.accent,
            strokeWidth: 4,
          ),
        ],
      ),
    ];
  }

  List<Marker> _markers() {
    if (widget.mode == TrackerMapMode.playback && _engine != null) {
      final s = _engine!.sample();
      return [
        Marker(
          point: LatLng(s.lat, s.lng),
          width: 28,
          height: 28,
          child: Transform.rotate(
            angle: s.bearing * 3.1415926535 / 180,
            child: const _Dot(),
          ),
        ),
      ];
    }
    return [
      for (final m in widget.markers)
        Marker(
          point: LatLng(m.lat, m.lng),
          width: 88,
          height: 64,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (m.label != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(6.5),
                  ),
                  child: Text(
                    m.label!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              const _Dot(),
            ],
          ),
        ),
    ];
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.18),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x21000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule, size: 13, color: AppColors.ink),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

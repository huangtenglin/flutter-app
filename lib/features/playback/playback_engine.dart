import 'package:flutter/foundation.dart';
import 'package:my_multi_platform_app/models/track_point.dart';
import 'package:my_multi_platform_app/utils/calculate/geo.dart';

enum PlayState { idle, playing, paused, ended }

class SampleResult {
  const SampleResult({
    required this.lat,
    required this.lng,
    required this.bearing,
    required this.segmentIndex,
    required this.ts,
  });

  final double lat;
  final double lng;
  final double bearing;
  final int segmentIndex;
  final DateTime ts;
}

class PlaybackEngine extends ChangeNotifier {
  static const speeds = [1.0, 2.0, 4.0, 6.0, 10.0];

  List<TrackPoint> _points = const [];
  DateTime? _t0;
  DateTime? _tN;
  DateTime? _cursor;
  PlayState state = PlayState.idle;
  double speed = 1;

  List<TrackPoint> get points => _points;
  DateTime get t0 => _t0 ?? DateTime.fromMillisecondsSinceEpoch(0);
  DateTime get tN => _tN ?? DateTime.fromMillisecondsSinceEpoch(0);
  DateTime get cursor => _cursor ?? t0;

  double get progress {
    final span = tN.difference(t0).inMilliseconds;
    if (span <= 0) return 0;
    return cursor.difference(t0).inMilliseconds / span;
  }

  void load(List<TrackPoint> points) {
    _points = List<TrackPoint>.from(points)
      ..sort((a, b) => a.ts.compareTo(b.ts));
    if (_points.isEmpty) {
      _t0 = _tN = _cursor = null;
      state = PlayState.idle;
      notifyListeners();
      return;
    }
    _t0 = _points.first.ts;
    _tN = _points.last.ts;
    _cursor = _t0;
    state = PlayState.idle;
    notifyListeners();
  }

  void play() {
    if (_points.length < 2) return;
    if (state == PlayState.ended) {
      _cursor = _t0;
    }
    state = PlayState.playing;
    notifyListeners();
  }

  void pause() {
    if (state == PlayState.playing) {
      state = PlayState.paused;
      notifyListeners();
    }
  }

  void toggle() {
    if (state == PlayState.playing) {
      pause();
    } else {
      play();
    }
  }

  void setSpeed(double s) {
    speed = s;
    notifyListeners();
  }

  void seekToProgress(double p) {
    final span = tN.difference(t0).inMilliseconds;
    final ms = (span * p.clamp(0, 1)).round();
    _cursor = t0.add(Duration(milliseconds: ms));
    if (_cursor!.isAfter(tN)) {
      _cursor = tN;
      state = PlayState.ended;
    } else if (state == PlayState.ended) {
      state = PlayState.paused;
    }
    notifyListeners();
  }

  void tick(Duration elapsed) {
    if (state != PlayState.playing || _cursor == null) return;
    _cursor = _cursor!.add(
      Duration(milliseconds: (elapsed.inMilliseconds * speed).round()),
    );
    if (!_cursor!.isBefore(tN)) {
      _cursor = tN;
      state = PlayState.ended;
    }
    notifyListeners();
  }

  SampleResult sample([DateTime? at]) {
    if (_points.isEmpty) {
      return SampleResult(
        lat: 0,
        lng: 0,
        bearing: 0,
        segmentIndex: 0,
        ts: DateTime.fromMillisecondsSinceEpoch(0),
      );
    }
    if (_points.length == 1) {
      final p = _points.first;
      return SampleResult(
        lat: p.lat,
        lng: p.lng,
        bearing: p.bearing,
        segmentIndex: 0,
        ts: p.ts,
      );
    }
    final now = at ?? cursor;
    var i = _upperBound(now) - 1;
    i = i.clamp(0, _points.length - 2);
    final a = _points[i];
    final b = _points[i + 1];
    final span = b.ts.difference(a.ts).inMilliseconds;
    final jump = Geo.haversine(a.lat, a.lng, b.lat, b.lng) > 200 &&
        span > 5 * 60 * 1000;
    if (jump) {
      final atB = !now.isBefore(b.ts);
      return SampleResult(
        lat: atB ? b.lat : a.lat,
        lng: atB ? b.lng : a.lng,
        bearing: a.bearing,
        segmentIndex: i,
        ts: now,
      );
    }
    final f = span == 0 ? 0.0 : (now.difference(a.ts).inMilliseconds / span);
    final t = f.clamp(0.0, 1.0);
    return SampleResult(
      lat: a.lat + (b.lat - a.lat) * t,
      lng: a.lng + (b.lng - a.lng) * t,
      bearing: t < 0.5 ? a.bearing : Geo.bearing(a.lat, a.lng, b.lat, b.lng),
      segmentIndex: i,
      ts: now,
    );
  }

  int _upperBound(DateTime t) {
    var lo = 0;
    var hi = _points.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (!_points[mid].ts.isAfter(t)) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}

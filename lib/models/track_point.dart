class TrackPoint {
  const TrackPoint({
    required this.ts,
    required this.lat,
    required this.lng,
    this.speedKmh = 0,
    this.bearing = 0,
  });

  final DateTime ts;
  final double lat;
  final double lng;
  final double speedKmh;
  final double bearing;
}

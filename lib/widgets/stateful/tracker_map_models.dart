class MapMarkerData {
  const MapMarkerData({
    required this.id,
    required this.lat,
    required this.lng,
    this.label,
  });

  final String id;
  final double lat;
  final double lng;
  final String? label;
}

enum TrackerMapMode { markersOnly, playback }

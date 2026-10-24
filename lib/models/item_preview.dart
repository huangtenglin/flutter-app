import 'package:flutter/material.dart';

enum FreshnessTone { live, warn, stale, none }

class ItemPreview {
  const ItemPreview({
    required this.id,
    required this.name,
    required this.mono,
    required this.category,
    required this.iconKey,
    required this.freshnessLabel,
    required this.meta,
    required this.tone,
  });

  final String id;
  final String name;
  final String mono;
  final String category;
  final String iconKey;
  final String freshnessLabel;
  final String meta;
  final FreshnessTone tone;

  IconData get icon => switch (iconKey) {
        'bag' => Icons.backpack_outlined,
        'key' => Icons.key_outlined,
        'luggage' => Icons.luggage_outlined,
        'bike' => Icons.pedal_bike_outlined,
        _ => Icons.inventory_2_outlined,
      };
}

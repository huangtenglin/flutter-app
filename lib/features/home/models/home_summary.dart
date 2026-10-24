import 'package:my_multi_platform_app/models/item_preview.dart';

class HomeSummary {
  const HomeSummary({
    required this.hero,
    required this.trips,
    required this.staleItems,
    required this.counts,
    required this.lastPosition,
    required this.things,
    required this.unreadAlerts,
  });

  final HomeHero hero;
  final List<TripStop> trips;
  final List<StaleItem> staleItems;
  final HomeCounts counts;
  final LastPosition lastPosition;
  final List<ItemPreview> things;
  final int unreadAlerts;

  HomeSummary copyWith({
    HomeHero? hero,
    List<TripStop>? trips,
    List<StaleItem>? staleItems,
    HomeCounts? counts,
    LastPosition? lastPosition,
    List<ItemPreview>? things,
    int? unreadAlerts,
  }) {
    return HomeSummary(
      hero: hero ?? this.hero,
      trips: trips ?? this.trips,
      staleItems: staleItems ?? this.staleItems,
      counts: counts ?? this.counts,
      lastPosition: lastPosition ?? this.lastPosition,
      things: things ?? this.things,
      unreadAlerts: unreadAlerts ?? this.unreadAlerts,
    );
  }
}

class HomeHero {
  const HomeHero({
    required this.placeName,
    required this.itemName,
    required this.itemId,
    required this.address,
    required this.distanceFromYou,
    required this.freshnessLabel,
    required this.confidenceLabel,
    required this.checkedJustNow,
  });

  final String placeName;
  final String itemName;
  final String itemId;
  final String address;
  final String distanceFromYou;
  final String freshnessLabel;
  final String confidenceLabel;
  final bool checkedJustNow;

  HomeHero get checked {
    return HomeHero(
      placeName: placeName,
      itemName: itemName,
      itemId: itemId,
      address: address,
      distanceFromYou: distanceFromYou,
      freshnessLabel: 'Checked just now',
      confidenceLabel: confidenceLabel,
      checkedJustNow: true,
    );
  }
}

class TripStop {
  const TripStop({
    required this.title,
    required this.timeLabel,
    required this.isCurrent,
  });

  final String title;
  final String timeLabel;
  final bool isCurrent;
}

class StaleItem {
  const StaleItem({
    required this.name,
    required this.ageLabel,
  });

  final String name;
  final String ageLabel;
}

class HomeCounts {
  const HomeCounts({
    required this.items,
    required this.fresh,
    required this.stale,
  });

  final int items;
  final int fresh;
  final int stale;
}

class LastPosition {
  const LastPosition({
    required this.lat,
    required this.lng,
    required this.ts,
    required this.pinLabel,
    required this.freshnessLabel,
  });

  final double lat;
  final double lng;
  final DateTime ts;
  final String pinLabel;
  final String freshnessLabel;
}

import 'package:my_multi_platform_app/features/home/models/home_summary.dart';
import 'package:my_multi_platform_app/mock/items_mock.dart';
import 'package:my_multi_platform_app/mock/track_mock.dart';

abstract final class HomeMock {
  static Future<HomeSummary> fetchSummary({bool checkedJustNow = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return build(checkedJustNow: checkedJustNow);
  }

  static HomeSummary build({bool checkedJustNow = false}) {
    final age = checkedJustNow ? 'Checked just now' : 'Updated 8 min ago';
    final mapAge = checkedJustNow ? 'just now' : '8 min ago';
    return HomeSummary(
      hero: HomeHero(
        placeName: 'Lincoln Elementary',
        itemName: "Maya's backpack",
        itemId: 'bag',
        address: '1200 Barton Springs Rd',
        distanceFromYou: '2.1 mi from you',
        freshnessLabel: age,
        confidenceLabel: 'High confidence',
        checkedJustNow: checkedJustNow,
      ),
      trips: [
        const TripStop(title: 'Home', timeLabel: '7:58 AM', isCurrent: false),
        const TripStop(
          title: 'Lincoln Elem.',
          timeLabel: '8:12 AM',
          isCurrent: false,
        ),
        TripStop(
          title: 'Lincoln Elem.',
          timeLabel: mapAge,
          isCurrent: true,
        ),
      ],
      staleItems: const [
        StaleItem(name: 'luggage', ageLabel: '2 h'),
        StaleItem(name: 'bike', ageLabel: '21 h'),
      ],
      counts: const HomeCounts(items: 4, fresh: 2, stale: 2),
      lastPosition: LastPosition(
        lat: TrackMock.last.lat,
        lng: TrackMock.last.lng,
        ts: TrackMock.last.ts,
        pinLabel: 'Last seen',
        freshnessLabel: mapAge,
      ),
      things: ItemsMock.all.take(3).toList(growable: false),
      unreadAlerts: 3,
    );
  }
}

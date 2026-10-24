import 'package:my_multi_platform_app/models/item_preview.dart';

abstract final class ItemsMock {
  static const all = <ItemPreview>[
    ItemPreview(
      id: 'bag',
      name: "Maya's backpack",
      mono: 'BP',
      category: 'Bag',
      iconKey: 'bag',
      freshnessLabel: '8 min ago',
      meta: 'Lincoln Elementary · ±30 m',
      tone: FreshnessTone.live,
    ),
    ItemPreview(
      id: 'keys',
      name: 'House keys',
      mono: 'KY',
      category: 'Keys',
      iconKey: 'key',
      freshnessLabel: '2 min ago',
      meta: 'Home · kitchen drawer',
      tone: FreshnessTone.live,
    ),
    ItemPreview(
      id: 'case',
      name: 'Luggage · navy 24"',
      mono: 'LG',
      category: 'Luggage',
      iconKey: 'luggage',
      freshnessLabel: '2 h ago',
      meta: 'Austin-Bergstrom · Terminal 1',
      tone: FreshnessTone.warn,
    ),
    ItemPreview(
      id: 'bike',
      name: 'Gravel bike',
      mono: 'BK',
      category: 'Bike',
      iconKey: 'bike',
      freshnessLabel: '21 h ago',
      meta: 'East Austin · ±200 m',
      tone: FreshnessTone.stale,
    ),
  ];

  static ItemPreview? byId(String id) {
    for (final item in all) {
      if (item.id == id) return item;
    }
    return null;
  }

  static List<ItemPreview> filtered(String? filter) {
    return switch (filter) {
      'fresh' => all
          .where((i) => i.tone == FreshnessTone.live)
          .toList(growable: false),
      'stale' => all
          .where((i) => i.tone != FreshnessTone.live)
          .toList(growable: false),
      _ => all,
    };
  }
}

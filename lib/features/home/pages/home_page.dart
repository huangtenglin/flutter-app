import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_multi_platform_app/features/home/models/home_summary.dart';
import 'package:my_multi_platform_app/features/home/pages/home_sections.dart';
import 'package:my_multi_platform_app/features/home/providers/home_summary_provider.dart';
import 'package:my_multi_platform_app/utils/format/relative_time.dart';
import 'package:my_multi_platform_app/widgets/stateless/item_row.dart';
import 'package:my_multi_platform_app/widgets/stateless/metric_tile.dart';
import 'package:my_multi_platform_app/widgets/stateful/tracker_map.dart';
import 'package:my_multi_platform_app/widgets/stateful/tracker_map_models.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homeSummaryProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(homeSummaryProvider),
      ),
      data: (summary) => _HomeBody(summary: summary),
    );
  }
}

class _HomeBody extends ConsumerStatefulWidget {
  const _HomeBody({required this.summary});

  final HomeSummary summary;

  @override
  ConsumerState<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<_HomeBody> {
  final GlobalKey<TrackerMapState> _mapKey = GlobalKey<TrackerMapState>();

  HomeSummary get summary => widget.summary;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(homeSummaryProvider.notifier).refreshOptimistic(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: HomeGreetingHeader(
              dateLabel: RelativeTime.headerDate(now),
              greeting: RelativeTime.greeting(now),
            ),
          ),
          SliverToBoxAdapter(child: HomeHeroCard(hero: summary.hero)),
          SliverToBoxAdapter(
            child: HomeTripStrip(
              trips: summary.trips,
              itemId: summary.hero.itemId,
            ),
          ),
          SliverToBoxAdapter(child: HomeStaleBanner(items: summary.staleItems)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: MetricTile(
                      label: 'Items',
                      value: '${summary.counts.items}',
                      onTap: () => context.go('/items'),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: MetricTile(
                      label: 'Fresh',
                      value: '${summary.counts.fresh}',
                      onTap: () => context.go('/items?filter=fresh'),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: MetricTile(
                      label: 'Stale',
                      value: '${summary.counts.stale}',
                      onTap: () => context.go('/items?filter=stale'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: TrackerMap(
                key: _mapKey,
                mode: TrackerMapMode.markersOnly,
                height: 214,
                freshnessLabel: summary.lastPosition.freshnessLabel,
                interactive: false,
                onTap: () => context.push('/find/${summary.hero.itemId}'),
                markers: [
                  MapMarkerData(
                    id: summary.hero.itemId,
                    lat: summary.lastPosition.lat,
                    lng: summary.lastPosition.lng,
                    label: summary.lastPosition.pinLabel,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: HomeSectionHead(
              title: 'Your things',
              action: 'See all',
              onAction: () => context.go('/items'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0B000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < summary.things.length; i++) ...[
                      if (i > 0)
                        const Divider(
                          height: 1,
                          color: Color(0xFFF3F3F1),
                          indent: 14,
                          endIndent: 14,
                        ),
                      ItemRow(
                        item: summary.things[i],
                        onTap: () =>
                            context.push('/items/${summary.things[i].id}'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

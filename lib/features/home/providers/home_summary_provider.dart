import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_multi_platform_app/api/home/home_api.dart';
import 'package:my_multi_platform_app/core/constants/app_constants.dart';
import 'package:my_multi_platform_app/features/home/models/home_summary.dart';

final homeApiProvider = Provider<HomeApi>((ref) => HomeApi());

final homeSummaryProvider =
    AsyncNotifierProvider<HomeSummaryNotifier, HomeSummary>(
      HomeSummaryNotifier.new,
    );

class HomeSummaryNotifier extends AsyncNotifier<HomeSummary> {
  @override
  Future<HomeSummary> build() async {
    final timer = Timer.periodic(AppConstants.pollInterval, (_) {
      unawaited(silentReload());
    });
    ref.onDispose(timer.cancel);
    return ref.read(homeApiProvider).fetchSummary();
  }

  Future<void> silentReload() async {
    try {
      final next = await ref.read(homeApiProvider).fetchSummary();
      state = AsyncData(next);
    } catch (_) {}
  }

  Future<void> refreshOptimistic() async {
    final previous = state.value;
    if (previous != null) {
      state = AsyncData(previous.copyWith(hero: previous.hero.checked));
    }
    try {
      final next = await ref
          .read(homeApiProvider)
          .fetchSummary(forceFresh: true);
      state = AsyncData(next);
    } catch (error, stack) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(error, stack);
      }
    }
  }
}

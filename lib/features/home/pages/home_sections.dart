import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_multi_platform_app/app/theme.dart';
import 'package:my_multi_platform_app/core/constants/app_constants.dart';
import 'package:my_multi_platform_app/features/home/models/home_summary.dart';
import 'package:my_multi_platform_app/models/item_preview.dart';
import 'package:my_multi_platform_app/widgets/stateless/status_chip.dart';

class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({
    super.key,
    required this.dateLabel,
    required this.greeting,
  });

  final String dateLabel;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateLabel.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: Color(0xFF8D8D95),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.035,
                    height: 1.12,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/settings'),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.accent,
              child: Text(
                AppConstants.brandInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({super.key, required this.hero});

  final HomeHero hero;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECECEF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 30,
            offset: Offset(0, 14),
            spreadRadius: -22,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  hero.freshnessLabel.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.1,
                    color: AppColors.faint,
                  ),
                ),
              ),
              StatusChip(
                label: hero.confidenceLabel,
                tone: FreshnessTone.live,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hero.placeName,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.03,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${hero.itemName} · ${hero.address}\nStill being seen there · ${hero.distanceFromYou}',
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.45,
              color: Color(0xFF7C7C86),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  icon: Icons.place_outlined,
                  label: 'Open map',
                  solid: true,
                  onTap: () => context.push('/find/${hero.itemId}'),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _HeroAction(
                  icon: Icons.schedule,
                  label: "Today's route",
                  onTap: () => context.push('/places/${hero.itemId}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.solid = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: TextButton.icon(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: solid ? AppColors.accent : Colors.white,
          foregroundColor: solid ? Colors.white : AppColors.ink,
          side: solid
              ? BorderSide.none
              : const BorderSide(color: Color(0xFFE2E2E6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        icon: Icon(icon, size: 14),
        label: Text(label),
      ),
    );
  }
}

class HomeTripStrip extends StatelessWidget {
  const HomeTripStrip({super.key, required this.trips, required this.itemId});

  final List<TripStop> trips;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
      child: GestureDetector(
        onTap: () => context.push('/places/$itemId'),
        child: Row(
          children: [
            for (var i = 0; i < trips.length; i++)
              Expanded(
                child: _Stop(
                  stop: trips[i],
                  isLast: i == trips.length - 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Stop extends StatelessWidget {
  const _Stop({required this.stop, required this.isLast});

  final TripStop stop;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 11),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (!isLast)
            Positioned(
              left: -4,
              top: 7,
              right: 0,
              child: Container(height: 1, color: const Color(0xFFE4E4E8)),
            ),
          Positioned(
            left: -11,
            top: 4,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: stop.isCurrent ? 1 : 0.45),
                shape: BoxShape.circle,
                boxShadow: stop.isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.18),
                          spreadRadius: 3,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.01,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stop.timeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 8.5, color: AppColors.faint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeStaleBanner extends StatelessWidget {
  const HomeStaleBanner({super.key, required this.items});

  final List<StaleItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final detail = items.map((e) => '${e.name} ${e.ageLabel}').join(', ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: AppColors.staleBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.staleLine),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go('/alerts'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: AppColors.staleFg,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.45,
                        color: AppColors.staleFg,
                      ),
                      children: [
                        TextSpan(
                          text: '${items.length} items',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: " haven't reported in over 2 hours — $detail",
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.staleFg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSectionHead extends StatelessWidget {
  const HomeSectionHead({
    super.key,
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: Color(0xFF77777F),
              ),
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

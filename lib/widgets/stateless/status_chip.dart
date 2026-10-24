import 'package:flutter/material.dart';
import 'package:my_multi_platform_app/app/theme.dart';
import 'package:my_multi_platform_app/models/item_preview.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = FreshnessTone.none,
  });

  final String label;
  final FreshnessTone tone;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (tone) {
      FreshnessTone.live => (
        AppColors.accent.withValues(alpha: 0.10),
        AppColors.accent,
      ),
      FreshnessTone.warn => (AppColors.warnBg, AppColors.warnFg),
      FreshnessTone.stale => (const Color(0xFFFBECEA), const Color(0xFFA1281F)),
      FreshnessTone.none => (AppColors.pill, const Color(0xFF4A4A52)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.01,
        ),
      ),
    );
  }
}

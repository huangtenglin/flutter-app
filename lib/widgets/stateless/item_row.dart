import 'package:flutter/material.dart';
import 'package:my_multi_platform_app/app/theme.dart';
import 'package:my_multi_platform_app/models/item_preview.dart';
import 'package:my_multi_platform_app/widgets/stateless/status_chip.dart';

class ItemRow extends StatelessWidget {
  const ItemRow({super.key, required this.item, this.onTap});

  final ItemPreview item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _MonoAvatar(mono: item.mono, icon: item.icon),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.01,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            StatusChip(label: item.freshnessLabel, tone: item.tone),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFFB4B4BC),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonoAvatar extends StatelessWidget {
  const _MonoAvatar({required this.mono, required this.icon});

  final String mono;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F4),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Text(
              mono,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.02,
                color: Color(0xFF2A2A30),
              ),
            ),
          ),
          Positioned(
            right: -3,
            bottom: -3,
            child: Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E4E8)),
              ),
              child: Icon(icon, size: 9, color: const Color(0xFF4A4A52)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_multi_platform_app/app/theme.dart';
import 'package:my_multi_platform_app/features/playback/playback_engine.dart';

class PlaybackBar extends StatelessWidget {
  const PlaybackBar({super.key, required this.engine});

  final PlaybackEngine engine;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: engine,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: engine.toggle,
                    icon: Icon(switch (engine.state) {
                      PlayState.playing => Icons.pause,
                      PlayState.ended => Icons.refresh,
                      _ => Icons.play_arrow,
                    }),
                  ),
                  Expanded(
                    child: Slider(
                      value: engine.progress.clamp(0, 1),
                      activeColor: AppColors.accent,
                      onChangeStart: (_) => engine.pause(),
                      onChanged: engine.seekToProgress,
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      _clock(engine.cursor),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 6,
                children: [
                  for (final s in PlaybackEngine.speeds)
                    ChoiceChip(
                      label: Text('${s.toInt()}×'),
                      selected: engine.speed == s,
                      onSelected: (_) => engine.setSpeed(s),
                      visualDensity: VisualDensity.compact,
                      selectedColor: AppColors.accent.withValues(alpha: 0.16),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: engine.speed == s
                            ? AppColors.accent
                            : AppColors.muted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static String _clock(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final s = t.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

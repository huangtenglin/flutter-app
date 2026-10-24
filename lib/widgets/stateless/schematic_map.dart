import 'package:flutter/material.dart';
import 'package:my_multi_platform_app/app/theme.dart';

class SchematicMap extends StatelessWidget {
  const SchematicMap({
    super.key,
    required this.pinLabel,
    required this.freshnessLabel,
    this.onTap,
    this.onRecenter,
    this.height = 214,
  });

  final String pinLabel;
  final String freshnessLabel;
  final VoidCallback? onTap;
  final VoidCallback? onRecenter;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              Positioned(
                top: 9,
                left: 9,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x21000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 13,
                        color: AppColors.ink,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Last reported $freshnessLabel',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 9,
                bottom: 9,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onRecenter,
                    child: const SizedBox(
                      width: 31,
                      height: 31,
                      child: Icon(Icons.map_outlined, size: 15),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'Schematic preview · not geographic data',
                    style: TextStyle(
                      fontSize: 7,
                      color: Color(0xFF9C9CA4),
                      letterSpacing: 0.02,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.0, -0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(6.5),
                      ),
                      child: Text(
                        pinLabel,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accent, width: 1.7),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            blurRadius: 16,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF1F1F3),
    );
    final block = Paint()..color = const Color(0xFFE4E4E8);
    void rect(double l, double t, double w, double h) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            l / 360 * size.width,
            t / 240 * size.height,
            w / 360 * size.width,
            h / 240 * size.height,
          ),
          const Radius.circular(3),
        ),
        block,
      );
    }

    rect(10, 10, 92, 72);
    rect(138, 8, 72, 58);
    rect(248, 14, 104, 64);
    rect(8, 122, 86, 42);
    rect(132, 126, 88, 36);
    rect(254, 118, 98, 46);
    rect(14, 182, 70, 34);
    rect(118, 176, 60, 30);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          262 / 360 * size.width,
          164 / 240 * size.height,
          88 / 360 * size.width,
          48 / 240 * size.height,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFDEE6D6),
    );

    final water = Path()
      ..moveTo(0, 206 / 240 * size.height)
      ..cubicTo(
        64 / 360 * size.width,
        198 / 240 * size.height,
        112 / 360 * size.width,
        218 / 240 * size.height,
        178 / 360 * size.width,
        216 / 240 * size.height,
      )
      ..cubicTo(
        246 / 360 * size.width,
        214 / 240 * size.height,
        300 / 360 * size.width,
        226 / 240 * size.height,
        size.width,
        218 / 240 * size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFFD6E0E6));

    final road = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    road.strokeWidth = 14 / 240 * size.height;
    canvas.drawLine(
      Offset(0, 104 / 240 * size.height),
      Offset(size.width, 104 / 240 * size.height),
      road,
    );
    road.strokeWidth = 9 / 240 * size.height;
    canvas.drawLine(
      Offset(0, 176 / 240 * size.height),
      Offset(size.width, 176 / 240 * size.height),
      road,
    );
    road.strokeWidth = 14 / 360 * size.width;
    canvas.drawLine(
      Offset(118 / 360 * size.width, 0),
      Offset(118 / 360 * size.width, size.height),
      road,
    );
    road.strokeWidth = 8 / 360 * size.width;
    canvas.drawLine(
      Offset(236 / 360 * size.width, 0),
      Offset(236 / 360 * size.width, size.height),
      road,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

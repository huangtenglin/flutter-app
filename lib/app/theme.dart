import 'package:flutter/material.dart';

abstract final class AppColors {
  static const accent = Color(0xFF1F4FD8);
  static const ink = Color(0xFF111113);
  static const canvas = Color(0xFFF6F6F3);
  static const muted = Color(0xFF7A7A82);
  static const faint = Color(0xFF8A8A92);
  static const line = Color(0xFFE9E9EC);
  static const pill = Color(0xFFF0F0F2);
  static const warnBg = Color(0xFFFDF1E4);
  static const warnFg = Color(0xFF94500C);
  static const staleBg = Color(0xFFFBF3E4);
  static const staleFg = Color(0xFF6B4A12);
  static const staleLine = Color(0xFFF1E3C4);
}

abstract final class AppTheme {
  static ThemeData get light {
    const seed = AppColors.accent;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      primary: seed,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.ink,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          letterSpacing: -0.01,
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.ink),
      ),
    );
  }
}

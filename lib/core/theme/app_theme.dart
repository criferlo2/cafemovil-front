import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.caramel,
      primary: AppColors.caramel,
      secondary: AppColors.deepGreen,
      surface: AppColors.cream,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.coffeeBrown,
        centerTitle: false,
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.caramel.withValues(alpha: 0.18),
        labelStyle: const TextStyle(color: AppColors.coffeeBrown),
        side: BorderSide(color: AppColors.coffeeBrown.withValues(alpha: 0.12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.caramel,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}

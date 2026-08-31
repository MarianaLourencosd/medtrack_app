import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Colors.grey.shade50,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
        fontFamily: 'Karla',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'Karla',
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 4,
      color: AppColors.white,
    ),
  );
}
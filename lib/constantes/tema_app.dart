import 'package:flutter/material.dart';

class TemaController {
  static final ValueNotifier<bool> modoEscuro =
      ValueNotifier<bool>(false);

  static void alternar() {
    modoEscuro.value = !modoEscuro.value;
  }
}

class AppTheme {
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _darkBackground = Color(0xFF0F1419);
  static const Color _darkSurface = Color(0xFF1A2029);
  static const Color _primary = Color(0xFF00614C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _primary,
      surface: _lightSurface,
      onSurface: Color(0xFF1A1A1A),
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: _lightBackground,
    cardColor: _lightSurface,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      surface: _darkSurface,
      onSurface: Color(0xFFFFFFFF),
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: _darkBackground,
    cardColor: _darkSurface,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
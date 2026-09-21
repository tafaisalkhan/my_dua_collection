import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => _theme(Brightness.light);
  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7A4FCB),
      brightness: brightness,
      primary: dark ? const Color(0xFFD0B7FF) : const Color(0xFF6842B8),
      secondary: dark ? const Color(0xFFFFCA80) : const Color(0xFFE78324),
      tertiary: dark ? const Color(0xFF8BE0D0) : const Color(0xFF148F7B),
      surface: dark ? const Color(0xFF243442) : const Color(0xFFFFFCF5),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? const Color(0xFF182731) : Colors.white,
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: dark ? Colors.black38 : const Color(0x337A4FCB),
        color: scheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF2E4352) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: .3)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: dark ? const Color(0xFF203542) : Colors.white,
        indicatorColor: scheme.primaryContainer,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: dark ? const Color(0xFF203542) : Colors.white,
        foregroundColor: dark ? Colors.white : const Color(0xFF3B2854),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
    );
  }
}

import 'package:flutter/material.dart';

ThemeData buildPublicTheme() {
  const brandBlue = Color(0xFF1E7BFF);
  const brandOrange = Color(0xFFFF8A00);

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    visualDensity: VisualDensity.standard,
    colorScheme: ColorScheme.fromSeed(seedColor: brandBlue),
  );

  return base.copyWith(
    scaffoldBackgroundColor: base.colorScheme.surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: base.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 16,
      toolbarHeight: 72,
      shape: Border(
        bottom: BorderSide(color: base.colorScheme.outlineVariant),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: base.colorScheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: base.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: base.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: brandOrange,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: brandBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: brandBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
    ),
    textTheme: base.textTheme.copyWith(
      displaySmall: const TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w600,
        height: 1.08,
        letterSpacing: -0.4,
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.2,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.1,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        height: 1.6,
        letterSpacing: 0.1,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.6,
        letterSpacing: 0.1,
      ),
    ),
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  // 폰트 파일과 pubspec 등록 후 'Cafe24Ssurround'로 바꾸세요.
  static const String? fontFamily = null;
  static const ivory = Color(0xFFF8F5EE);
  static const ink = Color(0xFF242420);
  static const lilac = Color(0xFFE7DFF6);
  static const mint = Color(0xFFDDECDD);
  static const peach = Color(0xFFF8DECC);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          primary: ink,
          surface: ivory,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ivory,
          foregroundColor: ink,
          centerTitle: false,
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

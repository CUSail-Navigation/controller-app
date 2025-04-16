import 'package:flutter/material.dart';

final ThemeData marineTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF003f5c),
  scaffoldBackgroundColor: const Color(0xFFe0f7fa),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF003f5c),
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF002b45)),
    bodyMedium: TextStyle(color: Color(0xFF002b45)),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0xFF2a9d8f),
  ),
);
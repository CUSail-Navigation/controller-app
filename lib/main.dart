import 'package:flutter/material.dart';
import 'screens/server_input_page.dart';
import 'themes/marine_theme.dart';

void main() {
  runApp(const SailboatApp());
}

class SailboatApp extends StatelessWidget {
  const SailboatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sailboat Controller',
      theme: marineTheme,
      home: const ServerInputPage(),
    );
  }
}
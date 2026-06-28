(import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LlanoMusicApp());
}

class LlanoMusicApp extends StatelessWidget {
  const LlanoMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Llano Music',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}

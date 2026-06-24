import 'package:flutter/material.dart';
import 'home_page.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

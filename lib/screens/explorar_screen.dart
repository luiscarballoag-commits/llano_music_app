import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/clasicos_llano.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';

class ExplorarScreen extends StatelessWidget {
  const ExplorarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explorar"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Próximamente\nGrandes Voces del Llano",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

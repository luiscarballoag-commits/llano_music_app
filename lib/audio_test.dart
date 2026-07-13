import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioTest extends StatefulWidget {
  const AudioTest({super.key});

  @override
  State<AudioTest> createState() => _AudioTestState();
}

class _AudioTestState extends State<AudioTest> {
  final AudioPlayer player = AudioPlayer();

  String estado = "Sin reproducir";

  Future<void> reproducir() async {
    try {
      await player.stop();

      await player.play(
        AssetSource(
          "audio/roberto_carballo/aqui_esta_roberto_el_zorro.mp3",
        ),
      );

      setState(() {
        estado = "Reproduciendo";
      });
    } catch (e) {
      setState(() {
        estado = "ERROR:\n$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prueba de Audio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: reproducir,
              child: const Text("Reproducir MP3"),
            ),
            const SizedBox(height: 20),
            Text(
              estado,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

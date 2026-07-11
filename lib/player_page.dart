import 'package:flutter/material.dart';
import 'services/audio_player_service.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      if (!mounted) return false;

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {});
      }

      return mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: const Text("Reproduciendo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                AudioPlayerService.imagen.isEmpty
                    ? "assets/images/logo/logo_llano_music.png"
                    : AudioPlayerService.imagen,
                width: 280,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 280,
                    height: 280,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.music_note,
                      size: 120,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            Text(
              AudioPlayerService.titulo.isEmpty
                  ? "Seleccione una canción"
                  : AudioPlayerService.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              AudioPlayerService.artista,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 45,
                  onPressed: () {},
                  icon: const Icon(Icons.skip_previous),
                ),
                IconButton(
                  iconSize: 70,
                  color: Colors.green,
                  onPressed: () async {
                    if (AudioPlayerService.reproduciendo) {
                      await AudioPlayerService.pause();
                    } else {
                      await AudioPlayerService.resume();
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    AudioPlayerService.reproduciendo
                        ? Icons.pause_circle
                        : Icons.play_circle,
                  ),
                ),
                IconButton(
                  iconSize: 45,
                  onPressed: () {},
                  icon: const Icon(Icons.skip_next),
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

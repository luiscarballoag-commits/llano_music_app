import 'package:flutter/material.dart';
import 'services/audio_player_service.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioPlayerService.instance,
      builder: (context, _) {
        final player = AudioPlayerService.instance;

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
                    player.imagen.isEmpty
                        ? "assets/images/logo/logo_llano_music.png"
                        : player.imagen,
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
                  player.titulo.isEmpty
                      ? "Seleccione una canción"
                      : player.titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  player.artista,
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
                        if (player.reproduciendo) {
                          await player.pause();
                        } else {
                          await player.resume();
                        }
                      },
                      icon: Icon(
                        player.reproduciendo
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
      },
    );
  }
}

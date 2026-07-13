import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioPlayerService.instance,
      builder: (context, _) {
        final player = AudioPlayerService.instance;

        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  player.imagen.isEmpty
                      ? "assets/images/logo/logo_llano_music.png"
                      : player.imagen,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.music_note,
                      size: 60,
                      color: Colors.white,
                    );
                  },
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.titulo.isEmpty
                          ? "Llano Music"
                          : player.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      player.artista.isEmpty
                          ? "Seleccione una canción"
                          : player.artista,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: Icon(
                  player.reproduciendo
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.green,
                  size: 42,
                ),
                onPressed: () async {
                  if (player.reproduciendo) {
                    await player.pause();
                  } else {
                    await player.resume();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

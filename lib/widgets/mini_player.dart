import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {

  @override
  Widget build(BuildContext context) {

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
              AudioPlayerService.imagen.isEmpty
                  ? "assets/images/logo/logo.png"
                  : AudioPlayerService.imagen,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  AudioPlayerService.titulo.isEmpty
                      ? "Llano Music"
                      : AudioPlayerService.titulo,
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
                  AudioPlayerService.artista.isEmpty
                      ? "Seleccione una canción"
                      : AudioPlayerService.artista,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              AudioPlayerService.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              color: Colors.green,
              size: 42,
            ),
            onPressed: () async {

              if (AudioPlayerService.isPlaying) {
                await AudioPlayerService.pause();
              } else {
                await AudioPlayerService.resume();
              }

              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}       

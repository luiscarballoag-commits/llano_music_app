import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
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
    return Material(
      elevation: 12,
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        color: const Color(0xFF1E1E1E),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                AudioPlayerService.imagen.isEmpty
                    ? "assets/images/logo/logo_llano_music.png"
                    : AudioPlayerService.imagen,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 55,
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    AudioPlayerService.artista.isEmpty
                        ? "Seleccione una canción"
                        : AudioPlayerService.artista,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              iconSize: 42,
              color: Colors.green,
              icon: Icon(
                AudioPlayerService.reproduciendo
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../lista_canciones.dart';
import '../services/audio_player_service.dart';

class CancionesPopulares extends StatelessWidget {
  const CancionesPopulares({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Canciones Populares",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listaCanciones.length,
          itemBuilder: (context, index) {
            final cancion = listaCanciones[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    cancion.imagen,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.music_note,
                        size: 55,
                        color: Colors.green,
                      );
                    },
                  ),
                ),
                title: Text(cancion.titulo),
                subtitle: Text(cancion.artista),
                trailing: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.green,
                  size: 35,
                ),
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      content: Text(
                        "Intentando reproducir:\n${cancion.audio}",
                      ),
                    ),
                  );

                  try {
                    await AudioPlayerService.playSong(
                      audio: cancion.audio,
                      songTitle: cancion.titulo,
                      songArtist: cancion.artista,
                      songImage: cancion.imagen,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text("✅ playSong() ejecutado"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 5),
                        content: Text("❌ Error:\n$e"),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

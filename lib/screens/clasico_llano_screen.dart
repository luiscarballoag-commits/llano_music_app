import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/clasicos_llano.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import '../widgets/agregar_a_playlist_dialog.dart';

class ClasicoLlanoScreen extends StatelessWidget {
  final ClasicoLlano artista;

  const ClasicoLlanoScreen({
    super.key,
    required this.artista,
  });

  List<Cancion> get canciones {
    return artista.canciones
        .map(
          (c) => Cancion(
            artista: artista.artista,
            titulo: c.titulo,
            imagen: artista.imagen,
            audio: c.audio,
          ),
        )
        .toList();
  }

  Future<void> reproducir(
    BuildContext context,
    int index,
  ) async {
    final lista = canciones;

    AudioPlayerService.instance.cargarCola(
      lista,
      index,
    );

    final cancion = lista[index];

    await AudioPlayerService.instance.play(
      audio: cancion.audio,
      tituloCancion: cancion.titulo,
      artistaCancion: cancion.artista,
      imagenCancion: cancion.imagen,
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlayerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = canciones;

    return Scaffold(
      appBar: AppBar(
        title: Text(artista.artista),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              artista.imagen,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 260,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          Text(
            artista.artista,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            artista.apodo,
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${artista.estado}, ${artista.pais}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Canciones',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...List.generate(
            lista.length,
            (index) {
              final cancion = lista[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      artista.imagen,
                    ),
                  ),
                  title: Text(
                    cancion.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Agregar a playlist',
                        icon: const Icon(
                          Icons.playlist_add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          mostrarAgregarAPlaylistDialog(
                            context: context,
                            audio: cancion.audio,
                            tituloCancion: cancion.titulo,
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Reproducir',
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.green,
                          size: 32,
                        ),
                        onPressed: () {
                          reproducir(
                            context,
                            index,
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    reproducir(
                      context,
                      index,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

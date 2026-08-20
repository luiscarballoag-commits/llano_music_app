import 'package:flutter/material.dart';

import '../data/all_songs.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;
  final String nombre;
  final List<String> canciones;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.nombre,
    required this.canciones,
  });

  @override
  Widget build(BuildContext context) {
    final lista = allSongs
        .where((cancion) => canciones.contains(cancion.audio))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: Text(nombre),
        centerTitle: true,
      ),
      body: lista.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.queue_music,
                      size: 90,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Esta playlist está vacía',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Agrega canciones para comenzar a disfrutarla.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final cancion = lista[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
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
                            size: 45,
                            color: Colors.green,
                          );
                        },
                      ),
                    ),
                    title: Text(
                      cancion.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      cancion.artista,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.green,
                      size: 34,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

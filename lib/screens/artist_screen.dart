import 'package:flutter/material.dart';

import '../cancion.dart';
import '../models/artist.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import '../data/all_songs.dart';
import '../widgets/agregar_a_playlist_dialog.dart';

class ArtistScreen extends StatelessWidget {
  final Artist artist;

  const ArtistScreen({
    super.key,
    required this.artist,
  });

  Future<void> _reproducirCancion(
    BuildContext context,
    List<Cancion> canciones,
    int indice,
  ) async {
    final cancion = canciones[indice];

    AudioPlayerService.instance.cargarCola(
      canciones,
      indice,
    );

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

  Widget _imagenArtista({
    required String imagen,
    required double width,
    required double height,
  }) {
    final esRemota =
        imagen.startsWith('http://') ||
        imagen.startsWith('https://');

    if (esRemota) {
      return Image.network(
        imagen,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.person,
            size: 80,
            color: Colors.grey,
          );
        },
      );
    }

    return Image.asset(
      imagen,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return const Icon(
          Icons.person,
          size: 80,
          color: Colors.grey,
        );
      },
    );
  }

  Widget _imagenCancion({
    required String imagen,
  }) {
    final esRemota =
        imagen.startsWith('http://') ||
        imagen.startsWith('https://');

    if (esRemota) {
      return Image.network(
        imagen,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 50,
            height: 50,
            color: Colors.green.shade100,
            child: const Icon(
              Icons.music_note,
              color: Colors.green,
            ),
          );
        },
      );
    }

    return Image.asset(
      imagen,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: 50,
          height: 50,
          color: Colors.green.shade100,
          child: const Icon(
            Icons.music_note,
            color: Colors.green,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canciones = allSongs
        .where(
          (cancion) => cancion.artista == artist.nombre,
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: Text(artist.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16),
                  child: Container(
                    width: 145,
                    height: 145,
                    color: Colors.white,
                    child: _imagenArtista(
                      imagen: artist.imagen,
                      width: 145,
                      height: 145,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        artist.nombre,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              artist.genero,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${artist.estado}, '
                              '${artist.pais}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${canciones.length} '
                        '${canciones.length == 1 ? 'canción' : 'canciones'}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Canciones',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (canciones.isEmpty)
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Este artista todavía no tiene '
                  'canciones disponibles.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            else
              ...canciones.asMap().entries.map(
                (entrada) {
                  final indice = entrada.key;
                  final cancion = entrada.value;

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: _imagenCancion(
                          imagen: cancion.imagen,
                        ),
                      ),

                      title: Text(
                        cancion.titulo,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        artist.nombre,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip:
                                'Agregar a playlist',
                            icon: const Icon(
                              Icons.playlist_add,
                              color: Colors.green,
                              size: 30,
                            ),
                            onPressed: () {
                              mostrarAgregarAPlaylistDialog(
                                context: context,
                                audio: cancion.audio,
                                tituloCancion:
                                    cancion.titulo,
                              );
                            },
                          ),

                          const Icon(
                            Icons.play_circle_fill,
                            color: Colors.green,
                            size: 32,
                          ),
                        ],
                      ),

                      onTap: () {
                        _reproducirCancion(
                          context,
                          canciones,
                          indice,
                        );
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            const Text(
              'Biografía',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              artist.descripcion,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

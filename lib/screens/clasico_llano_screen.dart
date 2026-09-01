import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/clasicos_llano.dart';
import '../repositories/catalogo_music_repository.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import '../widgets/agregar_a_playlist_dialog.dart';

class ClasicoLlanoScreen extends StatelessWidget {
  final ClasicoLlano artista;

  const ClasicoLlanoScreen({
    super.key,
    required this.artista,
  });

  Widget imagenFlexible(
    String imagen, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    final esRemota =
        imagen.startsWith('http://') ||
        imagen.startsWith('https://');

    if (esRemota) {
      return Image.network(
        imagen,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    return Image.asset(
      imagen,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }

  String get imagenArtista {
    final remota = CatalogoMusicRepository.instance.canciones
        .where(
          (c) =>
              c.artista.trim().toLowerCase() ==
              artista.artista.trim().toLowerCase() &&
              c.imagen.trim().isNotEmpty,
        )
        .map((c) => c.imagen.trim())
        .firstWhere(
          (imagen) => imagen.isNotEmpty,
          orElse: () => '',
        );

    return remota.isNotEmpty ? remota : artista.imagen;
  }

  List<Cancion> get canciones {
    final resultado = <Cancion>[];

    // Canciones locales del artista
    for (final c in artista.canciones) {
      resultado.add(
        Cancion(
          artista: artista.artista,
          titulo: c.titulo,
          imagen: imagenArtista,
          audio: c.audio,
        ),
      );
    }

    // Canciones del catálogo remoto pertenecientes al artista
    final remotas = CatalogoMusicRepository.instance.canciones
        .where(
          (c) =>
              c.artista.trim().toLowerCase() ==
              artista.artista.trim().toLowerCase(),
        );

    for (final cancion in remotas) {
      final existe = resultado.any(
        (c) =>
            c.titulo.trim().toLowerCase() ==
            cancion.titulo.trim().toLowerCase(),
      );

      if (!existe) {
        resultado.add(
          Cancion(
            artista: artista.artista,
            titulo: cancion.titulo,
            imagen: imagenArtista,
            audio: cancion.audio,
          ),
        );
      }
    }

    return resultado;
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
      backgroundColor: const Color(0xFFF3F5F7),

      appBar: AppBar(
        title: Text(artista.artista),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // INFORMACIÓN DEL ARTISTA
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 145,
                  height: 145,
                  color: Colors.white,
                  child: imagenFlexible(
                    imagenArtista,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artista.artista,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.music_note,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            artista.apodo,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${artista.estado}, '
                            '${artista.pais}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${lista.length} '
                      '${lista.length == 1 ? 'canción' : 'canciones'}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
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

          if (lista.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
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
            ...List.generate(
              lista.length,
              (index) {
                final cancion = lista[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),

                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imagenFlexible(
                        imagenArtista,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 70,
                            height: 70,
                            color: Colors.green.shade100,
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.green,
                            ),
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
                        fontSize: 18,
                      ),
                    ),

                    subtitle: Text(
                      artista.artista,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Agregar a playlist',
                          icon: const Icon(
                            Icons.playlist_add,
                            color: Colors.green,
                            size: 30,
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
                            size: 38,
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

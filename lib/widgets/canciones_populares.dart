import 'package:flutter/material.dart';

import '../lista_canciones.dart';
import '../viewmodels/home_view_model.dart';
import '../models/artist.dart';
import '../screens/artist_screen.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import 'agregar_a_playlist_dialog.dart';

class CancionesPopulares extends StatefulWidget {
  const CancionesPopulares({super.key});

  @override
  State<CancionesPopulares> createState() =>
      _CancionesPopularesState();
}

class _CancionesPopularesState
    extends State<CancionesPopulares> {
  bool mostrarTodas = false;

  List<Artist> get artistasAdicionales {
    final artistasPopulares =
        listaCanciones.map((c) => c.artista).toSet();

    final viewModel = HomeViewModel();

    return viewModel.artists.where((artist) {
      return artistasPopulares.contains(artist.nombre) &&
          !artist.destacado;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cantidad = mostrarTodas
        ? listaCanciones.length
        : (listaCanciones.length > 8
            ? 8
            : listaCanciones.length);

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
          itemCount: cantidad,
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

                title: Text(
                  cancion.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                subtitle: Text(
                  cancion.artista,
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

                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.green,
                      size: 35,
                    ),
                  ],
                ),

                onTap: () async {
                  AudioPlayerService.instance.cargarCola(
                    listaCanciones,
                    index,
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
                },
              ),
            );
          },
        ),

        if (listaCanciones.length > 8)
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  mostrarTodas = !mostrarTodas;
                });
              },
              icon: Icon(
                mostrarTodas
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              label: Text(
                mostrarTodas ? "Ver menos" : "Ver más",
              ),
            ),
          ),

        if (artistasAdicionales.isNotEmpty) ...[
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Artistas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 155,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: artistasAdicionales.length,
              itemBuilder: (context, index) {
                final artist = artistasAdicionales[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArtistScreen(
                          artist: artist,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 125,
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            artist.imagen,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 110,
                                height: 110,
                                color: Colors.green.shade100,
                                child: const Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          artist.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

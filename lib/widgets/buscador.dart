import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/all_songs.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import 'agregar_a_playlist_dialog.dart';

class Buscador extends StatefulWidget {
  const Buscador({super.key});

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  final TextEditingController _controller =
      TextEditingController();

  List<Cancion> resultados = [];

  void buscar(String texto) {
    final busqueda = texto.trim().toLowerCase();

    setState(() {
      if (busqueda.isEmpty) {
        resultados = [];
        return;
      }

      resultados = allSongs.where((cancion) {
        return cancion.titulo
                .toLowerCase()
                .contains(busqueda) ||
            cancion.artista
                .toLowerCase()
                .contains(busqueda);
      }).take(10).toList();
    });
  }

  Future<void> reproducir(Cancion cancion) async {
    AudioPlayerService.instance.cargarCola(
      [cancion],
      0,
    );

    await AudioPlayerService.instance.play(
      audio: cancion.audio,
      tituloCancion: cancion.titulo,
      artistaCancion: cancion.artista,
      imagenCancion: cancion.imagen,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlayerPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: TextField(
            controller: _controller,
            onChanged: buscar,
            decoration: InputDecoration(
              hintText:
                  "Buscar artistas o canciones...",
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.green,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  const EdgeInsets.symmetric(
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        if (resultados.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: resultados.map((cancion) {
                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: const Icon(
                      Icons.music_note,
                      color: Colors.green,
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
                      cancion.artista,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip:
                              'Agregar a playlist',
                          icon: const Icon(
                            Icons.playlist_add,
                            color: Colors.green,
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
                        ),
                      ],
                    ),

                    onTap: () =>
                        reproducir(cancion),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

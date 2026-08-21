import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/all_songs.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import '../services/playlist_service.dart';

class PlaylistDetailScreen extends StatefulWidget {
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
  State<PlaylistDetailScreen> createState() =>
      _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState
    extends State<PlaylistDetailScreen> {
  late List<Cancion> lista;

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    lista = allSongs
        .where(
          (cancion) =>
              widget.canciones.contains(cancion.audio),
        )
        .toList();
  }

  Future<void> _reproducirCancion(int index) async {
    if (lista.isEmpty) return;

    final cancion = lista[index];

    AudioPlayerService.instance.cargarCola(
      lista,
      index,
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

  Future<void> _reproducirTodaLaPlaylist() async {
    if (lista.isEmpty) return;

    final primera = lista.first;

    AudioPlayerService.instance.cargarCola(
      lista,
      0,
    );

    await AudioPlayerService.instance.play(
      audio: primera.audio,
      tituloCancion: primera.titulo,
      artistaCancion: primera.artista,
      imagenCancion: primera.imagen,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlayerPage(),
      ),
    );
  }

  Future<void> _quitarCancion(Cancion cancion) async {
    await PlaylistService.instance.quitarCancion(
      widget.playlistId,
      cancion.audio,
    );

    if (!mounted) return;

    setState(() {
      widget.canciones.remove(cancion.audio);
      _actualizarLista();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${cancion.titulo}" fue quitada de la playlist',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: Text(widget.nombre),
        centerTitle: true,
      ),
      body: lista.isEmpty
          ? _playlistVacia()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _reproducirTodaLaPlaylist,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'Reproducir playlist',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final cancion = lista[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          leading: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10),
                            child: Image.asset(
                              cancion.imagen,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) {
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
                                tooltip: 'Quitar de playlist',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _confirmarEliminar(
                                    cancion,
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: 'Reproducir',
                                icon: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.green,
                                  size: 34,
                                ),
                                onPressed: () {
                                  _reproducirCancion(
                                    index,
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            _reproducirCancion(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _playlistVacia() {
    return Center(
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
    );
  }

  Future<void> _confirmarEliminar(
    Cancion cancion,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Quitar canción',
          ),
          content: Text(
            '¿Quieres quitar "${cancion.titulo}" de esta playlist?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Quitar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await _quitarCancion(cancion);
    }
  }
}

import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/all_songs.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import '../services/favorites_service.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  Future<void> _reproducir(
    BuildContext context,
    int index,
    List<Cancion> canciones,
  ) async {
    final cancion = canciones[index];

    AudioPlayerService.instance.cargarCola(
      canciones,
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
  }

  @override
  Widget build(BuildContext context) {
    final favoritos =
        FavoritesService.instance.obtenerFavoritos();

    final canciones = allSongs
        .where((c) => favoritos.contains(c.audio))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: const Text("Mis Favoritas"),
        centerTitle: true,
      ),
      body: canciones.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 90,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Aún no tienes canciones favoritas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Pulsa el corazón ❤️ de cualquier canción para agregarla aquí.",
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
              itemCount: canciones.length,
              itemBuilder: (context, index) {
                final cancion = canciones[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
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
                    trailing: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.green,
                      size: 32,
                    ),
                    onTap: () {
                      _reproducir(
                        context,
                        index,
                        canciones,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../data/canciones_populares.dart';
import '../lista_canciones.dart';
import '../models/artist.dart';
import '../repositories/catalogo_music_repository.dart';
import '../screens/artist_screen.dart';
import '../viewmodels/home_view_model.dart';

class TodosArtistasScreen extends StatelessWidget {
  const TodosArtistasScreen({super.key});

  String _clave(String nombre) {
    return nombre.trim().toLowerCase();
  }

  String _idDesdeNombre(String nombre) {
    return _clave(nombre)
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  String _imagenParaArtista(String nombre) {
    for (final artist in HomeViewModel().artists) {
      if (_clave(artist.nombre) == _clave(nombre) &&
          artist.imagen.trim().isNotEmpty) {
        return artist.imagen.trim();
      }
    }

    for (final cancion in listaCanciones) {
      if (_clave(cancion.artista) == _clave(nombre) &&
          cancion.imagen.trim().isNotEmpty) {
        return cancion.imagen.trim();
      }
    }

    for (final cancion in cancionesPopulares) {
      if (_clave(cancion.artista) == _clave(nombre) &&
          cancion.imagen.trim().isNotEmpty) {
        return cancion.imagen.trim();
      }
    }

    for (final cancion in CatalogoMusicRepository.instance.canciones) {
      if (_clave(cancion.artista) == _clave(nombre) &&
          cancion.imagen.trim().isNotEmpty) {
        return cancion.imagen.trim();
      }
    }

    return 'assets/images/logo/logo_llano_music.png';
  }

  List<Artist> _obtenerArtistas() {
    final resultado = <Artist>[];
    final indices = <String>{};

    void agregar(Artist artist) {
      final clave = _clave(artist.nombre);

      if (clave.isEmpty || indices.contains(clave)) {
        return;
      }

      indices.add(clave);
      resultado.add(artist);
    }

    // Artistas que ya forman parte del catálogo local.
    for (final artist in HomeViewModel().artists) {
      agregar(artist);
    }

    // Artistas que aparecen en Canciones Populares.
    for (final cancion in cancionesPopulares) {
      final nombre = cancion.artista.trim();

      if (nombre.isEmpty || indices.contains(_clave(nombre))) {
        continue;
      }

      agregar(
        Artist(
          id: _idDesdeNombre(nombre),
          nombre: nombre,
          imagen: cancion.imagen.trim().isNotEmpty
              ? cancion.imagen.trim()
              : _imagenParaArtista(nombre),
          descripcion: 'Artista de Llano Music.',
          genero: 'Música Llanera',
          estado: '',
          pais: 'Venezuela',
          destacado: false,
          verificado: false,
        ),
      );
    }

    // Artistas nuevos provenientes del catálogo remoto.
    for (final cancion
        in CatalogoMusicRepository.instance.canciones) {
      final nombre = cancion.artista.trim();

      if (nombre.isEmpty || indices.contains(_clave(nombre))) {
        continue;
      }

      agregar(
        Artist(
          id: _idDesdeNombre(nombre),
          nombre: nombre,
          imagen: cancion.imagen.trim().isNotEmpty
              ? cancion.imagen.trim()
              : _imagenParaArtista(nombre),
          descripcion: 'Artista del catálogo de Llano Music.',
          genero: 'Música Llanera',
          estado: '',
          pais: 'Venezuela',
          destacado: false,
          verificado: false,
        ),
      );
    }

    return resultado;
  }

  Widget _imagenArtista(Artist artist) {
    final imagen = artist.imagen.trim();

    if (imagen.startsWith('http://') ||
        imagen.startsWith('https://')) {
      return Image.network(
        imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: Colors.green.shade100,
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.green,
            ),
          );
        },
      );
    }

    return Image.asset(
      imagen,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: Colors.green.shade100,
          child: const Icon(
            Icons.person,
            size: 60,
            color: Colors.green,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final artistas = _obtenerArtistas();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: const Text('Todos los artistas'),
      ),
      body: artistas.isEmpty
          ? const Center(
              child: Text(
                'No hay artistas disponibles.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: 0.78,
              ),
              itemCount: artistas.length,
              itemBuilder: (context, index) {
                final artist = artistas[index];

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
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(18),
                          child: _imagenArtista(artist),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artist.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

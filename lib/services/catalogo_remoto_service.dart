import 'dart:convert';

import 'package:http/http.dart' as http;

class CatalogoRemotoService {
  CatalogoRemotoService._();

  static final CatalogoRemotoService instance =
      CatalogoRemotoService._();

  static const String catalogoUrl =
      'https://raw.githubusercontent.com/luiscarballoag-commits/llano_music_catalogo/master/catalogo.json';

  Future<Map<String, dynamic>> cargarCatalogoCompleto() async {
    try {
      final respuesta = await http
          .get(Uri.parse(catalogoUrl))
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode != 200) {
        throw Exception(
          'No se pudo descargar el catálogo. '
          'Código: ${respuesta.statusCode}',
        );
      }

      final dynamic datos = jsonDecode(respuesta.body);

      if (datos is! Map<String, dynamic>) {
        throw Exception(
          'El catálogo remoto no tiene un formato válido.',
        );
      }

      return datos;
    } catch (e) {
      throw Exception(
        'Error cargando catálogo remoto: $e',
      );
    }
  }

  Future<List<Map<String, dynamic>>> cargarCatalogo() async {
    final datos = await cargarCatalogoCompleto();

    final List<Map<String, dynamic>> resultado = [];

    // ===========================
    // ÁLBUMES
    // ===========================

    final dynamic albumes = datos['albumes'];

    if (albumes is List) {
      for (final album in albumes) {
        if (album is! Map) continue;

        final artista =
            album['artista']?.toString().trim() ?? '';

        final imagen =
            album['imagen']?.toString().trim() ?? '';

        final tituloAlbum =
            album['titulo']?.toString().trim() ?? '';

        final idAlbum =
            album['id']?.toString().trim() ?? '';

        final descripcion =
            album['descripcion']?.toString().trim() ?? '';

        final genero =
            album['genero']?.toString().trim() ?? '';

        final anio = album['anio'];

        final dynamic canciones =
            album['canciones'];

        if (canciones is! List) continue;

        for (final cancion in canciones) {
          if (cancion is! Map) continue;

          final titulo =
              cancion['titulo']?.toString().trim() ?? '';

          final audio =
              cancion['audio']?.toString().trim() ?? '';

          final idCancion =
              cancion['id']?.toString().trim() ?? '';

          if (titulo.isEmpty || audio.isEmpty) {
            continue;
          }

          resultado.add({
            'id': idCancion,
            'titulo': titulo,
            'artista': artista,
            'audio': audio,
            'imagen': imagen,
            'album': tituloAlbum,
            'albumId': idAlbum,
            'descripcionAlbum': descripcion,
            'genero': genero,
            'anio': anio,
            'duracion': cancion['duracion'],
            'numero': cancion['numero'],
            'tipo': 'album',
          });
        }
      }
    }

    // ===========================
    // SENCILLOS
    // ===========================

    final dynamic sencillos = datos['sencillos'];

    if (sencillos is List) {
      for (final sencillo in sencillos) {
        if (sencillo is! Map) continue;

        final titulo =
            sencillo['titulo']?.toString().trim() ?? '';

        final artista =
            sencillo['artista']?.toString().trim() ?? '';

        final audio =
            sencillo['audio']?.toString().trim() ?? '';

        final imagen =
            sencillo['imagen']?.toString().trim() ?? '';

        final id =
            sencillo['id']?.toString().trim() ?? '';

        if (titulo.isEmpty ||
            artista.isEmpty ||
            audio.isEmpty) {
          continue;
        }

        resultado.add({
          'id': id,
          'titulo': titulo,
          'artista': artista,
          'audio': audio,
          'imagen': imagen,
          'album': null,
          'albumId': null,
          'descripcionAlbum': null,
          'genero': sencillo['genero'],
          'anio': sencillo['anio'],
          'duracion': sencillo['duracion'],
          'numero': null,
          'tipo': 'sencillo',
        });
      }
    }

    return resultado;
  }
}

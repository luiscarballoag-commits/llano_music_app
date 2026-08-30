import '../cancion.dart';
import '../data/all_songs.dart';
import '../services/catalogo_remoto_service.dart';

class CatalogoMusicRepository {
  CatalogoMusicRepository._();

  static final CatalogoMusicRepository instance =
      CatalogoMusicRepository._();

  final List<Cancion> _canciones = List<Cancion>.from(allSongs);

  List<Cancion> get canciones => List.unmodifiable(_canciones);

  Future<void> cargarCatalogoRemoto() async {
    try {
      final remotas =
          await CatalogoRemotoService.instance.cargarCatalogo();

      final existentes = <String>{
        for (final cancion in _canciones)
          '${cancion.artista.toLowerCase()}|${cancion.titulo.toLowerCase()}',
      };

      for (final item in remotas) {
        final titulo = item['titulo']?.toString().trim();
        final artista = item['artista']?.toString().trim();
        final audio = item['audio']?.toString().trim();

        if (titulo == null ||
            titulo.isEmpty ||
            artista == null ||
            artista.isEmpty ||
            audio == null ||
            audio.isEmpty) {
          continue;
        }

        final clave =
            '${artista.toLowerCase()}|${titulo.toLowerCase()}';

        if (existentes.contains(clave)) {
          continue;
        }

        _canciones.add(
          Cancion(
            artista: artista,
            titulo: titulo,
            imagen: _buscarImagenArtista(artista),
            audio: audio,
          ),
        );

        existentes.add(clave);
      }
    } catch (_) {
      // Si falla Internet, se conserva el catálogo local.
    }
  }

  String _buscarImagenArtista(String artista) {
    for (final cancion in allSongs) {
      if (cancion.artista.toLowerCase() == artista.toLowerCase()) {
        return cancion.imagen;
      }
    }

    return 'assets/images/logo/logo_llano_music.png';
  }
}

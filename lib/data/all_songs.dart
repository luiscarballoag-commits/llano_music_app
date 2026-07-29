import '../cancion.dart';
import 'clasicos_llano.dart';
import '../lista_canciones.dart';

final List<Cancion> allSongs = [
  for (final artista in clasicosLlano)
    for (final cancion in artista.canciones)
      Cancion(
        artista: artista.artista,
        titulo: cancion.titulo,
        imagen: artista.imagen,
        audio: cancion.audio,
      ),
  ...listaCanciones,
];

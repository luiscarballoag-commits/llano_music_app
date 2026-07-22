import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../cancion.dart';

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._() {
    player.onPositionChanged.listen((p) {
      posicion = p;
      notifyListeners();
    });

    player.onDurationChanged.listen((d) {
      duracion = d;
      notifyListeners();
    });

    player.onPlayerComplete.listen((_) async {
      await siguiente();
    });
  }

  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer player = AudioPlayer();

  bool reproduciendo = false;

  String titulo = "";
  String artista = "";
  String imagen = "";
  String audioActual = "";

  Duration posicion = Duration.zero;
  Duration duracion = Duration.zero;

  List<Cancion> cola = [];

  int indiceActual = 0;

  void cargarCola(List<Cancion> canciones, int indice) {
    cola = canciones;
    indiceActual = indice;
  }

  Future<void> play({
    required String audio,
    required String tituloCancion,
    required String artistaCancion,
    required String imagenCancion,
  }) async {
    titulo = tituloCancion;
    artista = artistaCancion;
    imagen = imagenCancion;
    audioActual = audio;

    final ruta = audio.replaceFirst("assets/", "");

    await player.stop();

    try {
      await player.play(
        AssetSource(ruta),
      );

      reproduciendo = true;
      notifyListeners();
    } catch (e) {
      reproduciendo = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future<void> siguiente() async {
    if (cola.isEmpty) return;
    if (indiceActual >= cola.length - 1) return;

    indiceActual++;

    final cancion = cola[indiceActual];

    await play(
      audio: cancion.audio,
      tituloCancion: cancion.titulo,
      artistaCancion: cancion.artista,
      imagenCancion: cancion.imagen,
    );
  }

  Future<void> anterior() async {
    if (cola.isEmpty) return;
    if (indiceActual <= 0) return;

    indiceActual--;

    final cancion = cola[indiceActual];

    await play(
      audio: cancion.audio,
      tituloCancion: cancion.titulo,
      artistaCancion: cancion.artista,
      imagenCancion: cancion.imagen,
    );
  }

  Future<void> seek(Duration posicionNueva) async {
    await player.seek(posicionNueva);
  }

  Future<void> pause() async {
    await player.pause();
    reproduciendo = false;
    notifyListeners();
  }

  Future<void> resume() async {
    await player.resume();
    reproduciendo = true;
    notifyListeners();
  }

  Future<void> stop() async {
    await player.stop();
    reproduciendo = false;
    notifyListeners();
  }
}

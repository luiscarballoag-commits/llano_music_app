	import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._();

  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer player = AudioPlayer();

  bool reproduciendo = false;

  String titulo = "";
  String artista = "";
  String imagen = "";
  String audioActual = "";

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

    print("==================================");
    print("LLANO MUSIC");
    print("Título: $tituloCancion");
    print("Artista: $artistaCancion");
    print("Asset: $ruta");
    print("==================================");

    await player.stop();

    try {
      await player.play(
        AssetSource(ruta),
      );

      reproduciendo = true;
      notifyListeners();

      print("Reproducción iniciada.");
    } catch (e) {
      reproduciendo = false;
      notifyListeners();

      print("ERROR AL REPRODUCIR");
      print(e);
    }
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

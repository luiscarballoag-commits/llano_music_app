import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  AudioPlayerService._();

  static final AudioPlayer player = AudioPlayer();

  static bool reproduciendo = false;

  static String titulo = "";
  static String artista = "";
  static String imagen = "";
  static String audioActual = "";

  static Future<void> play({
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

      print("Reproducción iniciada.");
    } catch (e) {
      reproduciendo = false;

      print("ERROR AL REPRODUCIR");
      print(e);
    }
  }

  static Future<void> pause() async {
    await player.pause();
    reproduciendo = false;
  }

  static Future<void> resume() async {
    await player.resume();
    reproduciendo = true;
  }

  static Future<void> stop() async {
    await player.stop();
    reproduciendo = false;
  }
}

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

    await player.stop();

    await player.play(
      AssetSource(audio.replaceFirst("assets/", "")),
    );

    reproduciendo = true;
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


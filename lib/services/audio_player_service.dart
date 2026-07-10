import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  AudioPlayerService._();

  static final AudioPlayer player = AudioPlayer();

  static String titulo = "";
  static String artista = "";
  static String imagen = "";

  static bool reproduciendo = false;

  static Future<void> playSong({
    required String audio,
    required String songTitle,
    required String songArtist,
    required String songImage,
  }) async {
    try {
      titulo = songTitle;
      artista = songArtist;
      imagen = songImage;

      print("==========================================");
      print("LLANO MUSIC");
      print("Intentando reproducir:");
      print(audio);
      print("==========================================");

      await player.stop();

      final fuente = AssetSource(
        audio.replaceFirst("assets/audio/", ""),
      );

      print("AssetSource:");
      print(audio.replaceFirst("assets/audio/", ""));

      await player.play(fuente);

      reproduciendo = true;

      print("✅ Reproducción iniciada correctamente");
    } catch (e, s) {
      reproduciendo = false;

      print("❌ ERROR EN AUDIOPLAYER");
      print(e);
      print(s);
    }
  }

  static Future<void> pause() async {
    await player.pause();
    reproduciendo = false;
    print("⏸ Audio en pausa");
  }

  static Future<void> resume() async {
    await player.resume();
    reproduciendo = true;
    print("▶ Audio reanudado");
  }

  static Future<void> stop() async {
    await player.stop();
    reproduciendo = false;
    print("⏹ Audio detenido");
  }
}

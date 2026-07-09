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
    titulo = songTitle;
    artista = songArtist;
    imagen = songImage;

    await player.stop();

    await player.play(
      AssetSource(
        audio.replaceFirst("assets/audio/", ""),
      ),
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

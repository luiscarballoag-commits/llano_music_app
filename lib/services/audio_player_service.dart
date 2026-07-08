import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._();

  static final AudioPlayer player = AudioPlayer();

  static String titulo = "";
  static String artista = "";
  static String imagen = "";

  static Future<void> playSong({
    required String audio,
    required String songTitle,
    required String songArtist,
    required String songImage,
  }) async {
    titulo = songTitle;
    artista = songArtist;
    imagen = songImage;

    await player.setAsset(audio);
    await player.play();
  }

  static Future<void> pause() async {
    await player.pause();
  }

  static Future<void> resume() async {
    await player.play();
  }

  static Future<void> stop() async {
    await player.stop();
  }

  static bool get isPlaying => player.playing;
}

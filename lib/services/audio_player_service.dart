class AudioPlayerService {
  static String? currentSongId;
  static bool isPlaying = false;

  static void play(String songId) {
    currentSongId = songId;
    isPlaying = true;
  }

  static void pause() {
    isPlaying = false;
  }

  static void stop() {
    currentSongId = null;
    isPlaying = false;
  }

  static void toggle() {
    isPlaying = !isPlaying;
  }
}

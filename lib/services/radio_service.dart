import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class RadioService extends ChangeNotifier {
  RadioService._() {
    player.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          reproduciendo = true;
          break;

        case PlayerState.stopped:
        case PlayerState.paused:
        case PlayerState.completed:
          reproduciendo = false;
          break;

        case PlayerState.disposed:
          reproduciendo = false;
          break;
      }

      notifyListeners();
    });
  }

  static final RadioService instance = RadioService._();

  final AudioPlayer player = AudioPlayer();

  bool reproduciendo = false;
  String nombre = "";
  String? ultimoError;

  Future<void> reproducir({
    required String url,
    required String nombre,
  }) async {
    try {
      ultimoError = null;
      this.nombre = nombre;

      await player.stop();

      await player.play(
        UrlSource(
          url,
        ),
        mode: PlayerMode.mediaPlayer,
      );

      reproduciendo = true;
      notifyListeners();
    } catch (e) {
      reproduciendo = false;
      ultimoError = e.toString();

      debugPrint('ERROR RADIO DINAMITA: $e');

      notifyListeners();
    }
  }

  Future<void> detener() async {
    try {
      await player.stop();
    } catch (e) {
      debugPrint('Error deteniendo radio: $e');
    }

    reproduciendo = false;
    notifyListeners();
  }
}

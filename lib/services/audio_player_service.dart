import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../cancion.dart';
import 'analytics_service.dart';
import 'llano_audio_handler.dart';

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._() {
    player.onPositionChanged.listen((p) {
      posicion = p;
      audioHandler?.actualizarEstado(
        reproduciendo: reproduciendo,
        posicion: posicion,
        duracion: duracion,
      );
      notifyListeners();
    });

    player.onDurationChanged.listen((d) {
      duracion = d;
      audioHandler?.actualizarEstado(
        reproduciendo: reproduciendo,
        posicion: posicion,
        duracion: duracion,
      );
      notifyListeners();
    });

    player.onPlayerStateChanged.listen((state) {
      reproduciendo = state == PlayerState.playing;
      audioHandler?.actualizarEstado(
        reproduciendo: reproduciendo,
        posicion: posicion,
        duracion: duracion,
      );
      notifyListeners();
    });

    player.onPlayerComplete.listen((_) async {
      if (cola.isEmpty ||
          indiceActual < 0 ||
          indiceActual >= cola.length) {
        audioHandler?.marcarCompletado();
        return;
      }

      if (repeatMode == 1) {
        await _reproducirIndice(indiceActual);
        return;
      }

      if (indiceActual + 1 < cola.length) {
        await siguiente();
        return;
      }

      if (repeatMode == 2) {
        await _reproducirIndice(0);
        return;
      }

      audioHandler?.marcarCompletado();
    });
  }

  static final AudioPlayerService instance = AudioPlayerService._();

  LlanoAudioHandler? audioHandler;

  final AudioPlayer player = AudioPlayer();
  final Random _random = Random();

  bool reproduciendo = false;

  bool shuffle = false;

  // 0 = sin repetir
  // 1 = repetir canción
  // 2 = repetir toda la lista
  int repeatMode = 0;

  String titulo = "";
  String artista = "";
  String imagen = "";
  String audioActual = "";

  Duration posicion = Duration.zero;
  Duration duracion = Duration.zero;

  List<Cancion> cola = [];
  List<Cancion> _colaOriginal = [];

  int indiceActual = 0;

  void cargarCola(List<Cancion> canciones, int indice) {
    _colaOriginal = List<Cancion>.from(canciones);
    cola = List<Cancion>.from(_colaOriginal);
    if (cola.isEmpty) {
      indiceActual = 0;
      return;
    }
    indiceActual = indice.clamp(0, cola.length - 1);
    if (shuffle && cola.length > 1) {
      final actual = cola[indiceActual];
      cola.shuffle(_random);
      indiceActual = cola.indexWhere((c) => identical(c, actual));
    }
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
    final source = audio.startsWith("http://") || audio.startsWith("https://")
        ? UrlSource(audio)
        : AssetSource(ruta);

    await player.stop();

    try {
      await player.play(
        source,
      );

      await audioHandler?.customAction(
        'cargarCancion',
        {
          'audio': audio,
          'titulo': tituloCancion,
          'artista': artistaCancion,
          'imagen': imagenCancion,
        },
      );

      await AnalyticsService.logSongPlay(
        songTitle: tituloCancion,
        artist: artistaCancion,
      );

      reproduciendo = true;
      notifyListeners();
    } catch (e) {
      reproduciendo = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future<void> _reproducirIndice(int indice) async {
    if (cola.isEmpty || indice < 0 || indice >= cola.length) return;

    indiceActual = indice;
    final cancion = cola[indiceActual];

    await play(
      audio: cancion.audio,
      tituloCancion: cancion.titulo,
      artistaCancion: cancion.artista,
      imagenCancion: cancion.imagen,
    );
  }

  Future<void> siguiente() async {
    if (cola.isEmpty) return;

    if (indiceActual + 1 < cola.length) {
      await _reproducirIndice(indiceActual + 1);
    } else if (repeatMode == 2) {
      await _reproducirIndice(0);
    }
  }

  Future<void> anterior() async {
    if (cola.isEmpty) return;

    if (indiceActual > 0) {
      await _reproducirIndice(indiceActual - 1);
    } else if (repeatMode == 2) {
      await _reproducirIndice(cola.length - 1);
    }
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

  void toggleShuffle() {
    if (cola.isEmpty) {
      shuffle = (shuffle == false);
      notifyListeners();
      return;
    }

    final actual = cola[indiceActual];

    if (shuffle == false) {
      shuffle = true;
      cola = List<Cancion>.from(_colaOriginal);
      cola.shuffle(_random);
    } else {
      shuffle = false;
      cola = List<Cancion>.from(_colaOriginal);
    }

    final indice = cola.indexWhere((c) => identical(c, actual));
    if (indice >= 0) indiceActual = indice;
    notifyListeners();
  }

  void toggleRepeat() {
    repeatMode++;
    if (repeatMode > 2) {
      repeatMode = 0;
    }
    notifyListeners();
  }

}

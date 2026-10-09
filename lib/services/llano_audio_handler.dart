import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LlanoAudioHandler extends BaseAudioHandler with SeekHandler {
  LlanoAudioHandler();

  Future<void> Function()? onPlay;
  Future<void> Function()? onPause;
  Future<void> Function(Duration position)? onSeek;
  Future<void> Function()? onStop;
  Future<void> Function()? onPrevious;
  Future<void> Function()? onNext;

  static const String _portadaPredeterminada =
      'assets/images/logo/logo_llano_music.png';

  Future<Uri?> _obtenerPortadaUri(String imagen) async {
    final ruta = imagen.trim();
    if (ruta.isEmpty) return null;

    final uri = Uri.tryParse(ruta);

    // Las portadas remotas conservan su URL.
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return uri;
    }

    // Solo procesamos rutas de assets de la aplicación.
    if (!ruta.startsWith('assets/')) return null;

    try {
      final directorio = await getTemporaryDirectory();
      final nombreSeguro = ruta.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final archivo = File('${directorio.path}/portada_$nombreSeguro');

      if (!await archivo.exists() || await archivo.length() == 0) {
        final datos = await rootBundle.load(ruta);
        await archivo.writeAsBytes(
          datos.buffer.asUint8List(datos.offsetInBytes, datos.lengthInBytes),
          flush: true,
        );
      }

      return archivo.uri;
    } catch (_) {
      // Si falla la portada elegida, intentamos usar el logo.
      if (ruta == _portadaPredeterminada) return null;
      return _obtenerPortadaUri(_portadaPredeterminada);
    }
  }

  Future<void> actualizarCancion({
    required String audio,
    required String titulo,
    required String artista,
    required String imagen,
  }) async {
    final artUri = await _obtenerPortadaUri(imagen);

    mediaItem.add(
      MediaItem(id: audio, title: titulo, artist: artista, artUri: artUri),
    );
  }

  void actualizarEstado({
    required bool reproduciendo,
    required Duration posicion,
    required Duration duracion,
  }) {
    final item = mediaItem.value;

    if (item != null && item.duration != duracion) {
      mediaItem.add(item.copyWith(duration: duracion));
    }

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (reproduciendo) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        playing: reproduciendo,
        processingState: AudioProcessingState.ready,
        updatePosition: posicion,
      ),
    );
  }

  void marcarCompletado() {
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.completed,
      ),
    );
  }

  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    if (name == 'cargarCancion') {
      await actualizarCancion(
        audio: extras?['audio'] as String? ?? '',
        titulo: extras?['titulo'] as String? ?? '',
        artista: extras?['artista'] as String? ?? '',
        imagen: extras?['imagen'] as String? ?? '',
      );
      return;
    }

    return super.customAction(name, extras);
  }

  @override
  Future<void> play() async {
    await onPlay?.call();
  }

  @override
  Future<void> pause() async {
    await onPause?.call();
  }

  @override
  Future<void> seek(Duration position) async {
    await onSeek?.call(position);
  }

  @override
  Future<void> skipToPrevious() async {
    await onPrevious?.call();
  }

  @override
  Future<void> skipToNext() async {
    await onNext?.call();
  }

  @override
  Future<void> stop() async {
    await onStop?.call();
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
        updatePosition: Duration.zero,
      ),
    );
  }
}

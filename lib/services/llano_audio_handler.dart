import 'package:audio_service/audio_service.dart';

class LlanoAudioHandler extends BaseAudioHandler with SeekHandler {
  LlanoAudioHandler();

  Future<void> Function()? onPlay;
  Future<void> Function()? onPause;
  Future<void> Function(Duration position)? onSeek;
  Future<void> Function()? onStop;

  void actualizarCancion({
    required String audio,
    required String titulo,
    required String artista,
    required String imagen,
  }) {
    mediaItem.add(
      MediaItem(
        id: audio,
        title: titulo,
        artist: artista,
        artUri: imagen.isNotEmpty ? Uri.tryParse(imagen) : null,
      ),
    );
  }

  void actualizarEstado({
    required bool reproduciendo,
    required Duration posicion,
    required Duration duracion,
  }) {
    final item = mediaItem.value;

    if (item != null && item.duration != duracion) {
      mediaItem.add(
        item.copyWith(duration: duracion),
      );
    }

    playbackState.add(
      playbackState.value.copyWith(
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
      actualizarCancion(
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

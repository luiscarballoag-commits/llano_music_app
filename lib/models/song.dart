class Song {
  final String id;
  final String titulo;
  final String artistaId;
  final String audio;
  final Duration duracion;

  const Song({
    required this.id,
    required this.titulo,
    required this.artistaId,
    required this.audio,
    required this.duracion,
  });
}

class Album {
  final String id;
  final String titulo;
  final String artistaId;
  final String portada;
  final List<String> canciones;

  const Album({
    required this.id,
    required this.titulo,
    required this.artistaId,
    required this.portada,
    required this.canciones,
  });
}

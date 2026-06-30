class Artist {
  final String id;
  final String nombre;
  final String imagen;

  final String descripcion;
  final String genero;
  final String estado;
  final String pais;

  final bool destacado;
  final bool verificado;

  const Artist({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.genero,
    required this.estado,
    required this.pais,
    required this.destacado,
    required this.verificado,
  });
}

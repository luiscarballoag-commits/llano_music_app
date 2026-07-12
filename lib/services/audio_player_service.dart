
static Future<void> play({
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

  print("=== LLANO MUSIC ===");
  print("Ruta original: $audio");
  print("Ruta asset: $ruta");

  try {
    await player.stop();

    final resultado = await player.play(
      AssetSource(ruta),
    );

    print("Resultado: $resultado");

    reproduciendo = true;
  } catch (e, s) {
    reproduciendo = false;

    print("ERROR: $e");
    print(s);
  }
}

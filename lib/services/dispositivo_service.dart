import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DispositivoService {
  DispositivoService._();

  static const String _claveDispositivo = 'llanomusic_dispositivo_id';

  static Future<String> obtenerId() async {
    final preferencias = await SharedPreferences.getInstance();

    final guardado = preferencias.getString(_claveDispositivo);

    if (guardado != null && guardado.isNotEmpty) {
      return guardado;
    }

    final aleatorio = Random.secure();
    final bytes = List<int>.generate(
      32,
      (_) => aleatorio.nextInt(256),
    );

    final identificador = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();

    await preferencias.setString(
      _claveDispositivo,
      identificador,
    );

    return identificador;
  }
}

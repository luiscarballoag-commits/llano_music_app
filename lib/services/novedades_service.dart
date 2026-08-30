import 'package:hive_flutter/hive_flutter.dart';

class NovedadesService {
  NovedadesService._();

  static final NovedadesService instance = NovedadesService._();

  static const String _boxName = 'novedades';

  late Box _box;

  Future<void> inicializar() async {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
    } else {
      _box = await Hive.openBox(_boxName);
    }
  }

  List<Map<String, dynamic>> get novedades {
    final resultado = <Map<String, dynamic>>[];

    for (final valor in _box.values) {
      if (valor is Map) {
        resultado.add(
          Map<String, dynamic>.from(valor),
        );
      }
    }

    resultado.sort((a, b) {
      final fechaA = a['fecha']?.toString() ?? '';
      final fechaB = b['fecha']?.toString() ?? '';

      return fechaB.compareTo(fechaA);
    });

    return resultado;
  }

  int get cantidadNoLeidas {
    return _box.values.where((valor) {
      if (valor is! Map) return false;

      return valor['vista'] != true;
    }).length;
  }

  Future<void> agregar({
    required String id,
    required String tipo,
    required String titulo,
    required String artista,
    String? album,
  }) async {
    if (_box.containsKey(id)) {
      return;
    }

    await _box.put(id, {
      'id': id,
      'tipo': tipo,
      'titulo': titulo,
      'artista': artista,
      'album': album,
      'fecha': DateTime.now().toIso8601String(),
      'vista': false,
    });
  }

  Future<void> marcarTodasComoVistas() async {
    final claves = _box.keys.toList();

    for (final clave in claves) {
      final valor = _box.get(clave);

      if (valor is Map) {
        final actualizado = Map<String, dynamic>.from(valor);

        actualizado['vista'] = true;

        await _box.put(clave, actualizado);
      }
    }
  }

  Future<void> limpiar() async {
    await _box.clear();
  }
}


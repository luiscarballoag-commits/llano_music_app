import 'package:hive_flutter/hive_flutter.dart';

class NotificacionService {
  NotificacionService._();

  static final NotificacionService instance =
      NotificacionService._();

  static const String _boxName = 'notificaciones';

  Future<void> inicializar() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Box get _box => Hive.box(_boxName);

  List<Map<String, dynamic>> get notificaciones {
    return _box.values
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList()
        .reversed
        .toList();
  }

  int get noLeidas {
    return notificaciones.where(
      (item) => item['leida'] != true,
    ).length;
  }

  Future<void> agregar({
    required String tipo,
    required String titulo,
    required String mensaje,
    required String id,
  }) async {
    final existe = _box.values.whereType<Map>().any(
      (item) => item['id'] == id,
    );

    if (existe) return;

    await _box.add({
      'id': id,
      'tipo': tipo,
      'titulo': titulo,
      'mensaje': mensaje,
      'fecha': DateTime.now().toIso8601String(),
      'leida': false,
    });
  }

  Future<void> marcarTodasComoLeidas() async {
    for (final key in _box.keys) {
      final valor = _box.get(key);

      if (valor is Map && valor['leida'] != true) {
        final actualizado = Map<String, dynamic>.from(valor);
        actualizado['leida'] = true;
        await _box.put(key, actualizado);
      }
    }
  }
}


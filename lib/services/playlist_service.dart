import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlaylistService extends ChangeNotifier {
  PlaylistService._();

  static final PlaylistService instance = PlaylistService._();

  static const String _boxName = 'playlists';

  Future<void> inicializar() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Box get _box => Hive.box(_boxName);

  List<Map<String, dynamic>> obtenerPlaylists() {
    return _box.values.map((valor) {
      final mapa = Map<String, dynamic>.from(valor as Map);
      return mapa;
    }).toList();
  }

  Map<String, dynamic>? obtenerPlaylist(String id) {
    final datos = _box.get(id);

    if (datos == null) {
      return null;
    }

    return Map<String, dynamic>.from(datos as Map);
  }

  Future<void> crearPlaylist({
    required String id,
    required String nombre,
    String imagen = '',
  }) async {
    await _box.put(id, {
      'id': id,
      'nombre': nombre,
      'imagen': imagen,
      'canciones': <String>[],
    });

    notifyListeners();
  }

  Future<void> eliminarPlaylist(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> agregarCancion(
    String playlistId,
    String audio,
  ) async {
    final playlist = obtenerPlaylist(playlistId);

    if (playlist == null) return;

    final canciones =
        List<String>.from(playlist['canciones'] ?? []);

    if (!canciones.contains(audio)) {
      canciones.add(audio);
    }

    playlist['canciones'] = canciones;

    await _box.put(playlistId, playlist);

    notifyListeners();
  }

  Future<void> quitarCancion(
    String playlistId,
    String audio,
  ) async {
    final playlist = obtenerPlaylist(playlistId);

    if (playlist == null) return;

    final canciones =
        List<String>.from(playlist['canciones'] ?? []);

    canciones.remove(audio);

    playlist['canciones'] = canciones;

    await _box.put(playlistId, playlist);

    notifyListeners();
  }

  bool contieneCancion(
    String playlistId,
    String audio,
  ) {
    final playlist = obtenerPlaylist(playlistId);

    if (playlist == null) return false;

    final canciones =
        List<String>.from(playlist['canciones'] ?? []);

    return canciones.contains(audio);
  }
}

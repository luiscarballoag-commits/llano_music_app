import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._();

  static final FavoritesService instance = FavoritesService._();

  final Box box = Hive.box('favorites');

  bool esFavorito(String audio) {
    return box.containsKey(audio);
  }

  void toggleFavorito(String audio) {
    if (box.containsKey(audio)) {
      box.delete(audio);
    } else {
      box.put(audio, true);
    }
    notifyListeners();
  }

  List<String> obtenerFavoritos() {
    return box.keys.cast<String>().toList();
  }
}

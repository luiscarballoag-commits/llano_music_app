import '../models/artist.dart';
import '../repositories/music_repository.dart';

class HomeViewModel {
  final MusicRepository _repository = const MusicRepository();

  /// Lista de todos los artistas
  List<Artist> get artists {
    return _repository.getArtists();
  }

  /// Artistas destacados
  List<Artist> get featuredArtists {
    return artists.where((artist) => artist.destacado).toList();
  }
}

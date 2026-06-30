import '../models/artist.dart';
import '../models/song.dart';
import '../services/music_service.dart';

class MusicRepository {
  const MusicRepository();

  /// Obtiene todos los artistas
  List<Artist> getArtists() {
    return MusicService.getArtists();
  }

  /// Obtiene todas las canciones
  List<Song> getSongs() {
    return MusicService.getSongs();
  }

  /// Busca un artista por su ID
  Artist? getArtistById(String id) {
    return MusicService.getArtistById(id);
  }

  /// Obtiene las canciones de un artista
  List<Song> getSongsByArtist(String artistId) {
    return MusicService.getSongsByArtist(artistId);
  }

  /// Busca una canción por su ID
  Song? getSongById(String id) {
    return MusicService.getSongById(id);
  }
}

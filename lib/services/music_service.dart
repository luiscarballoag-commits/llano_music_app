import '../data/artists.dart';
import '../data/songs.dart';

import '../models/artist.dart';
import '../models/song.dart';

class MusicService {
  /// Devuelve todos los artistas
  static List<Artist> getArtists() {
    return artists;
  }

  /// Devuelve todas las canciones
  static List<Song> getSongs() {
    return songs;
  }

  /// Busca un artista por su ID
  static Artist? getArtistById(String id) {
    try {
      return artists.firstWhere((artist) => artist.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Devuelve todas las canciones de un artista
  static List<Song> getSongsByArtist(String artistId) {
    return songs.where((song) => song.artistaId == artistId).toList();
  }

  /// Busca una canción por ID
  static Song? getSongById(String id) {
    try {
      return songs.firstWhere((song) => song.id == id);
    } catch (_) {
      return null;
    }
  }
}

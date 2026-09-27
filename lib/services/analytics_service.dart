import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics instance = FirebaseAnalytics.instance;

  static Future<void> logAppOpen() async {
    await instance.logAppOpen();
  }
  static Future<void> logAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    await instance.logEvent(
      name: 'app_version',
      parameters: {
        'version': info.version,
        'build_number': info.buildNumber,
      },
    );
  }


  static Future<void> logSongPlay({
    required String songTitle,
    required String artist,
  }) async {
    await instance.logEvent(
      name: 'song_play',
      parameters: {
        'song_title': songTitle,
        'artist': artist,
      },
    );
  }

  static Future<void> logArtistView({
    required String artist,
  }) async {
    await instance.logEvent(
      name: 'artist_view',
      parameters: {
        'artist': artist,
      },
    );
  }

  static Future<void> logFavoriteChange({
    required String songTitle,
    required String artist,
    required bool added,
  }) async {
    await instance.logEvent(
      name: added ? 'favorite_add' : 'favorite_remove',
      parameters: {
        'song_title': songTitle,
        'artist': artist,
      },
    );
  }


  static Future<void> logPlaylistCreate({
    required String playlistId,
    required String playlistName,
  }) async {
    await instance.logEvent(
      name: 'playlist_create',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  static Future<void> logPlaylistDelete({
    required String playlistId,
    required String playlistName,
  }) async {
    await instance.logEvent(
      name: 'playlist_delete',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  static Future<void> logPlaylistAddSong({
    required String playlistId,
    required String playlistName,
    required String audio,
  }) async {
    await instance.logEvent(
      name: 'playlist_add_song',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
        'audio': audio,
      },
    );
  }

  static Future<void> logPlaylistRemoveSong({
    required String playlistId,
    required String playlistName,
    required String audio,
  }) async {
    await instance.logEvent(
      name: 'playlist_remove_song',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
        'audio': audio,
      },
    );
  }

  static Future<void> logSearch({
    required String searchTerm,
    required String searchType,
  }) async {
    await instance.logEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        'search_type': searchType,
      },
    );
  }
}

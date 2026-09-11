import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chrome_cast/cast_context.dart';
import 'package:flutter_chrome_cast/entities.dart';
import 'package:flutter_chrome_cast/models/android/android_cast_options.dart';

import 'home_page.dart';
import 'theme/app_theme.dart';
import 'services/playlist_service.dart';
import 'services/novedades_service.dart';
import 'repositories/catalogo_music_repository.dart';

Future<void> _inicializarGoogleCast() async {
  const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;

  if (Platform.isAndroid) {
    final options = GoogleCastOptionsAndroid(
      appId: appId,
      stopCastingOnAppTerminated: false,
    );

    GoogleCastContext.instance.setSharedInstanceWithOptions(options);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('favorites');

  await PlaylistService.instance.inicializar();

  await NovedadesService.instance.inicializar();

  await CatalogoMusicRepository.instance.cargarCatalogoRemoto();

  await _inicializarGoogleCast();

  runApp(const LlanoMusicApp());
}

class LlanoMusicApp extends StatelessWidget {
  const LlanoMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Llano Music',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chrome_cast/cast_context.dart';
import 'package:flutter_chrome_cast/entities.dart';
import 'package:flutter_chrome_cast/models/android/android_cast_options.dart';

import 'home_page.dart';
import 'theme/app_theme.dart';
import 'services/playlist_service.dart';
import 'services/novedades_service.dart';
import 'repositories/catalogo_music_repository.dart';
import 'services/analytics_service.dart';
import 'services/licencia_service.dart';
import 'services/llano_audio_handler.dart';
import 'services/audio_player_service.dart';

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

  final audioHandler = await AudioService.init<LlanoAudioHandler>(
    builder: () => LlanoAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.llanomusic.audio',
      androidNotificationChannelName: 'Llano Music',
      androidNotificationOngoing: true,
    ),
  );

  AudioPlayerService.instance.audioHandler = audioHandler;
  audioHandler.onPlay = AudioPlayerService.instance.resume;
  audioHandler.onPause = AudioPlayerService.instance.pause;
  audioHandler.onSeek = AudioPlayerService.instance.seek;
  audioHandler.onStop = AudioPlayerService.instance.stop;
  audioHandler.onPrevious = AudioPlayerService.instance.anterior;
  audioHandler.onNext = AudioPlayerService.instance.siguiente;

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await AnalyticsService.instance.logAppOpen();
  await AnalyticsService.logAppVersion();

  await Hive.initFlutter();

  await Hive.openBox('favorites');

  await PlaylistService.instance.inicializar();

  await NovedadesService.instance.inicializar();

  // Solo cargar canciones remotas con Premium validado.
  // Sin conexión, la aplicación conserva el catálogo local.
  var premiumActivo = false;
  try {
    final licencia = await LicenciaService.instance.verificarSesion();
    premiumActivo = licencia['ok'] == true && licencia['estado'] == 'activa';

    CatalogoMusicRepository.instance.establecerPremiumActivo(premiumActivo);

    if (premiumActivo) {
      await CatalogoMusicRepository.instance.cargarCatalogoRemoto();
    }
  } catch (_) {
    // Un fallo de verificación no debe impedir abrir la aplicación.
  }

  await _inicializarGoogleCast();

  runApp(LlanoMusicApp(mostrarAvisoPremium: premiumActivo));
}

class LlanoMusicApp extends StatelessWidget {
  final bool mostrarAvisoPremium;

  const LlanoMusicApp({super.key, required this.mostrarAvisoPremium});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Llano Music',
      theme: AppTheme.lightTheme,
      home: _AvisoBienvenidaPremium(
        mostrarAviso: mostrarAvisoPremium,
        child: const HomePage(),
      ),
    );
  }
}

class _AvisoBienvenidaPremium extends StatefulWidget {
  final bool mostrarAviso;
  final Widget child;

  const _AvisoBienvenidaPremium({
    required this.mostrarAviso,
    required this.child,
  });

  @override
  State<_AvisoBienvenidaPremium> createState() =>
      _AvisoBienvenidaPremiumState();
}

class _AvisoBienvenidaPremiumState extends State<_AvisoBienvenidaPremium> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.mostrarAviso) {
        _mostrarBienvenida();
      }
    });
  }

  Future<void> _mostrarBienvenida() async {
    const verdeOscuro = Color(0xFF173D2B);
    const verdeLlanoMusic = Color(0xFF2E7D32);
    const dorado = Color(0xFFDDB85A);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: verdeOscuro,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: dorado, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: verdeLlanoMusic.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                  border: Border.all(color: dorado, width: 1.5),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: dorado,
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Bienvenido a\nLlanoMusic Premium!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dorado,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Tu licencia Premium está activa. '
                'Disfruta de tu música llanera y de todo tu catálogo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verdeLlanoMusic,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: dorado, width: 1),
                    ),
                  ),
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

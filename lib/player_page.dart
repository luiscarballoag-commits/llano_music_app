import 'package:flutter/material.dart';

import 'services/audio_player_service.dart';
import 'services/favorites_service.dart';
import 'services/analytics_service.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  static const Color _verde = Color(0xFF167A3F);
  static const String _logo = 'assets/images/logo/logo_llano_music.png';

  String _format(Duration d) {
    final minutos = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final horas = d.inHours;

    if (horas > 0) {
      return '$horas:$minutos:$segundos';
    }

    return '$minutos:$segundos';
  }

  Widget _imagenRespaldo({double size = 280}) {
    return Container(
      width: size,
      height: size,
      color: Colors.white,
      alignment: Alignment.center,
      child: Image.asset(
        _logo,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.music_note_rounded, size: size * 0.45, color: _verde),
      ),
    );
  }

  Widget _imagenPlayer(String imagen, {double size = 280}) {
    final ruta = imagen.trim().isEmpty ? _logo : imagen.trim();
    final remota = ruta.startsWith('https://') || ruta.startsWith('http://');

    if (remota) {
      return Image.network(
        ruta,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagenRespaldo(size: size),
      );
    }

    return Image.asset(
      ruta,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagenRespaldo(size: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioPlayerService.instance,
      builder: (context, _) {
        final player = AudioPlayerService.instance;
        final favorito = FavoritesService.instance.esFavorito(
          player.audioActual,
        );
        final duracionMs = player.duracion.inMilliseconds;
        final posicionMs = player.posicion.inMilliseconds
            .clamp(0, duracionMs > 0 ? duracionMs : 0)
            .toDouble();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F5),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.40, 0.72, 1],
                colors: [
                  Color(0xFF104D2A),
                  Color(0xFF167A3F),
                  Color(0xFFF5F7F5),
                  Color(0xFFF5F7F5),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _botonSuperior(
                          icono: Icons.arrow_back_rounded,
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'REPRODUCTOR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        _botonSuperior(
                          icono: favorito
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: favorito
                              ? const Color(0xFFFF6B81)
                              : Colors.white,
                          onPressed: () {
                            final eraFavorito = FavoritesService.instance
                                .esFavorito(player.audioActual);

                            FavoritesService.instance.toggleFavorito(
                              player.audioActual,
                            );

                            AnalyticsService.logFavoriteChange(
                              songTitle: player.titulo,
                              artist: player.artista,
                              added: !eraFavorito,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final disponible = constraints.maxHeight;
                          final lado = (disponible * 0.39)
                              .clamp(150.0, 300.0)
                              .toDouble();

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: lado,
                                height: lado,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.20,
                                      ),
                                      blurRadius: 28,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: _imagenPlayer(
                                    player.imagen,
                                    size: lado - 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              Text(
                                player.titulo.isEmpty
                                    ? 'Seleccione una canción'
                                    : player.titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  height: 1.2,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF17251C),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                player.artista.isEmpty
                                    ? 'Llano Music'
                                    : player.artista,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF65736A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: _verde,
                                  inactiveTrackColor: const Color(0xFFD9E2DB),
                                  thumbColor: _verde,
                                  overlayColor: _verde.withValues(alpha: 0.12),
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 7,
                                  ),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: duracionMs > 0
                                      ? duracionMs.toDouble()
                                      : 1,
                                  value: duracionMs > 0 ? posicionMs : 0,
                                  onChanged: duracionMs > 0
                                      ? (value) async {
                                          await player.seek(
                                            Duration(
                                              milliseconds: value.toInt(),
                                            ),
                                          );
                                        }
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _format(player.posicion),
                                      style: const TextStyle(
                                        color: Color(0xFF65736A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      _format(player.duracion),
                                      style: const TextStyle(
                                        color: Color(0xFF65736A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _botonModo(
                                    icono: Icons.shuffle_rounded,
                                    activo: player.shuffle,
                                    etiqueta: 'ALEATORIO',
                                    onPressed: player.toggleShuffle,
                                  ),
                                  IconButton(
                                    tooltip: 'Canción anterior',
                                    onPressed: () async {
                                      await player.anterior();
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous_rounded,
                                      size: 42,
                                    ),
                                    color: const Color(0xFF24392B),
                                  ),
                                  Container(
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: _verde,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _verde.withValues(alpha: 0.30),
                                          blurRadius: 18,
                                          offset: const Offset(0, 7),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      tooltip: player.reproduciendo
                                          ? 'Pausar'
                                          : 'Reproducir',
                                      onPressed: () async {
                                        if (player.reproduciendo) {
                                          await player.pause();
                                        } else {
                                          await player.resume();
                                        }
                                      },
                                      icon: Icon(
                                        player.reproduciendo
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 48,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Canción siguiente',
                                    onPressed: () async {
                                      await player.siguiente();
                                    },
                                    icon: const Icon(
                                      Icons.skip_next_rounded,
                                      size: 42,
                                    ),
                                    color: const Color(0xFF24392B),
                                  ),
                                  _botonModo(
                                    icono: player.repeatMode == 1
                                        ? Icons.repeat_one_rounded
                                        : Icons.repeat_rounded,
                                    activo: player.repeatMode != 0,
                                    etiqueta: player.repeatMode == 1
                                        ? 'UNA'
                                        : player.repeatMode == 2
                                        ? 'TODO'
                                        : 'REPETIR',
                                    onPressed: player.toggleRepeat,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.graphic_eq_rounded,
                                    color: _verde,
                                    size: 18,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'SONIDO LLANERO',
                                    style: TextStyle(
                                      color: _verde,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _botonSuperior({
    required IconData icono,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icono, color: color, size: 25),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _botonModo({
    required IconData icono,
    required bool activo,
    required String etiqueta,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: etiqueta,
            onPressed: onPressed,
            icon: Icon(icono, size: 23),
            color: activo ? _verde : const Color(0xFF9AA69D),
            style: IconButton.styleFrom(
              backgroundColor: activo
                  ? _verde.withValues(alpha: 0.10)
                  : Colors.transparent,
            ),
          ),
          Text(
            etiqueta,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: activo ? _verde : const Color(0xFF89948C),
            ),
          ),
        ],
      ),
    );
  }
}

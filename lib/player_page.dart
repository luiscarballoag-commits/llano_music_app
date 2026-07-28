import 'package:flutter/material.dart';
import 'services/audio_player_service.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  String _format(Duration d) {
    final minutos =
        d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos =
        d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutos:$segundos";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioPlayerService.instance,
      builder: (context, _) {
        final player = AudioPlayerService.instance;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B5E20),
                  Color(0xFF2E7D32),
                  Color(0xFFF3F5F7),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    Row(
                      children: [

                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        const Expanded(
                          child: Text(
                            "Reproduciendo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          player.imagen.isEmpty
                              ? "assets/images/logo/logo_llano_music.png"
                              : player.imagen,
                          width: 320,
                          height: 320,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 320,
                              height: 320,
                              color: Colors.white,
                              child: const Icon(
                                Icons.music_note,
                                size: 120,
                                color: Colors.green,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      player.titulo.isEmpty
                          ? "Seleccione una canción"
                          : player.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      player.artista,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Slider(
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey.shade300,
                      min: 0,
                      max: player.duracion.inMilliseconds == 0
                          ? 1
                          : player.duracion.inMilliseconds
                              .toDouble(),
                      value: player.posicion.inMilliseconds
                          .clamp(
                            0,
                            player.duracion.inMilliseconds == 0
                                ? 1
                                : player.duracion.inMilliseconds,
                          )
                          .toDouble(),
                      onChanged: (value) async {
                        await player.seek(
                          Duration(
                            milliseconds: value.toInt(),
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_format(player.posicion)),
                          Text(_format(player.duracion)),
                        ],
                      ),
                    ),

                    const Spacer(),                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [

                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: player.shuffle
                                ? Colors.green
                                : Colors.grey,
                          ),
                          iconSize: 32,
                          onPressed: () {
                            player.toggleShuffle();
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          iconSize: 45,
                          onPressed: () async {
                            await player.anterior();
                          },
                        ),

                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 56,
                            color: Colors.white,
                            onPressed: () async {
                              if (player.reproduciendo) {
                                await player.pause();
                              } else {
                                await player.resume();
                              }
                            },
                            icon: Icon(
                              player.reproduciendo
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          iconSize: 45,
                          onPressed: () async {
                            await player.siguiente();
                          },
                        ),

                        IconButton(
                          icon: Icon(
                            player.repeatMode == 0
                                ? Icons.repeat
                                : player.repeatMode == 1
                                    ? Icons.repeat_one
                                    : Icons.repeat,
                            color: player.repeatMode == 0
                                ? Colors.grey
                                : Colors.green,
                          ),
                          iconSize: 32,
                          onPressed: () {
                            player.toggleRepeat();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
          );
      },
    );
  }
}

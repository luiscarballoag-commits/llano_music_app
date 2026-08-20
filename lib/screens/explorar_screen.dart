import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/clasicos_llano.dart';
import '../player_page.dart';
import 'playlists_screen.dart';
import '../services/audio_player_service.dart';

class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  final TextEditingController _buscarController =
      TextEditingController();

  List<ClasicoLlano> artistas = [];

  @override
  void initState() {
    super.initState();
    artistas = List.from(clasicosLlano);
  }

  void filtrar(String texto) {
    setState(() {
      if (texto.trim().isEmpty) {
        artistas = List.from(clasicosLlano);
      } else {
        artistas = clasicosLlano.where((artista) {
          return artista.artista
                  .toLowerCase()
                  .contains(texto.toLowerCase()) ||
              artista.apodo
                  .toLowerCase()
                  .contains(texto.toLowerCase()) ||
              artista.estado
                  .toLowerCase()
                  .contains(texto.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      appBar: AppBar(
        title: const Text(
          "Grandes Voces del Llano",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: TextField(
              controller: _buscarController,
              onChanged: filtrar,
              decoration: InputDecoration(
                hintText: "Buscar artista...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.queue_music),
                    label: const Text(
                      "Mis Playlists",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PlaylistsScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      "Reproducir todo",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final cola = <Cancion>[];

                      for (final artista in clasicosLlano) {
                        cola.addAll(
                          artista.canciones.map(
                            (c) => Cancion(
                              artista: artista.artista,
                              titulo: c.titulo,
                              imagen: artista.imagen,
                              audio: c.audio,
                            ),
                          ),
                        );
                      }

                      AudioPlayerService.instance
                          .cargarCola(cola, 0);

                      final primera = cola.first;

                      await AudioPlayerService.instance.play(
                        audio: primera.audio,
                        tituloCancion: primera.titulo,
                        artistaCancion: primera.artista,
                        imagenCancion: primera.imagen,
                      );

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PlayerPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              itemCount: artistas.length,
              itemBuilder: (context, index) {
                final artista = artistas[index];                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),

                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        artista.imagen,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              size: 35,
                            ),
                          );
                        },
                      ),
                    ),

                    title: Text(
                      artista.artista,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(artista.apodo),

                        const SizedBox(height: 4),

                        Text(
                          "${artista.estado}, ${artista.pais}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${artista.canciones.length} canciones",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    trailing: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.green,
                      size: 42,
                    ),

                    onTap: () async {
                      final cola = <Cancion>[];

                      final indiceOriginal =
                          clasicosLlano.indexOf(artista);

                      for (int i = indiceOriginal;
                          i < clasicosLlano.length;
                          i++) {
                        final a = clasicosLlano[i];

                        cola.addAll(
                          a.canciones.map(
                            (c) => Cancion(
                              artista: a.artista,
                              titulo: c.titulo,
                              imagen: a.imagen,
                              audio: c.audio,
                            ),
                          ),
                        );
                      }

                      AudioPlayerService.instance
                          .cargarCola(cola, 0);

                      final primera = cola.first;

                      await AudioPlayerService.instance.play(
                        audio: primera.audio,
                        tituloCancion: primera.titulo,
                        artistaCancion: primera.artista,
                        imagenCancion: primera.imagen,
                      );

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PlayerPage(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }
}

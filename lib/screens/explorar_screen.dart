import 'package:flutter/material.dart';

import '../cancion.dart';
import '../data/clasicos_llano.dart';
import '../player_page.dart';
import '../services/audio_player_service.dart';
import '../services/analytics_service.dart';
import '../repositories/catalogo_music_repository.dart';
import 'clasico_llano_screen.dart';
import 'playlists_screen.dart';

class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  final TextEditingController _buscarController = TextEditingController();

  List<ClasicoLlano> artistas = [];

  @override
  void initState() {
    super.initState();
    artistas = List.from(clasicosLlano);
  }

  Map<String, List<Cancion>> get artistasPremium {
    final grupos = <String, List<Cancion>>{};
    for (final cancion in CatalogoMusicRepository.instance.cancionesPremium) {
      final artista = cancion.artista.trim();
      if (artista.isEmpty) continue;
      final clave = artista.toLowerCase();
      grupos.putIfAbsent(clave, () => <Cancion>[]);
      if (!grupos[clave]!.any(
        (c) => c.titulo.toLowerCase() == cancion.titulo.toLowerCase(),
      )) {
        grupos[clave]!.add(cancion);
      }
    }
    for (final canciones in grupos.values) {
      canciones.sort(
        (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()),
      );
    }
    return grupos;
  }

  Widget imagenArtista(String ruta) {
    final esUrl = ruta.startsWith('http://') || ruta.startsWith('https://');
    final imagen = esUrl
        ? Image.network(ruta, width: 70, height: 70, fit: BoxFit.cover)
        : Image.asset(ruta, width: 70, height: 70, fit: BoxFit.cover);
    return ClipRRect(borderRadius: BorderRadius.circular(10), child: imagen);
  }

  Future<void> reproducirArtistaPremium(
    BuildContext context,
    List<Cancion> canciones,
  ) async {
    if (canciones.isEmpty) return;
    AudioPlayerService.instance.cargarCola(canciones, 0);
    final primera = canciones.first;
    await AudioPlayerService.instance.play(
      audio: primera.audio,
      tituloCancion: primera.titulo,
      artistaCancion: primera.artista,
      imagenCancion: primera.imagen,
    );
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerPage()),
    );
  }

  void filtrar(String texto) {
    setState(() {
      if (texto.trim().isEmpty) {
        artistas = List.from(clasicosLlano);
      } else {
        artistas = clasicosLlano.where((artista) {
          final busqueda = texto.toLowerCase();

          return artista.artista.toLowerCase().contains(busqueda) ||
              artista.apodo.toLowerCase().contains(busqueda) ||
              artista.estado.toLowerCase().contains(busqueda);
        }).toList();

        if (artistas.isNotEmpty) {
          AnalyticsService.logSearch(
            searchTerm: texto.trim(),
            searchType: 'clasicos',
          );
        }
      }
    });
  }

  Future<void> reproducirArtista(
    BuildContext context,
    ClasicoLlano artista,
  ) async {
    final cola = <Cancion>[];

    final indiceOriginal = clasicosLlano.indexOf(artista);

    for (int i = indiceOriginal; i < clasicosLlano.length; i++) {
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

    if (cola.isEmpty) return;

    AudioPlayerService.instance.cargarCola(cola, 0);

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
      MaterialPageRoute(builder: (_) => const PlayerPage()),
    );
  }

  void abrirArtista(BuildContext context, ClasicoLlano artista) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClasicoLlanoScreen(artista: artista)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      appBar: AppBar(
        title: const Text(
          "Grandes Voces del Llano",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _buscarController,
              onChanged: filtrar,
              decoration: InputDecoration(
                hintText: "Buscar artista...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                      if (cola.isEmpty) return;

                      AudioPlayerService.instance.cargarCola(cola, 0);

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
                        MaterialPageRoute(builder: (_) => const PlayerPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (artistasPremium.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 4),
                    child: Text(
                      'ARTISTAS PREMIUM',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  ...artistasPremium.entries
                      .where((entry) {
                        final texto = _buscarController.text
                            .trim()
                            .toLowerCase();
                        return texto.isEmpty ||
                            entry.value.first.artista.toLowerCase().contains(
                              texto,
                            );
                      })
                      .map((entry) {
                        final canciones = entry.value;
                        final primero = canciones.first;
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: imagenArtista(primero.imagen),
                            title: Text(
                              primero.artista,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              '${canciones.length} canciones • Premium',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                color: Colors.green,
                                size: 42,
                              ),
                              onPressed: () =>
                                  reproducirArtistaPremium(context, canciones),
                            ),
                            onTap: () =>
                                reproducirArtistaPremium(context, canciones),
                          ),
                        );
                      }),
                  const Divider(height: 24),
                ],
                if (artistas.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'GRANDES VOCES DEL LLANO',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ...artistas.map(
                  (artista) => Card(
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
                              child: const Icon(Icons.person, size: 35),
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

                      subtitle: Text(
                        artista.apodo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.green,
                          size: 42,
                        ),
                        onPressed: () {
                          reproducirArtista(context, artista);
                        },
                      ),

                      onTap: () {
                        abrirArtista(context, artista);
                      },
                    ),
                  ),
                ),
              ],
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

import 'package:flutter/material.dart';

import '../services/novedades_service.dart';

class NovedadesScreen extends StatefulWidget {
  const NovedadesScreen({super.key});

  @override
  State<NovedadesScreen> createState() => _NovedadesScreenState();
}

class _NovedadesScreenState extends State<NovedadesScreen> {
  @override
  void initState() {
    super.initState();

    NovedadesService.instance.marcarTodasComoVistas();
  }

  @override
  Widget build(BuildContext context) {
    final novedades = NovedadesService.instance.novedades;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      appBar: AppBar(
        title: const Text('Novedades'),
      ),

      body: novedades.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No hay novedades',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: novedades.length,
              itemBuilder: (context, index) {
                final novedad = novedades[index];

                final tipo =
                    novedad['tipo']?.toString() ?? 'sencillo';

                final titulo =
                    novedad['titulo']?.toString() ?? '';

                final artista =
                    novedad['artista']?.toString() ?? '';

                final album =
                    novedad['album']?.toString();

                final esAlbum =
                    tipo == 'album';

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.green.shade100,
                      child: Icon(
                        esAlbum
                            ? Icons.album
                            : Icons.music_note,
                        color: Colors.green.shade700,
                      ),
                    ),

                    title: Text(
                      esAlbum
                          ? 'Nuevo álbum'
                          : 'Nueva canción',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            artista,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),

                          if (album != null &&
                              album.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 3),
                              child: Text(
                                'Álbum: $album',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

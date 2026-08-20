import 'package:flutter/material.dart';

import '../services/playlist_service.dart';
import 'playlist_detail_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  @override
  void initState() {
    super.initState();

    PlaylistService.instance.addListener(_actualizar);
  }

  void _actualizar() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    PlaylistService.instance.removeListener(_actualizar);
    super.dispose();
  }

  Future<void> _crearPlaylist() async {
    final controller = TextEditingController();

    final nombre = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva playlist'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ej. Mis favoritas del llano',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final texto = controller.text.trim();

                if (texto.isNotEmpty) {
                  Navigator.pop(context, texto);
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (nombre == null || nombre.trim().isEmpty) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    await PlaylistService.instance.crearPlaylist(
      id: id,
      nombre: nombre.trim(),
    );
  }

  Future<void> _eliminarPlaylist(String id, String nombre) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar playlist'),
          content: Text(
            '¿Quieres eliminar "$nombre"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await PlaylistService.instance.eliminarPlaylist(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlists =
        PlaylistService.instance.obtenerPlaylists();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: const Text(
          'Mis Playlists',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearPlaylist,
        icon: const Icon(Icons.add),
        label: const Text('Nueva playlist'),
      ),
      body: playlists.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.queue_music,
                      size: 90,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Aún no tienes playlists',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Crea una playlist para organizar tus canciones favoritas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _crearPlaylist,
                      icon: const Icon(Icons.add),
                      label: const Text('Crear playlist'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];

                final id = playlist['id'] as String;
                final nombre = playlist['nombre'] as String;
                final canciones =
                    List<String>.from(
                  playlist['canciones'] ?? [],
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(12),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.queue_music,
                        color: Colors.green.shade700,
                        size: 32,
                      ),
                    ),
                    title: Text(
                      nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      '${canciones.length} '
                      '${canciones.length == 1 ? 'canción' : 'canciones'}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (valor) {
                        if (valor == 'eliminar') {
                          _eliminarPlaylist(id, nombre);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'eliminar',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaylistDetailScreen(
                            playlistId: id,
                            nombre: nombre,
                            canciones: canciones,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

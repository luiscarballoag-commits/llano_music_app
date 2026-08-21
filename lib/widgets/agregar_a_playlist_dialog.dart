import 'package:flutter/material.dart';

import '../services/playlist_service.dart';

Future<void> mostrarAgregarAPlaylistDialog({
  required BuildContext context,
  required String audio,
  required String tituloCancion,
}) async {
  final service = PlaylistService.instance;

  final playlists = service.obtenerPlaylists();

  if (playlists.isEmpty) {
    if (!context.mounted) return;

    final crear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('No tienes playlists'),
          content: const Text(
            'Crea una playlist para poder guardar tus canciones.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.add),
              label: const Text('Crear playlist'),
            ),
          ],
        );
      },
    );

    if (crear == true && context.mounted) {
      await _crearPlaylistYAgregar(
        context: context,
        audio: audio,
        tituloCancion: tituloCancion,
      );
    }

    return;
  }

  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'Agregar a playlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ...playlists.map((playlist) {
                final id = playlist['id'] as String;
                final nombre = playlist['nombre'] as String;

                final contiene =
                    service.contieneCancion(
                  id,
                  audio,
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Colors.green.shade100,
                    child: Icon(
                      contiene
                          ? Icons.check
                          : Icons.queue_music,
                      color: Colors.green.shade700,
                    ),
                  ),
                  title: Text(
                    nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    contiene
                        ? 'La canción ya está agregada'
                        : 'Agregar canción',
                  ),
                  trailing: contiene
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        ),
                  onTap: contiene
                      ? null
                      : () async {
                          await service.agregarCancion(
                            id,
                            audio,
                          );

                          if (!dialogContext.mounted) {
                            return;
                          }

                          Navigator.pop(dialogContext);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                '"$tituloCancion" '
                                'fue agregada a "$nombre"',
                              ),
                            ),
                          );
                        },
                );
              }),

              const Divider(),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(
                    Icons.add,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                title: const Text(
                  'Nueva playlist',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Crear y agregar esta canción',
                ),
                onTap: () async {
                  Navigator.pop(dialogContext);

                  await _crearPlaylistYAgregar(
                    context: context,
                    audio: audio,
                    tituloCancion: tituloCancion,
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

Future<void> _crearPlaylistYAgregar({
  required BuildContext context,
  required String audio,
  required String tituloCancion,
}) async {
  final controller = TextEditingController();

  final nombre = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Nueva playlist'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization:
              TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ej. Música para viajar',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final texto =
                  controller.text.trim();

              if (texto.isNotEmpty) {
                Navigator.pop(
                  dialogContext,
                  texto,
                );
              }
            },
            child: const Text('Crear'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  if (nombre == null ||
      nombre.trim().isEmpty) {
    return;
  }

  final id =
      DateTime.now().millisecondsSinceEpoch
          .toString();

  await PlaylistService.instance.crearPlaylist(
    id: id,
    nombre: nombre.trim(),
  );

  await PlaylistService.instance.agregarCancion(
    id,
    audio,
  );

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '"$tituloCancion" fue agregada a '
        '"${nombre.trim()}"',
      ),
    ),
  );
}

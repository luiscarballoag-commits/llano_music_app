import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/favorites_service.dart';
import 'favoritos_screen.dart';
import 'playlists_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  Future<void> _abrirYouTube() async {
    final url = Uri.parse(
      'https://youtube.com/@lcarballog',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _abrirTikTok() async {
    final url = Uri.parse(
      'https://www.tiktok.com/@produccioneslcarballog',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void _mostrarAcercaDe(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            10,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo/logo_llano_music.png',
                  width: 180,
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Llano Music',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Música y cultura de nuestro llano',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Llano Music es una plataforma dedicada a preservar, difundir y disfrutar la música del llano, acercando nuestros artistas, canciones y tradiciones a las nuevas generaciones.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Llano Music forma parte del ecosistema Producciones Lcarballog, un proyecto orientado a impulsar contenidos, música y cultura a través de las nuevas tecnologías.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Versión 1.0',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CERRAR',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritos =
        FavoritesService.instance.obtenerFavoritos().length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      appBar: AppBar(
        title: const Text("Mi Perfil"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 10),

            CircleAvatar(
              radius: 52,
              backgroundColor: const Color(0xFF2E7D32),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Mi Perfil",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Disfruta de la música del llano",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            // FAVORITOS
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                title: const Text(
                  "Canciones favoritas",
                ),
                subtitle: Text(
                  "$favoritos canciones",
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const FavoritosScreen(),
                    ),
                  );
                },
              ),
            ),

            // PLAYLISTS
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.queue_music,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text(
                  "Mis Playlists",
                ),
                subtitle: const Text(
                  "Organiza tus canciones",
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlaylistsScreen(),
                    ),
                  );
                },
              ),
            ),

            // HISTORIAL
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text(
                  "Historial",
                ),
                subtitle: const Text(
                  "Próximamente",
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
              ),
            ),

            // ACERCA DE LLANO MUSIC
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text(
                  "Acerca de Llano Music",
                ),
                subtitle: const Text(
                  "Música y cultura de nuestro llano",
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _mostrarAcercaDe(context);
                },
              ),
            ),

            const SizedBox(height: 20),

            // PRODUCCIONES LCARBALLOG
            const Text(
              "Producciones Lcarballog",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: "YouTube",
                  icon: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.red,
                    size: 34,
                  ),
                  onPressed: _abrirYouTube,
                ),

                const SizedBox(width: 20),

                IconButton(
                  tooltip: "TikTok",
                  icon: const Icon(
                    Icons.music_note,
                    color: Colors.black,
                    size: 32,
                  ),
                  onPressed: _abrirTikTok,
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              "Llano Music",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Versión 1.0",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/favorites_service.dart';
import 'playlists_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  Future<void> _abrirYouTube() async {
    final url = Uri.parse('https://youtube.com/@lcarballog');
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _abrirTikTok() async {
    final url = Uri.parse('https://www.tiktok.com/@produccioneslcarballog');
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
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

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                title: const Text("Canciones favoritas"),
                subtitle: Text("$favoritos canciones"),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.queue_music,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text("Mis Playlists"),
                subtitle: const Text(
                  "Organiza tus canciones",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlaylistsScreen(),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text("Historial"),
                subtitle: const Text(
                  "Próximamente",
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text("Acerca de Llano Music"),
                subtitle: const Text(
                  "Música y cultura de nuestro llano",
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Producciones Lcarballog",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(
                  Icons.play_circle_fill,
                  color: Colors.red,
                  size: 32,
                ),
                title: Text("YouTube"),
                trailing: Icon(Icons.chevron_right),
                onTap: _abrirYouTube,
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(
                  Icons.music_note,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text("TikTok"),
                trailing: Icon(Icons.chevron_right),
                onTap: _abrirTikTok,
              ),
            ),

            const SizedBox(height: 20),

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

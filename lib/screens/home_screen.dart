import 'package:flutter/material.dart';

import '../viewmodels/home_view_model.dart';
import 'artist_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeViewModel viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    final artists = viewModel.artists;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo/logo_llano_music.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text("Llano Music"),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];

          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(artist.imagen),
              ),
              title: Text(
                artist.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${artist.genero} • ${artist.estado}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArtistScreen(
                      artist: artist,
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

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
        title: const Text('Llano Music'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(artist.nombre),
              subtitle: Text(
                '${artist.genero} • ${artist.estado}',
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

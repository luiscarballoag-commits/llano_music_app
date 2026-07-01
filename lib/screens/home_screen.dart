import 'package:flutter/material.dart';

import '../viewmodels/home_view_model.dart';

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
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(artist.nombre),
              subtitle: Text('${artist.genero} • ${artist.estado}'),
            ),
          );
        },
      ),
    );
  }
}

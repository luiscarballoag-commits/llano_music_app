import 'package:flutter/material.dart';

import '../models/artist.dart';

class ArtistScreen extends StatelessWidget {
  final Artist artist;

  const ArtistScreen({
    super.key,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: CircleAvatar(
                radius: 70,
                child: const Icon(
                  Icons.person,
                  size: 70,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              artist.nombre,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Estado: ${artist.estado}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'Género: ${artist.genero}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'País: ${artist.pais}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 24),

            const Text(
              'Biografía',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              artist.descripcion,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

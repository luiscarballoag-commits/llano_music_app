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
        child: Column(
          children: [

            Image.asset(
              artist.imagen,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    artist.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.music_note),
                      const SizedBox(width: 8),
                      Text(artist.genero),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Text('${artist.estado}, ${artist.pais}'),
                    ],
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
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

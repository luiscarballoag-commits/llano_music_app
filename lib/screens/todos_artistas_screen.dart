import 'package:flutter/material.dart';

import '../screens/artist_screen.dart';
import '../viewmodels/home_view_model.dart';

class TodosArtistasScreen extends StatelessWidget {
  const TodosArtistasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final artistas = HomeViewModel().artists;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: const Text('Todos los artistas'),
      ),
      body: artistas.isEmpty
          ? const Center(
              child: Text(
                'No hay artistas disponibles.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: 0.78,
              ),
              itemCount: artistas.length,
              itemBuilder: (context, index) {
                final artist = artistas[index];

                return GestureDetector(
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
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(18),
                          child: Image.asset(
                            artist.imagen,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: Colors.green.shade100,
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artist.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

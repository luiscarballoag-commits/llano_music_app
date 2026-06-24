import 'package:flutter/material.dart';
import 'lista_canciones.dart';
import 'player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Llano Music'),
      ),
      body: ListView.builder(
        itemCount: canciones.length,
        itemBuilder: (context, index) {
          final cancion = canciones[index];

          return ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(cancion.titulo),
            subtitle: Text(cancion.artista),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerPage(
                    cancion: cancion,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

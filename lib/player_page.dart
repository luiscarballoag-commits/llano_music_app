import 'package:flutter/material.dart';
import 'cancion.dart';

class PlayerPage extends StatelessWidget {
  final Cancion cancion;

  const PlayerPage({
    super.key,
    required this.cancion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cancion.titulo),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.album,
              size: 120,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              cancion.titulo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cancion.artista,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 40),
            Icon(
              Icons.play_circle_fill,
              size: 80,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'lista_canciones.dart';
import 'player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff14532d),
                    Color(0xff15803d),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🎵 Llano Music",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "La música del llano venezolano",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: canciones.length,
                itemBuilder: (context, index) {

                  final cancion = canciones[index];

                  return Card(
                    color: const Color(0xff1e293b),
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          cancion.imagen,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        cancion.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        cancion.artista,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.green,
                        size: 34,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerPage(
                              cancion: cancion,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}         

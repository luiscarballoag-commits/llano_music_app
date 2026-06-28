import 'package:flutter/material.dart';

class ArtistasDestacados extends StatelessWidget {
  const ArtistasDestacados({super.key});

  final List<Map<String, String>> artistas = const [
    {
      "nombre": "Roberto Carballo",
      "imagen": "assets/images/roberto_carballo.jpg",
    },
    {
      "nombre": "Mary Pacheco",
      "imagen": "assets/images/mary_pacheco.jpg",
    },
    {
      "nombre": "Francisco Camacho",
      "imagen": "assets/images/francisco_camacho.jpg",
    },
    {
      "nombre": "José Ángel Cordero",
      "imagen": "assets/images/jose_angel_cordero.jpg",
    },
    {
      "nombre": "Omar García",
      "imagen": "assets/images/omar_garcia.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Artistas Destacados",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artistas.length,
            itemBuilder: (context, index) {
              final artista = artistas[index];

              return Container(
                width: 140,
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        artista["imagen"]!,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      artista["nombre"]!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

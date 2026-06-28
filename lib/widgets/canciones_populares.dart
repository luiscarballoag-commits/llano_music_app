import 'package:flutter/material.dart';

class CancionesPopulares extends StatelessWidget {
  const CancionesPopulares({super.key});

  final List<Map<String, String>> canciones = const [
    {
      "titulo": "Mi Padre y Gran Amigo",
      "artista": "José Ángel Cordero",
      "imagen": "assets/images/jose_angel_cordero.jpg",
    },
    {
      "titulo": "Propiedad Privada",
      "artista": "Mary Pacheco",
      "imagen": "assets/images/mary_pacheco.jpg",
    },
    {
      "titulo": "El Maquillaje",
      "artista": "Manuel Oliveros",
      "imagen": "assets/images/manuel_oliveros.jpg",
    },
    {
      "titulo": "Proyecto Divino",
      "artista": "Fabiana Díaz",
      "imagen": "assets/images/fabiana_diaz.jpg",
    },
    {
      "titulo": "Tu Mirada Es Un Soga",
      "artista": "Tatiana López",
      "imagen": "assets/images/tatiana_lopez.jpg",
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
            "Canciones Populares",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: canciones.length,
          itemBuilder: (context, index) {
            final cancion = canciones[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    cancion["imagen"]!,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  cancion["titulo"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(cancion["artista"]!),
                trailing: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.green,
                  size: 35,
                ),
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }
}

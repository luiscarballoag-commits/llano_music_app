import 'package:flutter/material.dart';

class ClasicosLlano extends StatelessWidget {
  const ClasicosLlano({super.key});

  final List<Map<String, String>> clasicos = const [
    {
      "titulo": "Cajón de Arauca",
      "artista": "Reynaldo Armas",
    },
    {
      "titulo": "Fiesta en Elorza",
      "artista": "Eneas Perdomo",
    },
    {
      "titulo": "Sentimiento Apureño",
      "artista": "Cristóbal Jiménez",
    },
    {
      "titulo": "La Viuda Millonaria",
      "artista": "Teo Galíndez",
    },
    {
      "titulo": "Linda Barinas",
      "artista": "Luis Silva",
    },
    {
      "titulo": "Caballo Viejo",
      "artista": "Simón Díaz",
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
            "⭐ Clásicos del Llano",
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
          itemCount: clasicos.length,
          itemBuilder: (context, index) {

            final cancion = clasicos[index];

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
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white,
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

import 'package:flutter/material.dart';

class Buscador extends StatelessWidget {
  const Buscador({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar artistas o canciones...",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.green,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

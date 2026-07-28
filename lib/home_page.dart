import 'package:flutter/material.dart';

import 'screens/explorar_screen.dart';

import 'widgets/home_header.dart';
import 'widgets/banner_principal.dart';
import 'widgets/buscador.dart';
import 'widgets/artistas_destacados.dart';
import 'widgets/clasicos_llano.dart';
import 'widgets/canciones_populares.dart';
import 'widgets/mini_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _paginaActual = 0;

  Widget _inicio() {
    return SafeArea(
      child: Column(
        children: [
          const HomeHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  BannerPrincipal(),
                  SizedBox(height: 10),
                  Buscador(),
                  SizedBox(height: 20),
                  ArtistasDestacados(),
                  SizedBox(height: 25),
                  ClasicosLlano(),
                  SizedBox(height: 25),
                  CancionesPopulares(),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),

          MiniPlayer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      _inicio(),
      const ExplorarScreen(),
      const Center(child: Text("Play")),
      const Center(child: Text("Favoritos")),
      const Center(child: Text("Perfil")),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      body: paginas[_paginaActual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: "Explorar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill, size: 38),
            label: "Play",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}

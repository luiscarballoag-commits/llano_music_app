import 'package:flutter/material.dart';

import 'widgets/home_header.dart';
import 'widgets/banner_principal.dart';
import 'widgets/buscador.dart';
import 'widgets/artistas_destacados.dart';
import 'widgets/canciones_populares.dart';
import 'widgets/mini_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      body: SafeArea(
        child: Column(
          children: [

            /// Encabezado
            const HomeHeader(),

            /// Contenido principal
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

                    CancionesPopulares(),

                    SizedBox(height: 120),

                  ],
                ),
              ),
            ),

            /// Mini reproductor
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}

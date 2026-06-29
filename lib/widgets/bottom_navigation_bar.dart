import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,

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
          icon: Icon(
            Icons.play_circle_fill,
            size: 38,
          ),
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
    );
  }
}

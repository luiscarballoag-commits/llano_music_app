import 'package:flutter/material.dart';
import '../services/radio_service.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final RadioService _radioService = RadioService.instance;

  static const String _radioUrl =
      'https://stream.zeno.fm/cc9rmsaqzsktv';

  @override
  void initState() {
    super.initState();
    _radioService.addListener(_actualizarEstado);
  }

  @override
  void dispose() {
    _radioService.removeListener(_actualizarEstado);
    super.dispose();
  }

  void _actualizarEstado() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _alternarRadio() async {
    if (_radioService.reproduciendo) {
      await _radioService.detener();
    } else {
      await _radioService.reproducir(
        url: _radioUrl,
        nombre: 'Radio Dinamita',
      );

      if (mounted && _radioService.ultimoError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo conectar con Radio Dinamita',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reproduciendo = _radioService.reproduciendo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/radios/radio_dinamita.jpg',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Radio Dinamita',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Full Explosiva',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                iconSize: 60,
                color: Colors.white,
                icon: Icon(
                  reproduciendo
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
                onPressed: _alternarRadio,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              reproduciendo
                  ? 'RADIO EN VIVO'
                  : 'Presiona para escuchar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: reproduciendo
                    ? Colors.green
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

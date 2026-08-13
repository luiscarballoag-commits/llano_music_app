import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool _reproduciendo = false;

  static const String _radioUrl =
      'https://stream.zeno.fm/cc9rmsaqzsktv';

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _alternarRadio() async {
    if (_reproduciendo) {
      await _player.stop();

      setState(() {
        _reproduciendo = false;
      });
    } else {
      try {
        await _player.play(
          UrlSource(_radioUrl),
        );

        setState(() {
          _reproduciendo = true;
        });
      } catch (e) {
        debugPrint('Error al reproducir Radio Dinamita: $e');

        if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
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
                  _reproduciendo
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
                onPressed: _alternarRadio,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              _reproduciendo
                  ? 'RADIO EN VIVO'
                  : 'Presiona para escuchar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _reproduciendo
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

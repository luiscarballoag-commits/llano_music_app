import 'package:flutter/material.dart';
import '../services/radio_service.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final RadioService _radioService = RadioService.instance;

  static const Color _verde = Color(0xFF167A3F);
  static const Color _oscuro = Color(0xFF104D2A);
  static const Color _fondo = Color(0xFFF5F7F5);
  static const String _logo = 'assets/images/logo/logo_llano_music.png';

  static const List<Map<String, String>> _emisoras = [
    {
      'nombre': 'Radio Dinamita',
      'subtitulo': 'Full Explosiva',
      'url': 'https://stream.zeno.fm/cc9rmsaqzsktv',
      'imagen': 'assets/images/radios/radio_dinamita.jpg',
    },
    {
      'nombre': 'FOLKLORÍSIMA 98.9 FM',
      'subtitulo': 'La Criollita de Cojedes',
      'url': 'https://stream.zeno.fm/dlrj5lnicbitv',
      'imagen': 'assets/images/radios/Folklorisima.png',
    },
  ];

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
    if (mounted) setState(() {});
  }

  bool _activa(Map<String, String> emisora) {
    return _radioService.reproduciendo &&
        _radioService.nombre == emisora['nombre'];
  }

  Future<void> _alternar(Map<String, String> emisora) async {
    if (_activa(emisora)) {
      await _radioService.detener();
      return;
    }

    await _radioService.reproducir(
      url: emisora['url']!,
      nombre: emisora['nombre']!,
    );

    if (!mounted) return;

    if (_radioService.ultimoError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar con ${emisora['nombre']}')),
      );
    }
  }

  Widget _construirTarjeta(Map<String, String> emisora) {
    final activa = _activa(emisora);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: activa ? _verde : Colors.black12,
          width: activa ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 94,
            height: 94,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black12, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Image.asset(
                emisora['imagen']!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.radio_rounded, size: 48, color: _verde),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emisora['nombre']!,
                  style: const TextStyle(
                    color: Color(0xFF24392B),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  emisora['subtitulo']!,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      activa ? Icons.graphic_eq_rounded : Icons.radio_rounded,
                      color: _verde,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        activa ? 'RADIO EN VIVO' : 'EMISORA ONLINE',
                        style: const TextStyle(
                          color: _verde,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: _verde,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: activa ? 'Detener' : 'Reproducir',
              onPressed: () => _alternar(emisora),
              color: Colors.white,
              iconSize: 29,
              icon: Icon(
                activa ? Icons.stop_rounded : Icons.play_arrow_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.22, 0.46, 1.0],
            colors: [_oscuro, _verde, _fondo, _fondo],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  child: Column(
                    children: [
                      Container(
                        width: 112,
                        height: 112,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _logo,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.music_note_rounded,
                              color: _verde,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'RADIOS EN VIVO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'El sonido auténtico del llano',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 14),
                      child: Text(
                        'Sintoniza tu emisora favorita',
                        style: TextStyle(
                          color: Color(0xFF24392B),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    ..._emisoras.map(_construirTarjeta),
                    const SizedBox(height: 8),
                    const Text(
                      'LLANO MUSIC · PRODUCCIONES LCARBALLOG',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _verde,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

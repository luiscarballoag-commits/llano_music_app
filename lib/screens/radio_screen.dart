import 'package:flutter/material.dart';

import '../services/radio_service.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final RadioService _radioService = RadioService.instance;

  static const Color _verde = Color(0xFF2E7D32);

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

  int _emisoraSeleccionada = 0;

  Map<String, String> get _emisoraActual => _emisoras[_emisoraSeleccionada];

  bool get _reproduciendoEstaEmisora =>
      _radioService.reproduciendo &&
      _radioService.nombre == _emisoraActual['nombre'];

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

  Future<void> _seleccionarEmisora(int indice) async {
    if (indice == _emisoraSeleccionada) return;

    if (_radioService.reproduciendo) {
      await _radioService.detener();
    }

    if (!mounted) return;

    setState(() {
      _emisoraSeleccionada = indice;
    });
  }

  Future<void> _alternarRadio() async {
    if (_reproduciendoEstaEmisora) {
      await _radioService.detener();
      return;
    }

    await _radioService.reproducir(
      url: _emisoraActual['url']!,
      nombre: _emisoraActual['nombre']!,
    );

    if (mounted && _radioService.ultimoError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo conectar con ${_emisoraActual['nombre']}'),
        ),
      );
    }
  }

  Widget _construirImagen() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        _emisoraActual['imagen']!,
        width: 220,
        height: 220,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 220,
            height: 220,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.radio, size: 110, color: _verde),
          );
        },
      ),
    );
  }

  Widget _construirSelector(int indice) {
    final emisora = _emisoras[indice];
    final seleccionada = indice == _emisoraSeleccionada;

    return Expanded(
      child: InkWell(
        onTap: () => _seleccionarEmisora(indice),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color: seleccionada
                ? _verde.withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: seleccionada ? _verde : Colors.black12,
              width: seleccionada ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.radio,
                color: seleccionada ? _verde : Colors.grey,
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                emisora['nombre']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: seleccionada
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: seleccionada ? _verde : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reproduciendo = _reproduciendoEstaEmisora;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio'),
        backgroundColor: _verde,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _construirImagen(),
              const SizedBox(height: 22),
              Text(
                _emisoraActual['nombre']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _emisoraActual['subtitulo']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  _construirSelector(0),
                  const SizedBox(width: 12),
                  _construirSelector(1),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                  color: _verde,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 60,
                  color: Colors.white,
                  icon: Icon(reproduciendo ? Icons.stop : Icons.play_arrow),
                  onPressed: _alternarRadio,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                reproduciendo ? 'RADIO EN VIVO' : 'Presiona para escuchar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: reproduciendo ? _verde : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

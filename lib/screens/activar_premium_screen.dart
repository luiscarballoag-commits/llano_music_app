import 'package:flutter/material.dart';

import '../repositories/catalogo_music_repository.dart';
import '../services/licencia_service.dart';
import '../services/premium_storage_service.dart';

class ActivarPremiumScreen extends StatefulWidget {
  const ActivarPremiumScreen({super.key});

  @override
  State<ActivarPremiumScreen> createState() => _ActivarPremiumScreenState();
}

class _ActivarPremiumScreenState extends State<ActivarPremiumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();

  bool _cargando = false;
  String? _mensaje;
  bool? _activacionCorrecta;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _activar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensaje = null;
      _activacionCorrecta = null;
    });

    final resultado = await LicenciaService.instance.validar(
      _codigoController.text,
    );

    if (!mounted) return;

    var correcta = resultado['ok'] == true;
    final estado = resultado['estado']?.toString() ?? 'desconocido';
    String mensaje;

    if (correcta) {
      final fecha = resultado['fecha_vencimiento'];

      if (fecha is String && fecha.isNotEmpty) {
        try {
          await PremiumStorageService.instance.guardarFechaVencimiento(fecha);
          final vencimiento = DateTime.parse(fecha).toLocal();
          mensaje =
              '¡Premium activado! Vence el '
              '${vencimiento.day.toString().padLeft(2, '0')}/'
              '${vencimiento.month.toString().padLeft(2, '0')}/'
              '${vencimiento.year}.';
        } catch (_) {
          correcta = false;
          mensaje =
              'El servidor confirmó la licencia, pero no se pudo '
              'guardar su vencimiento. Inténtalo de nuevo.';
        }
      } else {
        correcta = false;
        mensaje = 'El servidor no devolvió la fecha de vencimiento.';
      }
    } else {
      mensaje = _mensajeError(estado);
    }

    if (correcta) {
      try {
        CatalogoMusicRepository.instance.establecerPremiumActivo(true);
        await CatalogoMusicRepository.instance.cargarCatalogoRemoto();
      } catch (_) {
        // La licencia sigue activa aunque falle la carga del catálogo.
      }
    }

    if (!mounted) return;

    if (correcta) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _cargando = false;
      _activacionCorrecta = false;
      _mensaje = mensaje;
    });
  }

  String _mensajeError(String estado) {
    switch (estado) {
      case 'otro_dispositivo':
        return 'Esta licencia ya está vinculada a otro dispositivo.';
      case 'vencida':
        return 'Esta licencia ha vencido.';
      case 'revocada':
        return 'Esta licencia ha sido revocada.';
      case 'pendiente':
        return 'Esta licencia todavía no está disponible.';
      case 'codigo_vacio':
        return 'Introduce tu código de licencia.';
      case 'datos_invalidos':
        return 'El código o los datos del dispositivo no son válidos.';
      case 'error_conexion':
        return 'No se pudo conectar. Comprueba tu conexión a Internet.';
      case 'error_servidor':
      case 'solicitud_invalida':
      case 'respuesta_invalida':
        return 'No se pudo validar la licencia. Inténtalo de nuevo.';
      default:
        return 'No fue posible activar la licencia. Estado: $estado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activar Premium')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.workspace_premium, size: 76),
                const SizedBox(height: 16),
                const Text(
                  'LlanoMusic Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Introduce el código que recibiste después de realizar tu pago.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _codigoController,
                  textCapitalization: TextCapitalization.characters,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Código Premium',
                    hintText: 'LLANOMUSIC-XXXX-XXXX',
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Escribe tu código Premium.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _cargando ? null : _activar,
                  icon: _cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.verified),
                  label: Text(_cargando ? 'Validando...' : 'Validar y activar'),
                ),
                if (_mensaje != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _mensaje!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _activacionCorrecta == true
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

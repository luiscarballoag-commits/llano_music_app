import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dispositivo_service.dart';
import 'premium_storage_service.dart';

class LicenciaService {
  LicenciaService._();

  static final LicenciaService instance = LicenciaService._();

  static const String _url =
      'https://fhpvfvbwxjclwhysbqab.supabase.co/functions/v1/validar-licencia';

  Future<Map<String, dynamic>> _solicitar(
    Map<String, dynamic> datos,
  ) async {
    try {
      final respuesta = await http
          .post(
            Uri.parse(_url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(datos),
          )
          .timeout(const Duration(seconds: 20));

      final dynamic resultado = jsonDecode(respuesta.body);

      if (resultado is Map<String, dynamic>) {
        return resultado;
      }

      return {'ok': false, 'estado': 'respuesta_invalida'};
    } on FormatException {
      return {'ok': false, 'estado': 'respuesta_invalida'};
    } catch (_) {
      return {'ok': false, 'estado': 'error_conexion'};
    }
  }

  Future<Map<String, dynamic>> validar(String codigo) async {
    final codigoLimpio = codigo.trim();

    if (codigoLimpio.isEmpty) {
      return {'ok': false, 'estado': 'codigo_vacio'};
    }

    final dispositivoId = await DispositivoService.obtenerId();

    final resultado = await _solicitar({
      'accion': 'activar',
      'codigo': codigoLimpio,
      'dispositivo_id': dispositivoId,
    });

    if (resultado['ok'] != true) {
      return resultado;
    }

    final token = resultado['token'];
    final fecha = resultado['fecha_vencimiento'];

    if (token is! String ||
        token.isEmpty ||
        fecha is! String ||
        fecha.isEmpty) {
      return {'ok': false, 'estado': 'respuesta_invalida'};
    }

    try {
      await PremiumStorageService.instance.guardarTokenSesion(token);
      await PremiumStorageService.instance.guardarFechaVencimiento(fecha);
      return resultado;
    } catch (_) {
      await PremiumStorageService.instance.borrarLicenciaLocal();
      return {'ok': false, 'estado': 'error_guardado'};
    }
  }

  Future<Map<String, dynamic>> verificarSesion() async {
    final token =
        await PremiumStorageService.instance.obtenerTokenSesion();

    if (token == null || token.isEmpty) {
      return {'ok': false, 'estado': 'sin_sesion'};
    }

    final dispositivoId = await DispositivoService.obtenerId();

    final resultado = await _solicitar({
      'accion': 'verificar',
      'token': token,
      'dispositivo_id': dispositivoId,
    });

    if (resultado['ok'] == true) {
      final fecha = resultado['fecha_vencimiento'];

      if (fecha is String && fecha.isNotEmpty) {
        try {
          await PremiumStorageService.instance
              .guardarFechaVencimiento(fecha);
        } catch (_) {
          return {'ok': false, 'estado': 'error_guardado'};
        }
      }
    }

    return resultado;
  }
}

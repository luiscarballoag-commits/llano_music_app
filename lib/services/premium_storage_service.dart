import 'package:shared_preferences/shared_preferences.dart';

class PremiumStorageService {
  PremiumStorageService._();

  static final PremiumStorageService instance =
      PremiumStorageService._();

  static const String _fechaVencimientoKey =
      'llanomusic_premium_fecha_vencimiento';

  static const String _tokenSesionKey =
      'llanomusic_premium_token_sesion';

  final SharedPreferencesAsync _preferences =
      SharedPreferencesAsync();

  Future<void> guardarTokenSesion(String token) async {
    final valor = token.trim();
    if (valor.isEmpty) {
      throw const FormatException('El token de sesión está vacío.');
    }
    await _preferences.setString(_tokenSesionKey, valor);
  }

  Future<String?> obtenerTokenSesion() async {
    return await _preferences.getString(_tokenSesionKey);
  }

  Future<void> borrarTokenSesion() async {
    await _preferences.remove(_tokenSesionKey);
  }

  Future<void> guardarFechaVencimiento(String fecha) async {
    final vencimiento = DateTime.tryParse(fecha);

    if (vencimiento == null) {
      throw const FormatException(
        'La fecha de vencimiento no es válida.',
      );
    }

    await _preferences.setString(
      _fechaVencimientoKey,
      vencimiento.toUtc().toIso8601String(),
    );
  }

  Future<DateTime?> obtenerFechaVencimiento() async {
    final fecha = await _preferences.getString(
      _fechaVencimientoKey,
    );

    if (fecha == null) {
      return null;
    }

    return DateTime.tryParse(fecha)?.toUtc();
  }

  Future<bool> estaVigenteLocalmente() async {
    final vencimiento = await obtenerFechaVencimiento();

    if (vencimiento == null) {
      return false;
    }

    return DateTime.now().toUtc().isBefore(vencimiento);
  }

  Future<void> borrarLicenciaLocal() async {
    await _preferences.remove(_fechaVencimientoKey);
    await _preferences.remove(_tokenSesionKey);
  }
}

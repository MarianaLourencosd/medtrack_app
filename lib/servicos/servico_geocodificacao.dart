import 'package:flutter_nominatim/flutter_nominatim.dart';

class ServicoGeocodificacao {
  final Nominatim _nominatim = Nominatim.instance;

  Future<Map<String, double>?> buscarCoordenadas(String endereco) async {
    try {
      final resultado = await _nominatim.getLatLngFromAddress(endereco);
      return {
        'latitude': resultado.latitude,
        'longitude': resultado.longitude,
      };
    } catch (_) {
      return null;
    }
  }
}
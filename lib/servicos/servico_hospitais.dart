import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

import '../modelos/hospital.dart';

class ServicoHospitais {
  Future<Position> obterLocalizacao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      throw Exception('Ative o GPS do seu celular');
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão negada permanentemente. Ative nas configurações do celular',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<List<Hospital>> carregarHospitais() async {
    final String dados =
        await rootBundle.loadString('assets/hospitais.json');
    final List<dynamic> lista = json.decode(dados);
    return lista.map((e) => Hospital.fromJson(e)).toList();
  }

  Future<List<Map<String, dynamic>>> hospitaisProximos() async {
    final Position posicao = await obterLocalizacao();
    final List<Hospital> hospitais = await carregarHospitais();

    final List<Map<String, dynamic>> resultado = [];

    for (final hospital in hospitais) {
      final double distancia = Geolocator.distanceBetween(
        posicao.latitude,
        posicao.longitude,
        hospital.latitude,
        hospital.longitude,
      );

      resultado.add({
        'hospital': hospital,
        'distancia': distancia,
      });
    }

    resultado.sort(
      (a, b) =>
          (a['distancia'] as double).compareTo(b['distancia'] as double),
    );

    return resultado;
  }
}
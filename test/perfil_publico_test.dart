import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/modelos/perfil_publico.dart';
import 'package:medtrack_app/servicos/servico_perfil.dart';

/// Simula um `Timestamp` do Firestore sem depender do plugin nativo.
class _FalsoTimestamp {
  const _FalsoTimestamp(this.valor);

  final DateTime valor;

  DateTime toDate() => valor;
}

void main() {
  group('PerfilPublico', () {
    test('combina usuário e formulário e expõe apenas dados gerais', () {
      final perfil = PerfilPublico.fromMap(
        'uid123',
        {
          'nome': 'Maria da Silva',
          'email': 'maria@exemplo.com',
          'cpf': '123.456.789-00',
        },
        {
          'idade': 36,
          'sexo': 'Feminino',
          'tipoSanguineo': 'O+',
          'alergias': 'Dipirona',
          'condicoesPreexistentes': 'Asma',
          'medicamentos': 'Budesonida',
          'contatoEmergencia': 'João da Silva',
          'contatoEmergenciaParentesco': 'Irmão',
          'contatoEmergenciaTelefone': '(11) 98888-8888',
          'observacoes': 'Não deve aparecer na prévia pública.',
          'cartaoSus': '123456789012345',
        },
      );

      expect(perfil.uid, 'uid123');
      expect(perfil.nome, 'Maria da Silva');
      expect(perfil.idade, '36');
      expect(perfil.tipoSanguineo, 'O+');
      expect(perfil.alergias, 'Dipirona');
      expect(perfil.contatoEmergenciaTelefone, '(11) 98888-8888');
    });

    test('usa fallback de nome e ignora campos vazios', () {
      final perfil = PerfilPublico.fromMap('uid123', const {}, const {});

      expect(perfil.nome, 'Usuário MedTrack');
      expect(perfil.idade, isNull);
      expect(perfil.sexo, isNull);
      expect(perfil.alergias, isNull);
    });
  });

  group('ServicoPerfil.sanitizarJson', () {
    test('converte Timestamp em data ISO e produz JSON válido', () {
      final dados = {
        'nome': 'Maria',
        'atualizadoEm': _FalsoTimestamp(DateTime.utc(2026, 1, 2, 3, 4)),
        'criadoEm': DateTime.utc(2025, 12, 31),
        'lista': [
          1,
          true,
          null,
          {'peso': 62.5},
        ],
      };

      final seguro = ServicoPerfil.sanitizarJson(dados);

      expect(seguro['atualizadoEm'], '2026-01-02T03:04:00.000Z');
      expect(seguro['criadoEm'], '2025-12-31T00:00:00.000Z');
      expect(seguro['lista'][3]['peso'], 62.5);
      expect(() => jsonEncode(seguro), returnsNormally);
    });

    test('mantém tipos primitivos e converte objetos desconhecidos', () {
      expect(ServicoPerfil.sanitizarJson('texto'), 'texto');
      expect(ServicoPerfil.sanitizarJson(42), 42);
      expect(ServicoPerfil.sanitizarJson(true), isTrue);
      expect(ServicoPerfil.sanitizarJson(null), isNull);
      expect(ServicoPerfil.sanitizarJson(const Object()), isA<String>());
    });
  });
}

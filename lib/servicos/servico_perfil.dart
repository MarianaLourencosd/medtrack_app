import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modelos/perfil_publico.dart';
import 'servico_autenticacao.dart';

/// Centraliza a leitura de perfis do Firestore e o cache local usado pelo PDF.
class ServicoPerfil {
  ServicoPerfil({ServicoAutenticacao? autenticacao})
    : _autenticacao = autenticacao ?? ServicoAutenticacao();

  final ServicoAutenticacao _autenticacao;

  static const String _prefixoCache = 'perfil_completo_';

  /// Carrega somente os campos que podem ser mostrados no perfil compartilhado.
  Future<PerfilPublico?> carregarPerfilPublico(String uid) async {
    final resultados = await Future.wait<Map<String, dynamic>?>([
      _autenticacao.getUsuario(uid),
      _autenticacao.getFormulario(uid),
    ]);

    final usuario = resultados[0];
    final formulario = resultados[1];

    if (usuario == null && formulario == null) return null;

    return PerfilPublico.fromMap(uid, usuario ?? const {}, formulario);
  }

  /// Carrega o perfil completo do usuário autenticado.
  ///
  /// Em caso de falha de rede, devolve o último cache salvo.
  Future<Map<String, dynamic>?> carregarPerfilCompletoAtual() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final resultados = await Future.wait<Map<String, dynamic>?>([
        _autenticacao.getUsuario(user.uid),
        _autenticacao.getFormulario(user.uid),
      ]);

      final usuario = resultados[0];
      final formulario = resultados[1];

      if (usuario == null && formulario == null) {
        return await _carregarCache(user.uid);
      }

      final perfil = <String, dynamic>{
        ...?usuario,
        ...?formulario,
        'uid': user.uid,
        'email': usuario?['email'] ?? user.email,
      };

      await _salvarCache(user.uid, perfil);
      return perfil;
    } catch (_) {
      return _carregarCache(user.uid);
    }
  }

  /// Retorna o nome do usuário autenticado para cabeçalhos e compartilhamento.
  Future<String> nomeUsuarioAtual() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Usuário MedTrack';

    final displayName = user.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) return displayName;

    try {
      final usuario = await _autenticacao.getUsuario(user.uid);
      final nome = usuario?['nome']?.toString().trim();
      if (nome != null && nome.isNotEmpty) return nome;
    } catch (_) {
      // Usa o fallback abaixo.
    }

    return 'Usuário MedTrack';
  }

  Future<void> _salvarCache(String uid, Map<String, dynamic> perfil) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(sanitizarJson(perfil));
      await prefs.setString('$_prefixoCache$uid', json);
    } catch (_) {
      // O cache é opcional: uma falha ao gravar não pode invalidar o perfil
      // recém-lido do Firestore (ex.: `Timestamp` não serializável).
    }
  }

  /// Converte valores do Firestore em tipos aceitos por `jsonEncode`.
  ///
  /// Documentos com `Timestamp` (como `atualizadoEm`) não são serializáveis
  /// diretamente. Sem essa conversão o cache falhava e o PDF podia cair no
  /// estado de "formulário não preenchido" mesmo com dados disponíveis.
  @visibleForTesting
  static dynamic sanitizarJson(dynamic valor) {
    if (valor == null || valor is String || valor is num || valor is bool) {
      return valor;
    }

    if (valor is DateTime) return valor.toIso8601String();

    if (valor is Map) {
      return valor.map(
        (chave, item) => MapEntry(chave.toString(), sanitizarJson(item)),
      );
    }

    if (valor is Iterable) {
      return valor.map(sanitizarJson).toList(growable: false);
    }

    // Firestore `Timestamp`/`GeoPoint` e outros objetos com `toDate()`.
    try {
      final dynamic objeto = valor;
      final data = objeto.toDate();
      if (data is DateTime) return data.toIso8601String();
    } catch (_) {
      // Objeto sem `toDate()`: usa a representação textual como fallback.
    }

    return valor.toString();
  }

  Future<Map<String, dynamic>?> _carregarCache(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('$_prefixoCache$uid');
    if (json == null || json.isEmpty) return null;

    try {
      final dados = jsonDecode(json);
      return dados is Map<String, dynamic> ? dados : null;
    } catch (_) {
      return null;
    }
  }
}

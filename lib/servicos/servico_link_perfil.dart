import 'dart:convert';

import '../constantes/config_links.dart';

/// Gera e interpreta links de perfil.
///
/// Formatos aceitos na leitura:
/// - `medtrack://perfil/<uid>`
/// - `medtrack://perfil?uid=<uid>`
/// - `https://qualquer-dominio/perfil/<uid>`
/// - JSON `{"uid": "..."}`
/// - UID puro (ex.: conteúdo de um QR Code antigo)
class ServicoLinkPerfil {
  const ServicoLinkPerfil();

  static final RegExp _uidValido = RegExp(r'^[A-Za-z0-9_-]{6,128}$');

  /// Link compartilhável atual.
  String gerarLink(String uid) => ConfigLinks.linkPerfil(uid);

  /// Texto enviado no menu nativo de compartilhamento.
  String textoCompartilhamento(String uid, {String? nome}) {
    final destinatario = (nome == null || nome.trim().isEmpty)
        ? 'meu perfil'
        : 'o perfil de ${nome.trim()}';
    return 'Veja $destinatario no MedTrack:\n${gerarLink(uid)}';
  }

  /// Extrai um UID de um link, JSON ou texto puro.
  String? extrairUid(String? payload) {
    if (payload == null) return null;
    final texto = payload.trim();
    if (texto.isEmpty) return null;

    // Tenta interpretar como URI.
    final uri = Uri.tryParse(texto);
    if (uri != null && uri.hasScheme) {
      final daUri = _extrairDeUri(uri);
      if (daUri != null) return daUri;
    }

    // Tenta interpretar como JSON.
    try {
      final json = jsonDecode(texto);
      if (json is Map) {
        for (final chave in const ['uid', 'usuarioId', 'id']) {
          final valor = json[chave];
          if (valor is String && _uidValido.hasMatch(valor.trim())) {
            return valor.trim();
          }
        }
      }
    } catch (_) {
      // Não era JSON; segue para a validação de UID puro.
    }

    // Último caso: o QR Code contém apenas o UID.
    return _uidValido.hasMatch(texto) ? texto : null;
  }

  String? _extrairDeUri(Uri uri) {
    final uidQuery = uri.queryParameters['uid'];
    if (uidQuery != null && _uidValido.hasMatch(uidQuery.trim())) {
      return uidQuery.trim();
    }

    if (uri.scheme == ConfigLinks.scheme) {
      final segmentos = uri.pathSegments;
      if (uri.host == ConfigLinks.hostPerfil) {
        if (segmentos.isEmpty) return null;
        final uid = segmentos.first.trim();
        return _uidValido.hasMatch(uid) ? uid : null;
      }
      // Também aceita o formato antigo medtrack://<uid>, mas somente quando o
      // host é o único componente do link.
      if (uri.host.isNotEmpty &&
          segmentos.isEmpty &&
          _uidValido.hasMatch(uri.host)) {
        return uri.host;
      }
    }

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      final segmentos = uri.pathSegments;
      final indicePerfil = segmentos.indexOf(ConfigLinks.hostPerfil);
      if (indicePerfil >= 0 && indicePerfil + 1 < segmentos.length) {
        final uid = segmentos[indicePerfil + 1].trim();
        if (_uidValido.hasMatch(uid)) return uid;
      }
    }

    return null;
  }
}

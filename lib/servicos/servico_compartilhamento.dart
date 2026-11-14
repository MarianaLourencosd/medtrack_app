import 'dart:ui';

import 'package:share_plus/share_plus.dart';

import 'servico_link_perfil.dart';

/// Abre o menu nativo de compartilhamento com o link do perfil.
class ServicoCompartilhamento {
  ServicoCompartilhamento({ServicoLinkPerfil? links})
    : _links = links ?? const ServicoLinkPerfil();

  final ServicoLinkPerfil _links;

  String gerarLink(String uid) => _links.gerarLink(uid);

  String textoCompartilhamento(String uid, {String? nome}) {
    return _links.textoCompartilhamento(uid, nome: nome);
  }

  /// Retorna `true` quando o menu nativo foi aberto e o conteúdo enviado.
  ///
  /// [origem] é usada no iPad para posicionar o popover do menu.
  Future<bool> compartilharPerfil({
    required String uid,
    String? nome,
    Rect? origem,
  }) async {
    final resultado = await SharePlus.instance.share(
      ShareParams(
        text: textoCompartilhamento(uid, nome: nome),
        subject: 'Perfil MedTrack',
        sharePositionOrigin: origem,
      ),
    );
    return resultado.status == ShareResultStatus.success;
  }
}

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../servicos/servico_link_perfil.dart';
import '../telas/perfil/perfil_publico_screen.dart';

/// Escuta o custom scheme `medtrack://perfil/<uid>` e abre o perfil público.
///
/// Deve envolver o conteúdo inicial do `MaterialApp` para funcionar tanto com
/// o aplicativo aberto quanto com o aplicativo iniciado pelo link.
class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  final ServicoLinkPerfil _links = const ServicoLinkPerfil();
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _inscricao;
  String? _ultimoUid;
  DateTime? _ultimoEm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _configurar());
  }

  Future<void> _configurar() async {
    try {
      _inscricao = _appLinks.uriLinkStream.listen(
        _tratarLink,
        onError: (_) {
          // Plataforma sem suporte a deep link: ignora silenciosamente.
        },
      );

      final inicial = await _appLinks.getInitialLink();
      if (inicial != null) _tratarLink(inicial);
    } catch (_) {
      // Sem suporte na plataforma atual (ex.: desktop sem handler).
    }
  }

  void _tratarLink(Uri uri) {
    final uid = _links.extrairUid(uri.toString());
    if (uid == null) return;

    // Evita abrir a mesma tela duas vezes quando o link chega pelo stream e
    // pelo `getInitialLink` ao mesmo tempo.
    final agora = DateTime.now();
    final repetido =
        _ultimoUid == uid &&
        _ultimoEm != null &&
        agora.difference(_ultimoEm!).inSeconds < 3;
    if (repetido) return;

    _ultimoUid = uid;
    _ultimoEm = agora;

    final navigator = widget.navigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      MaterialPageRoute(builder: (_) => TelaPerfilPublico(uid: uid)),
    );
  }

  @override
  void dispose() {
    _inscricao?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

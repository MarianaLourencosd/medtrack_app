import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../recursos/secao_acoes_rapidas.dart';

/// Ações rápidas exibidas na Home.
///
/// A composição visual fica em [SecaoAcoesRapidas]; aqui apenas ligamos cada
/// atalho às rotas existentes do aplicativo.
class AcoesRapidasHome extends StatelessWidget {
  final Function(String) onNavigate;

  const AcoesRapidasHome({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SecaoAcoesRapidas(
      acoes: [
        AcaoRapidaItem(
          icone: Icons.qr_code_rounded,
          titulo: 'QR Code',
          cor: CoresApp.primary,
          fundo: CoresApp.mint,
          aoTocar: () => onNavigate('QR Code'),
        ),
        AcaoRapidaItem(
          icone: Icons.share_rounded,
          titulo: 'Compartilhar',
          cor: CoresApp.info,
          fundo: CoresApp.softBlue,
          aoTocar: () => onNavigate('Compartilhar'),
        ),
        AcaoRapidaItem(
          icone: Icons.notifications_rounded,
          titulo: 'Lembretes',
          cor: CoresApp.warning,
          fundo: CoresApp.softYellow,
          aoTocar: () => onNavigate('Lembretes'),
        ),
        AcaoRapidaItem(
          icone: Icons.picture_as_pdf_rounded,
          titulo: 'PDF',
          cor: CoresApp.error,
          fundo: CoresApp.softRed,
          aoTocar: () => onNavigate('PDF'),
        ),
      ],
    );
  }
}

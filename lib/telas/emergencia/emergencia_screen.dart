import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class TelaEmergencia extends StatelessWidget {
  const TelaEmergencia({super.key});

  Future<void> _ligar(BuildContext context, String numero) async {
    final uri = Uri(scheme: 'tel', path: numero);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Não foi possível ligar para $numero'),
              backgroundColor: CoresApp.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao tentar ligar para $numero'),
            backgroundColor: CoresApp.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkBackground : CoresApp.background;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          'Emergência',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBotaoSamu(context),
              const SizedBox(height: 22),
              Text(
                'Meus dados de emergência',
                style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Informações que podem salvar sua vida',
                style: AppTextStyles.subtituloSecao
                    .copyWith(color: subtituloColor),
              ),
              const SizedBox(height: 14),
              _buildCardTipoSanguineo(context),
              const SizedBox(height: 12),
              _buildCardAlergias(context),
              const SizedBox(height: 12),
              _buildCardContato(context),
              const SizedBox(height: 12),
              _buildCardPlano(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotaoSamu(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ligar para o SAMU 192',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _ligar(context, '192'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CoresApp.error,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: CoresApp.error.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: CoresApp.white.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    color: CoresApp.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ligar para o SAMU',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: CoresApp.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Toque para chamar o 192',
                        style: TextStyle(
                          fontSize: 12,
                          color: CoresApp.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: CoresApp.white,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTipoSanguineo(BuildContext context) {
    return _cardBase(
      context: context,
      icon: Icons.bloodtype_rounded,
      iconColor: CoresApp.error,
      iconBg: CoresApp.error.withValues(alpha: 0.15),
      titulo: 'Tipo sanguíneo',
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'O+',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: CoresApp.error,
          ),
        ),
      ),
    );
  }

  Widget _buildCardAlergias(BuildContext context) {
    return _cardBase(
      context: context,
      icon: Icons.healing_rounded,
      iconColor: CoresApp.warning,
      iconBg: CoresApp.warning.withValues(alpha: 0.15),
      titulo: 'Alergias',
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip(context, 'Dipirona', CoresApp.warning),
            _chip(context, 'Penicilina', CoresApp.warning),
            _chip(context, 'Amendoim', CoresApp.warning),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContato(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nomeColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final telColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return _cardBase(
      context: context,
      icon: Icons.contact_phone_rounded,
      iconColor: CoresApp.primary,
      iconBg: CoresApp.primary.withValues(alpha: 0.15),
      titulo: 'Contato de emergência',
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Maria Silva (Mãe)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: nomeColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '(11) 99999-9999',
              style: TextStyle(fontSize: 13, color: telColor),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _ligar(context, '+5511999999999'),
                icon: const Icon(Icons.phone_rounded, size: 18),
                label: const Text(
                  'Ligar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.primary,
                  foregroundColor: CoresApp.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPlano(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textoColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return _cardBase(
      context: context,
      icon: Icons.medical_services_rounded,
      iconColor: CoresApp.info,
      iconBg: CoresApp.info.withValues(alpha: 0.15),
      titulo: 'Plano de saúde',
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'Unimed — Carteira 12345',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textoColor,
          ),
        ),
      ),
    );
  }

  Widget _cardBase({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String titulo,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: tituloColor,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String texto, Color cor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: isDark ? 0.20 : 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: cor,
        ),
      ),
    );
  }
}
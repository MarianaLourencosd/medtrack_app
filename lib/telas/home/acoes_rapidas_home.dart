import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class AcoesRapidasHome extends StatelessWidget {
  final Function(String) onNavigate;

  const AcoesRapidasHome({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações rápidas',
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Acesse funções importantes em poucos toques',
            style:
                AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
          ),
          const SizedBox(height: 13),
          _buildActionsCard(context),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: CoresApp.black.withValues(alpha: isDark ? 0.25 : 0.045),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                color: CoresApp.mint.withValues(alpha: isDark ? 0.15 : 0.65),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color:
                    CoresApp.paleGreen.withValues(alpha: isDark ? 0.15 : 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Icons.qr_code_rounded,
                        label: 'QR Code',
                        color: CoresApp.primary,
                        background: CoresApp.mint,
                        route: 'QR Code',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Icons.share_rounded,
                        label: 'Compartilhar',
                        color: CoresApp.info,
                        background: CoresApp.softBlue,
                        route: 'Compartilhar',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Icons.notifications_rounded,
                        label: 'Lembretes',
                        color: CoresApp.warning,
                        background: CoresApp.softYellow,
                        route: 'Lembretes',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Icons.picture_as_pdf_rounded,
                        label: 'PDF',
                        color: CoresApp.error,
                        background: CoresApp.softRed,
                        route: 'PDF',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Color background,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isDark ? CoresApp.darkSurfaceAlt : CoresApp.white;
    final labelColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(route),
        borderRadius: BorderRadius.circular(20),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Container(
          height: 112,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: itemColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? CoresApp.darkBorder
                  : color.withValues(alpha: 0.10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: labelColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
    final tituloColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [CoresApp.primaryDark, CoresApp.primaryDark.withValues(alpha: 0.5)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ações rápidas',
                  style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: CoresApp.primaryDark.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Acesse funções importantes em poucos toques',
                    style: AppTextStyles.micro.copyWith(
                      color: subtituloColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: CoresApp.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                color: CoresApp.mint.withValues(alpha: isDark ? 0.10 : 0.50),
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
                color: CoresApp.paleGreen.withValues(alpha: isDark ? 0.10 : 0.60),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
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
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isDark ? CoresApp.darkSurfaceAlt : CoresApp.white;
    final labelColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(route),
        borderRadius: BorderRadius.circular(18),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Container(
          height: 108,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: itemColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
            ),
            boxShadow: [
              BoxShadow(
                color: CoresApp.black.withValues(alpha: isDark ? 0.15 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: labelColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_rounded, color: color, size: 14),
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
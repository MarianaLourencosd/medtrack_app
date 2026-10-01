import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class RecursosHome extends StatelessWidget {
  final bool isLoggedIn;
  final Function(String) onNavigate;

  const RecursosHome({
    super.key,
    required this.isLoggedIn,
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
            'Recursos',
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Ferramentas úteis para o dia a dia',
            style:
                AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
          ),
          const SizedBox(height: 13),
          _buildResourcesCard(context),
        ],
      ),
    );
  }

  Widget _buildResourcesCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: CoresApp.primary.withValues(alpha: isDark ? 0.18 : 0.08),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -45,
            right: -30,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                color: CoresApp.mint.withValues(alpha: isDark ? 0.18 : 0.85),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -35,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color:
                    CoresApp.softGreen.withValues(alpha: isDark ? 0.18 : 0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResourceItem(
                  context: context,
                  icon: Icons.fitness_center_rounded,
                  label: 'IMC',
                  description: 'Acompanhe seu índice corporal',
                  color: CoresApp.primary,
                  background: CoresApp.mint,
                  route: 'IMC',
                ),
                const SizedBox(height: 9),
                _buildResourceItem(
                  context: context,
                  icon: Icons.emergency_rounded,
                  label: 'Emergência',
                  description: 'Tenha acesso rápido à emergência',
                  color: CoresApp.error,
                  background: CoresApp.softRed,
                  route: 'Emergência',
                ),
                const SizedBox(height: 9),
                _buildResourceItem(
                  context: context,
                  icon: Icons.local_hospital_rounded,
                  label: 'Hospitais',
                  description: 'Encontre informações de hospitais',
                  color: CoresApp.info,
                  background: CoresApp.softBlue,
                  route: 'Hospitais',
                ),
                const SizedBox(height: 9),
                _buildResourceItem(
                  context: context,
                  icon: Icons.phone_rounded,
                  label: 'Contato',
                  description: 'Acesse seus contatos importantes',
                  color: CoresApp.secondary,
                  background: CoresApp.paleGreen,
                  route: 'Contato',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required Color background,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isDark ? CoresApp.darkSurfaceAlt : CoresApp.white;
    final labelColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final descColor = isDark ? CoresApp.darkTextMuted : CoresApp.textMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(route),
        borderRadius: BorderRadius.circular(19),
        splashColor: CoresApp.primary.withValues(alpha: 0.06),
        highlightColor: CoresApp.primary.withValues(alpha: 0.03),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: itemColor,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: isDark
                  ? CoresApp.darkBorder
                  : color.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: labelColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: descColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.chevron_right_rounded, color: color, size: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class NavegacaoHome extends StatelessWidget {
  final bool isLoggedIn;
  final Function(String) onNavigate;

  const NavegacaoHome({
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
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTituloSecao(
            title: 'Principal',
            action: 'Acessar',
            tituloColor: tituloColor,
            subtituloColor: subtituloColor,
          ),
          const SizedBox(height: 13),
          _buildFormCard(),
        ],
      ),
    );
  }

  Widget _buildTituloSecao({
    required String title,
    required String action,
    required Color tituloColor,
    required Color subtituloColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    AppTextStyles.tituloSecao.copyWith(color: tituloColor),
              ),
            ),
            Text(action, style: AppTextStyles.acaoSecao),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right_rounded,
                color: CoresApp.primary, size: 18),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Preencha seus dados de saúde',
          style: AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Semantics(
      button: true,
      label: 'Formulário de saúde. Preencha seus dados de saúde',
      child: Container(
        width: double.infinity,
        height: 132,
        decoration: BoxDecoration(
          color: CoresApp.primary,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: CoresApp.primary.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onNavigate('Formulário'),
            splashColor: CoresApp.white.withValues(alpha: 0.10),
            highlightColor: CoresApp.white.withValues(alpha: 0.05),
            child: Stack(
              children: [
                Positioned(
                  top: -45,
                  right: -25,
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      color: CoresApp.white.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -48,
                  left: 95,
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      color: CoresApp.secondary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: CoresApp.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            color: CoresApp.white, size: 25),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Formulário de saúde',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: CoresApp.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Preencha seus dados e acompanhe seu bem-estar.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                height: 1.35,
                                color: CoresApp.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: CoresApp.white.withValues(alpha: 0.13),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: CoresApp.white, size: 17),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
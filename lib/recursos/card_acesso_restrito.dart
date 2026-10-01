import 'package:flutter/material.dart';

import '../constantes/cores.dart';

class CardAcessoRestrito extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onCadastroTap;

  const CardAcessoRestrito({
    super.key,
    required this.onLoginTap,
    required this.onCadastroTap,
  });

  static Future<void> mostrar(
    BuildContext context, {
    required VoidCallback onLoginTap,
    required VoidCallback onCadastroTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: CoresApp.black.withValues(alpha: 0.55),
      builder: (_) => CardAcessoRestrito(
        onLoginTap: onLoginTap,
        onCadastroTap: onCadastroTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final textColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final mutedColor =
        isDark ? CoresApp.darkTextMuted : CoresApp.textMuted;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: CoresApp.black.withValues(alpha: isDark ? 0.40 : 0.20),
              blurRadius: 24,
              offset: const Offset(0, 10),
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
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: CoresApp.warning.withValues(alpha: isDark ? 0.14 : 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -35,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: CoresApp.primary.withValues(alpha: isDark ? 0.12 : 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isDark
                          ? CoresApp.warning.withValues(alpha: 0.18)
                          : CoresApp.softYellow,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CoresApp.warning.withValues(alpha: 0.30),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: CoresApp.warning,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Acesso restrito',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: tituloColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Você precisa estar logado para acessar este recurso.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onLoginTap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoresApp.primary,
                        foregroundColor: CoresApp.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Fazer login',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onCadastroTap();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: CoresApp.primary,
                        side: BorderSide(
                          color: CoresApp.primary.withValues(alpha: 0.30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add_alt_1_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Agora não',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
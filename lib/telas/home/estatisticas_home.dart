import 'package:flutter/material.dart';

import '../../constantes/cores.dart';

class EstatisticasHome extends StatelessWidget {
  const EstatisticasHome({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkSurface : CoresApp.primaryDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CoresApp.primaryDark.withValues(alpha: isDark ? 0.25 : 0.20),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -55,
              right: -30,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  color: CoresApp.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -65,
              left: 75,
              child: Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  color: CoresApp.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildItem(
                    number: '700+',
                    label: 'Vidas salvas',
                    icon: Icons.favorite_rounded,
                  ),
                ),
                Container(
                  width: 1,
                  height: 52,
                  color: CoresApp.white.withValues(alpha: 0.20),
                ),
                Expanded(
                  child: _buildItem(
                    number: '3s',
                    label: 'Acesso rápido',
                    icon: Icons.bolt_rounded,
                  ),
                ),
                Container(
                  width: 1,
                  height: 52,
                  color: CoresApp.white.withValues(alpha: 0.20),
                ),
                Expanded(
                  child: _buildItem(
                    number: '98%',
                    label: 'Sucesso',
                    icon: Icons.check_circle_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String number,
    required String label,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: CoresApp.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CoresApp.white.withValues(alpha: 0.20),
              width: 1,
            ),
          ),
          child: Icon(icon, color: CoresApp.white, size: 19),
        ),
        const SizedBox(height: 10),
        Text(
          number,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: CoresApp.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 10,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: CoresApp.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
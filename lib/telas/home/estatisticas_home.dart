import 'package:flutter/material.dart';

import '../../constantes/cores.dart';

class EstatisticasHome extends StatelessWidget {
  const EstatisticasHome({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkSurface : CoresApp.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: CoresApp.primary.withValues(alpha: isDark ? 0.22 : 0.18),
              blurRadius: 17,
              offset: const Offset(0, 7),
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
                  color: CoresApp.white.withValues(alpha: 0.07),
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
                  color: CoresApp.secondary.withValues(alpha: 0.12),
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
                  height: 48,
                  color: CoresApp.white.withValues(alpha: 0.16),
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
                  height: 48,
                  color: CoresApp.white.withValues(alpha: 0.16),
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
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: CoresApp.white.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: CoresApp.white, size: 17),
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: CoresApp.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 9.5,
            height: 1.2,
            color: CoresApp.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}
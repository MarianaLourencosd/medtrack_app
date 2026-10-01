import 'package:flutter/material.dart';

import '../../constantes/cores.dart';

class RodapeHome extends StatelessWidget {
  final Function(String) onNavigate;

  const RodapeHome({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkSurface : CoresApp.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 24),
      color: bg,
      child: Column(
        children: [
          _buildBrand(),
          const SizedBox(height: 22),
          _buildSocials(),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            height: 1,
            color: CoresApp.white.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 19),
          _buildLinks(),
          const SizedBox(height: 19),
          Text(
            '© 2025 MedTrack — Saúde digital com inteligência.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: CoresApp.white.withValues(alpha: 0.68),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: CoresApp.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/logo-claro.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'MedTrack',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: CoresApp.white,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildSocials() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.facebook_rounded, 'Facebook'),
        const SizedBox(width: 14),
        _buildSocialIcon(Icons.camera_alt_rounded, 'Instagram'),
        const SizedBox(width: 14),
        _buildSocialIcon(Icons.play_circle_fill_rounded, 'YouTube'),
        const SizedBox(width: 14),
        _buildSocialIcon(Icons.close_rounded, 'Twitter'),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String route) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: CoresApp.white.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: CoresApp.white, size: 22),
      ),
    );
  }

  Widget _buildLinks() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        _buildLink('Home', 'Home'),
        _buildLink('Sobre', 'Sobre'),
        _buildLink('Login', 'Login'),
        _buildLink('Cadastro', 'Cadastro'),
      ],
    );
  }

  Widget _buildLink(String text, String route) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: CoresApp.white.withValues(alpha: 0.90),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../constantes/cores.dart';

class RodapeHome extends StatelessWidget {
  final Function(String) onNavigate;

  const RodapeHome({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkSurface : CoresApp.primaryDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 30, 18, 24),
      color: bg,
      child: Column(
        children: [
          _buildBrand(),
          const SizedBox(height: 22),
          _buildSocials(),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 1,
            color: CoresApp.white.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 20),
          _buildLinks(),
          const SizedBox(height: 20),
          Text(
            '© 2025 MedTrack — Saúde digital com inteligência.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: CoresApp.white.withValues(alpha: 0.70),
              fontWeight: FontWeight.w500,
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
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: CoresApp.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CoresApp.white.withValues(alpha: 0.20),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: CoresApp.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/logo-claro.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'MedTrack',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            color: CoresApp.white,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Saúde digital com inteligência',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: CoresApp.white.withValues(alpha: 0.70),
            letterSpacing: 0.2,
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
        const SizedBox(width: 12),
        _buildSocialIcon(Icons.camera_alt_rounded, 'Instagram'),
        const SizedBox(width: 12),
        _buildSocialIcon(Icons.play_circle_fill_rounded, 'YouTube'),
        const SizedBox(width: 12),
        _buildSocialIcon(Icons.close_rounded, 'Twitter'),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String route) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: CoresApp.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(
            color: CoresApp.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Icon(icon, color: CoresApp.white, size: 22),
      ),
    );
  }

  Widget _buildLinks() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 28,
      runSpacing: 14,
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
          color: CoresApp.white.withValues(alpha: 0.92),
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HomeFooter extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeFooter({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.primary,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'MedTrack',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.facebook, 'Facebook'),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.camera_alt, 'Instagram'),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.play_circle_filled, 'YouTube'),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.close, 'Twitter'),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _buildLink('Home', 'Home'),
              _buildLink('Sobre', 'Sobre'),
              _buildLink('Login', 'Login'),
              _buildLink('Cadastro', 'Cadastro'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 MedTrack — Saúde digital com inteligência.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String route) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLink(String text, String route) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
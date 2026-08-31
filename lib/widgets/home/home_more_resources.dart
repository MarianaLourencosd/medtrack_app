import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../shared/resource_card.dart';

class HomeMoreResources extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeMoreResources({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Mais recursos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '4 recursos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ResourceCard(
              icon: Icons.bloodtype,
              title: 'Meu Tipo Sanguíneo',
              description: 'A+, O-, AB+, etc.',
              color: Colors.red.shade300,
              onTap: () => onNavigate('Tipo Sanguíneo'),
            ),
            const SizedBox(height: 10),
            ResourceCard(
              icon: Icons.healing,
              title: 'Minhas Alergias',
              description: 'Registre suas alergias',
              color: Colors.pink,
              onTap: () => onNavigate('Alergias'),
            ),
            const SizedBox(height: 10),
            ResourceCard(
              icon: Icons.medical_services,
              title: 'Meu Plano de Saúde',
              description: 'Dados do seu convênio',
              color: Colors.blue,
              onTap: () => onNavigate('Plano de Saúde'),
            ),
            const SizedBox(height: 10),
            ResourceCard(
              icon: Icons.person,
              title: 'Meu Perfil',
              description: 'Visualize seus dados',
              color: AppColors.secondary,
              onTap: () => onNavigate('Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
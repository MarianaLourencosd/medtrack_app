import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../shared/resource_card.dart';

class HomeResources extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeResources({
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
                    Icons.favorite,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Recursos',
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
              icon: Icons.monitor_weight,
              title: 'Calcular IMC',
              description: 'Descubra seu Índice de Massa Corporal',
              color: Colors.teal,
              onTap: () => onNavigate('IMC'),
            ),
            const SizedBox(height: 10),
            ResourceCard(
              icon: Icons.emergency,
              title: 'Emergência',
              description: 'Contatos e números importantes',
              color: Colors.red,
              onTap: () => onNavigate('Emergência'),
            ),
            const SizedBox(height: 10),
            ResourceCard(
              icon: Icons.local_hospital,
              title: 'Hospitais Próximos',
              description: 'Encontre hospitais perto de você',
              color: AppColors.primary,
              onTap: () => onNavigate('Hospitais'),
            ),
            const SizedBox(height: 10),
            ResourceCard(
              icon: Icons.phone,
              title: 'Contato de Emergência',
              description: 'Adicione ou veja seus contatos',
              color: Colors.orange,
              onTap: () => onNavigate('Contato'),
            ),
          ],
        ),
      ),
    );
  }
}
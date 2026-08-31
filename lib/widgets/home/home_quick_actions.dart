import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HomeQuickActions extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeQuickActions({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                    Icons.flash_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ações rápidas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '4 ações',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.qr_code,
                    label: 'QR Code',
                    color: AppColors.primary,
                    route: 'QR Code',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.share,
                    label: 'Compartilhar',
                    color: Colors.orange,
                    route: 'Compartilhar',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.notifications,
                    label: 'Lembretes',
                    color: Colors.purple,
                    route: 'Lembretes',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.picture_as_pdf,
                    label: 'PDF',
                    color: Colors.redAccent,
                    route: 'PDF',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
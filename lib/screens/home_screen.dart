import 'package:flutter/material.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_navigation.dart';
import '../widgets/home/home_quick_actions.dart';
import '../widgets/home/home_resources.dart';
import '../widgets/home/home_more_resources.dart';
import '../widgets/home/home_testimonials.dart';
import '../widgets/home/home_faq.dart';
import '../widgets/home/home_stats.dart';
import '../widgets/home/home_footer.dart';
import '../widgets/shared/section_title.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../widgets/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, String route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(route),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                Text(
                  'Página "$route" em construção',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Volte para a Home e explore outros recursos!',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('MedTrack'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(context, 'Ajuda'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.help, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(
              onProfileTap: () => _navigateTo(context, 'Perfil'),
            ),
            HomeNavigation(
              onNavigate: (route) => _navigateTo(context, route),
            ),
            HomeQuickActions(
              onNavigate: (route) => _navigateTo(context, route),
            ),
            const SectionTitle(
              title: 'Recursos',
              subtitle: 'Ferramentas úteis para o dia a dia',
            ),
            HomeResources(
              onNavigate: (route) => _navigateTo(context, route),
            ),
            const SectionTitle(
              title: 'Mais recursos',
              subtitle: 'Gerencie sua saúde',
            ),
            HomeMoreResources(
              onNavigate: (route) => _navigateTo(context, route),
            ),
            const SectionTitle(
              title: 'Depoimentos',
              subtitle: 'O que nossos usuários dizem',
            ),
            HomeTestimonials(
              onNavigate: (route) => _navigateTo(context, route),
            ),
            const SectionTitle(
              title: 'Dúvidas Frequentes',
              subtitle: 'Perguntas e respostas',
            ),
            const HomeFAQ(),
            const HomeStats(),
            HomeFooter(
              onNavigate: (route) => _navigateTo(context, route),
            ),
          ],
        ),
      ),
    );
  }
}
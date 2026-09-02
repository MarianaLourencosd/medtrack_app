import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../widgets/cadastro/signup_screen.dart';
import '../widgets/perfil/perfil_screen.dart';
import '../widgets/formulario/formulario_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, String route) {
    final user = FirebaseAuth.instance.currentUser;

    List<String> rotasPublicas = [
      'Home', 'Sobre', 'Login', 'Cadastro',
      'Facebook', 'Instagram', 'YouTube', 'Twitter',
      'Ajuda', 'Contato'
    ];

    if (user == null && !rotasPublicas.contains(route) && route != 'FAQ') {
      _mostrarDialogLogin(context, route);
      return;
    }

    Widget page;

    switch (route) {
      case 'Login':
        page = const LoginScreen();
        break;
      case 'Cadastro':
        page = const SignupScreen();
        break;
      case 'Formulário':
        page = const FormularioScreen();
        break;
      case 'Perfil':
        page = const PerfilScreen();
        break;
      case 'Home':
      case 'Sobre':
      case 'Facebook':
      case 'Instagram':
      case 'YouTube':
      case 'Twitter':
      case 'Ajuda':
      case 'Contato':
      case 'FAQ':
        page = _buildEmConstrucao(context, route);
        break;
      default:
        page = _buildEmConstrucao(context, route);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _mostrarDialogLogin(BuildContext context, String route) {
    String mensagem;
    String botaoTexto;
    VoidCallback acao;

    if (route == 'Login') {
      mensagem = 'Para acessar o Login, você precisa criar uma conta primeiro.';
      botaoTexto = 'Ir para Cadastro';
      acao = () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupScreen()),
        );
      };
    } else if (route == 'Formulário' || route == 'Perfil') {
      mensagem = 'Para acessar o Formulário, você precisa estar logado.\n\nCrie uma conta ou faça login.';
      botaoTexto = 'Ir para Login';
      acao = () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      };
    } else {
      mensagem = 'Você precisa estar logado para acessar esta página.\n\nFaça login ou crie uma conta.';
      botaoTexto = 'Fazer Login';
      acao = () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      };
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('🔒 Acesso Restrito'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: acao,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(botaoTexto),
          ),
        ],
      ),
    );
  }

  Widget _buildEmConstrucao(BuildContext context, String route) {
    return Scaffold(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-claro.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'MedTrack',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
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
        onPressed: () => _navigateTo(context, 'Emergência'),
        backgroundColor: Colors.red,
        elevation: 8,
        child: const Icon(Icons.emergency, color: Colors.white, size: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(
              onProfileTap: () => _navigateTo(context, 'Perfil'),
            ),
            HomeNavigation(
              isLoggedIn: isLoggedIn,
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
              isLoggedIn: isLoggedIn,
              onNavigate: (route) => _navigateTo(context, route),
            ),
            const SectionTitle(
              title: 'Mais recursos',
              subtitle: 'Gerencie sua saúde',
            ),
            HomeMoreResources(
              isLoggedIn: isLoggedIn,
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
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cabecalho_inicio.dart';
import 'navegacao_home.dart';
import 'acoes_rapidas_home.dart';
import 'recursos_home.dart';
import 'mais_recursos_home.dart';
import 'depoimentos_home.dart';
import 'home_faq.dart';
import 'estatisticas_home.dart';
import 'home_footer.dart';
import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../constantes/tema_app.dart';
import '../../servicos/servico_autenticacao.dart';
import '../../recursos/telas_em_construcao.dart';
import '../../recursos/card_acesso_restrito.dart';
import '../../recursos/menu_acessibilidade.dart';
import '../login/login_screen.dart';
import '../cadastro/signup_screen.dart';
import '../perfil/perfil_screen.dart';
import '../formulario/formulario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nomeUsuario = '';

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      if (mounted) setState(() => _nomeUsuario = user.displayName!.trim());
      return;
    }
    try {
      final usuario = await ServicoAutenticacao().getUsuario(user.uid);
      if (usuario != null && usuario['nome'] != null) {
        if (mounted) {
          setState(() => _nomeUsuario = usuario['nome'].toString().trim());
        }
      }
    } catch (_) {}
  }

  void _verificarAcesso(BuildContext context, String route) {
    final user = FirebaseAuth.instance.currentUser;

    if (route == 'Home') {
      Navigator.popUntil(context, (r) => r.isFirst);
      return;
    }

    if (user != null && (route == 'Login' || route == 'Cadastro')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você já está logado.'),
          backgroundColor: CoresApp.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    const rotasPublicas = [
      'Home', 'Sobre', 'Login', 'Cadastro',
      'Facebook', 'Instagram', 'YouTube', 'Twitter',
      'Ajuda', 'Contato', 'FAQ',
    ];

    if (user == null && !rotasPublicas.contains(route)) {
      CardAcessoRestrito.mostrar(
        context,
        onLoginTap: () => _navigateTo(context, 'Login'),
        onCadastroTap: () => _navigateTo(context, 'Cadastro'),
      );
      return;
    }

    _navigateTo(context, route);
  }

  void _navigateTo(BuildContext context, String route) {
    final Widget page = _buildPage(context, route);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildPage(BuildContext context, String route) {
    switch (route) {
      case 'Login':
        return const TelaLogin();
      case 'Cadastro':
        return const TelaCadastro();
      case 'Formulário':
        return const TelaFormulario();
      case 'Perfil':
        return const TelaPerfil();
      case 'Emergência':
        return const TelaEmergencia();
      case 'Medicamentos':
        return const TelaMedicamentos();
      case 'Informações':
        return const TelaInformacoes();
      case 'Carteira':
        return const TelaCarteira();
      case 'QR Code':
        return const TelaQrCode();
      case 'Compartilhar':
        return const TelaCompartilhar();
      case 'Lembretes':
        return const TelaLembretes();
      case 'PDF':
        return const TelaPdf();
      case 'IMC':
        return const TelaImc();
      case 'Hospitais':
        return const TelaHospitais();
      case 'Contato':
        return const TelaContato();
      case 'Tipo Sanguíneo':
        return const TelaTipoSanguineo();
      case 'Alergias':
        return const TelaAlergias();
      case 'Plano de Saúde':
        return const TelaPlanoSaude();
      case 'Sobre':
        return const TelaSobre();
      case 'Ajuda':
        return const TelaAjuda();
      case 'Facebook':
        return const TelaFacebook();
      case 'Instagram':
        return const TelaInstagram();
      case 'YouTube':
        return const TelaYouTube();
      case 'Twitter':
        return const TelaTwitter();
      default:
        return _buildEmConstrucao(context, route);
    }
  }

  Widget _buildEmConstrucao(BuildContext context, String route) {
    return Scaffold(
      appBar: AppBar(title: Text(route)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: CoresApp.primary),
            const SizedBox(height: 20),
            Text('Página "$route" em construção',
                style: AppTextStyles.tituloTela),
            const SizedBox(height: 10),
            Text('Volte para a Home e explore outros recursos!',
                style: AppTextStyles.textoCorpoSecundario),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar', style: AppTextStyles.botao),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(isLoggedIn, isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CabecalhoInicio(
              nomeUsuario: _nomeUsuario,
              isLoggedIn: isLoggedIn,
              onProfileTap: () => _verificarAcesso(context, 'Perfil'),
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
            NavegacaoHome(
              isLoggedIn: isLoggedIn,
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
            AcoesRapidasHome(
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
            RecursosHome(
              isLoggedIn: isLoggedIn,
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
            MaisRecursosHome(
              isLoggedIn: isLoggedIn,
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
            DepoimentosHome(
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
            const FAQHome(),
            const EstatisticasHome(),
            RodapeHome(
              onNavigate: (route) => _verificarAcesso(context, route),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isLoggedIn, bool isDark) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/images/logo-claro.png',
              width: 32, height: 32, fit: BoxFit.contain),
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
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        _botaoTopo(
          isDark: isDark,
          icon: Icons.accessibility_new_rounded,
          tooltip: 'Acessibilidade',
          onTap: () => MenuAcessibilidade.abrir(context),
        ),
        const SizedBox(width: 6),
        _botaoTopo(
          isDark: isDark,
          icon: isDark
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          tooltip: isDark ? 'Modo claro' : 'Modo escuro',
          onTap: TemaController.alternar,
        ),
        const SizedBox(width: 6),
        if (isLoggedIn)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await ServicoAutenticacao().logout();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TelaLogin()),
              );
            },
          ),
      ],
    );
  }

  Widget _botaoTopo({
    required bool isDark,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Material(
        color: isDark
            ? CoresApp.darkSurfaceAlt
            : Colors.white.withValues(alpha: 0.20),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Tooltip(
            message: tooltip,
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
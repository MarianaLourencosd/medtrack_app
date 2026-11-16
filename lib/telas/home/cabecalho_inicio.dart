import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constantes/cores.dart';
import '../../../constantes/estilos_texto.dart';
import 'busca_inicio.dart';

class CabecalhoInicio extends StatelessWidget {
  final String nomeUsuario;
  final bool isLoggedIn;
  final VoidCallback onProfileTap;
  final Function(String) onNavigate;

  const CabecalhoInicio({
    super.key,
    required this.nomeUsuario,
    required this.isLoggedIn,
    required this.onProfileTap,
    required this.onNavigate,
  });

  static const String _imagePath = 'assets/images/fundo-header.svg';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Espacamentos.paddingTela,
        topPadding + 14,
        Espacamentos.paddingTela,
        30,
      ),
      decoration: BoxDecoration(
        color: isDark ? CoresApp.darkSurface : CoresApp.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(Espacamentos.bordaEnorme),
          bottomRight: Radius.circular(Espacamentos.bordaEnorme),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImage(context),
          const SizedBox(height: 22),
          _buildTopBar(context),
          const SizedBox(height: 20),
          BuscaInicio(onNavigate: (route) => onNavigate(route)),
          const SizedBox(height: 26),
          _buildQuickAccess(context),
          const SizedBox(height: 30),
          _buildSectionTitle(
            context: context,
            title: 'Recursos',
            action: 'Ver tudo',
          ),
          const SizedBox(height: 14),
          _buildHealthCards(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: Espacamentos.alturaImagemTopo,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [CoresApp.darkSurfaceAlt, CoresApp.darkSurface]
              : [CoresApp.primary, CoresApp.primaryDark],
        ),
        borderRadius: BorderRadius.circular(Espacamentos.bordaExtraGrande),
        boxShadow: [
          BoxShadow(
            color: CoresApp.primaryDark.withValues(alpha: isDark ? 0.30 : 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              _imagePath,
              fit: BoxFit.cover,
              semanticsLabel: 'Imagem de saúde',
              placeholderBuilder: (context) => const Center(
                child: Icon(Icons.health_and_safety_rounded, color: CoresApp.white, size: 60),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.30),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _PontoPulsante(),
                  SizedBox(width: 6),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: CoresApp.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CoresApp.primaryDark.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.favorite_rounded, color: CoresApp.primaryDark, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sua saúde em boas mãos',
                          style: TextStyle(
                            color: CoresApp.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Cuide de você todos os dias',
                          style: TextStyle(
                            color: CoresApp.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: CoresApp.primaryDark.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: CoresApp.primaryDark, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final secondaryColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: CoresApp.primaryDark.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconeSaudacao(),
                    color: CoresApp.primaryDark,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _saudacaoPorHorario().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: CoresApp.primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Olá, ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            Flexible(
              child: Text(
                _nomeExibicao(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                  height: 1.2,
                  letterSpacing: -0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: CoresApp.primaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Vamos cuidar de você hoje?',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _iconeSaudacao() {
    final hora = DateTime.now().hour;
    if (hora < 12) return Icons.wb_sunny_rounded;
    if (hora < 18) return Icons.wb_twilight_rounded;
    return Icons.nightlight_round;
  }

  String _saudacaoPorHorario() {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String _nomeExibicao() {
    final nome = nomeUsuario.trim();
    if (nome.isEmpty) return 'Bem-vindo';
    return nome.split(' ').first;
  }

  Widget _buildQuickAccess(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: CoresApp.primaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Acesso rápido',
                style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: CoresApp.primaryDark,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Acesse sua conta ou explore o app',
                  style: AppTextStyles.micro.copyWith(
                    color: subtituloColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickItem(
              icon: Icons.login_rounded,
              title: 'Login',
              cor: CoresApp.success,
              onTap: () => onNavigate('Login'),
            ),
            _QuickItem(
              icon: Icons.person_add_alt_1_rounded,
              title: 'Cadastro',
              cor: CoresApp.primary,
              onTap: () => onNavigate('Cadastro'),
            ),
            _QuickItem(
              icon: Icons.person_rounded,
              title: 'Perfil',
              cor: CoresApp.info,
              onTap: () => onNavigate('Perfil'),
            ),
            _QuickItem(
              icon: Icons.emergency_rounded,
              title: 'Emergência',
              cor: CoresApp.error,
              onTap: () => onNavigate('Emergência'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle({
    required BuildContext context,
    required String title,
    required String action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: CoresApp.primaryDark,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
        ),
        GestureDetector(
          onTap: () => onNavigate(title),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CoresApp.primaryDark.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Text(
                  action,
                  style: AppTextStyles.micro.copyWith(
                    color: CoresApp.primaryDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right_rounded, color: CoresApp.primaryDark, size: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCards() {
    return SizedBox(
      height: Espacamentos.alturaCardHorizontal,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _healthCard(
            title: 'Medicamentos',
            subtitle: 'Seus remédios',
            icon: Icons.medication_rounded,
            background: CoresApp.primary,
            route: 'Medicamentos',
          ),
          const SizedBox(width: 12),
          _healthCard(
            title: 'Informações',
            subtitle: 'Dados de saúde',
            icon: Icons.description_rounded,
            background: CoresApp.secondary,
            route: 'Informações',
          ),
          const SizedBox(width: 12),
          _healthCard(
            title: 'Emergência',
            subtitle: 'Contatos rápidos',
            icon: Icons.emergency_rounded,
            background: CoresApp.primaryLight,
            route: 'Emergência',
          ),
          const SizedBox(width: 12),
          _healthCard(
            title: 'Carteira',
            subtitle: 'Documentos',
            icon: Icons.badge_rounded,
            background: CoresApp.primaryDark,
            route: 'Carteira',
          ),
        ],
      ),
    );
  }

  Widget _healthCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color background,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => onNavigate(route),
      child: Container(
        width: Espacamentos.larguraCardHorizontal,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [background, background.withValues(alpha: 0.80)],
          ),
          borderRadius: BorderRadius.circular(Espacamentos.bordaExtraGrande),
          boxShadow: [
            BoxShadow(
              color: background.withValues(alpha: 0.30),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: CoresApp.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: 18,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: CoresApp.white.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Espacamentos.paddingCard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: CoresApp.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(Espacamentos.bordaMedia),
                      border: Border.all(
                        color: CoresApp.white.withValues(alpha: 0.30),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, color: CoresApp.white, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.tituloCardEscuro.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtituloCardEscuro.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PontoPulsante extends StatefulWidget {
  const _PontoPulsante();

  @override
  State<_PontoPulsante> createState() => _PontoPulsanteState();
}

class _PontoPulsanteState extends State<_PontoPulsante>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: 7 + (_controller.value * 2),
          height: 7 + (_controller.value * 2),
          decoration: BoxDecoration(
            color: CoresApp.success,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CoresApp.success.withValues(alpha: 0.3 + _controller.value * 0.3),
                blurRadius: 6 + _controller.value * 4,
                spreadRadius: _controller.value * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color cor;
  final VoidCallback onTap;

  const _QuickItem({
    required this.icon,
    required this.title,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final cardColor = isDark ? CoresApp.darkSurfaceAlt : CoresApp.surface;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: CoresApp.black.withValues(alpha: isDark ? 0.15 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: cor, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
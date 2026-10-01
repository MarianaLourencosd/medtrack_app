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
          _buildHeaderImage(),
          const SizedBox(height: Espacamentos.grande),
          _buildTopBar(context),
          const SizedBox(height: Espacamentos.normal),
          BuscaInicio(onNavigate: (route) => onNavigate(route)),
          const SizedBox(height: Espacamentos.extraGrande),
          _buildQuickAccess(context),
          const SizedBox(height: Espacamentos.enorme),
          _buildSectionTitle(
            context: context,
            title: 'Recursos',
            action: 'Ver tudo',
          ),
          const SizedBox(height: Espacamentos.medio),
          _buildHealthCards(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      width: double.infinity,
      height: Espacamentos.alturaImagemTopo,
      decoration: BoxDecoration(
        color: CoresApp.primaryDark,
        borderRadius: BorderRadius.circular(Espacamentos.bordaExtraGrande),
        boxShadow: [
          BoxShadow(
            color: CoresApp.primaryDark.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SvgPicture.asset(
        _imagePath,
        fit: BoxFit.cover,
        semanticsLabel: 'Imagem de saúde',
        placeholderBuilder: (context) => const Center(
          child: Icon(
            Icons.health_and_safety_rounded,
            color: CoresApp.white,
            size: 60,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? CoresApp.darkTextPrimary
        : CoresApp.textPrimary;
    final secondaryColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _saudacaoPorHorario(),
          style: AppTextStyles.subtituloSaudacao.copyWith(
            color: secondaryColor,
          ),
        ),
        const SizedBox(height: Espacamentos.micro),
        Text(
          _nomeExibicao(),
          style: AppTextStyles.saudacao.copyWith(color: primaryColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _saudacaoPorHorario() {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia,';
    if (hora < 18) return 'Boa tarde,';
    return 'Boa noite,';
  }

  String _nomeExibicao() {
    final nome = nomeUsuario.trim();
    if (nome.isEmpty) return 'Bem-vindo de volta';
    return nome.split(' ').first;
  }

  Widget _buildQuickAccess(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor = isDark
        ? CoresApp.darkTextPrimary
        : CoresApp.textPrimary;
    final subtituloColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acesso rápido',
          style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Acesse sua conta ou explore o app',
          style: AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
        ),
        const SizedBox(height: Espacamentos.medio),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _quickItem(
              context: context,
              icon: Icons.login_rounded,
              title: 'Login',
              background: CoresApp.mint,
              route: 'Login',
            ),
            _quickItem(
              context: context,
              icon: Icons.person_add_alt_1_rounded,
              title: 'Cadastro',
              background: CoresApp.paleGreen,
              route: 'Cadastro',
            ),
            _quickItem(
              context: context,
              icon: Icons.person_rounded,
              title: 'Perfil',
              background: CoresApp.softBlue,
              route: 'Perfil',
            ),
            _quickItem(
              context: context,
              icon: Icons.emergency_rounded,
              title: 'Emergência',
              background: CoresApp.softRed,
              route: 'Emergência',
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color background,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: () => onNavigate(route),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CoresApp.black.withValues(
                      alpha: isDark ? 0.25 : 0.04,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: CoresApp.primary, size: 24),
            ),
            const SizedBox(height: Espacamentos.pequeno),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelCategoria.copyWith(color: labelColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required BuildContext context,
    required String title,
    required String action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor = isDark
        ? CoresApp.darkTextPrimary
        : CoresApp.textPrimary;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
        ),
        GestureDetector(
          onTap: () => onNavigate(title),
          child: Row(
            children: [
              Text(action, style: AppTextStyles.acaoSecao),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right_rounded,
                color: CoresApp.primary,
                size: 20,
              ),
            ],
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
          const SizedBox(width: Espacamentos.medio),
          _healthCard(
            title: 'Informações',
            subtitle: 'Dados de saúde',
            icon: Icons.description_rounded,
            background: CoresApp.secondary,
            route: 'Informações',
          ),
          const SizedBox(width: Espacamentos.medio),
          _healthCard(
            title: 'Emergência',
            subtitle: 'Contatos rápidos',
            icon: Icons.emergency_rounded,
            background: CoresApp.primaryLight,
            route: 'Emergência',
          ),
          const SizedBox(width: Espacamentos.medio),
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
          color: background,
          borderRadius: BorderRadius.circular(Espacamentos.bordaExtraGrande),
          boxShadow: [
            BoxShadow(
              color: background.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -35,
              right: -25,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: CoresApp.white.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: 22,
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: CoresApp.white.withValues(alpha: 0.06),
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: CoresApp.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(
                        Espacamentos.bordaMedia,
                      ),
                    ),
                    child: Icon(icon, color: CoresApp.white, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.tituloCardEscuro,
                  ),
                  const SizedBox(height: Espacamentos.micro),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtituloCardEscuro,
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

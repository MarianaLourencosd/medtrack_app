import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class _Depoimento {
  final String name;
  final String text;
  final Color color;

  const _Depoimento({
    required this.name,
    required this.text,
    required this.color,
  });
}

class DepoimentosHome extends StatefulWidget {
  final Function(String) onNavigate;

  const DepoimentosHome({super.key, required this.onNavigate});

  @override
  State<DepoimentosHome> createState() => _DepoimentosHomeState();
}

class _DepoimentosHomeState extends State<DepoimentosHome> {
  final PageController _controller = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  static const List<_Depoimento> _testimonials = [
    _Depoimento(
      name: 'Renato Souza',
      text: 'Melhorou muito nossa comunicação com pacientes.',
      color: CoresApp.primary,
    ),
    _Depoimento(
      name: 'Camila Duarte',
      text: 'Atendimento rápido e informações confiáveis.',
      color: CoresApp.secondary,
    ),
    _Depoimento(
      name: 'Lucas Almeida',
      text: 'Tecnologia aplicada com responsabilidade.',
      color: CoresApp.info,
    ),
    _Depoimento(
      name: 'Juliana Alves',
      text: 'Em emergências, fez toda diferença!',
      color: CoresApp.softPurple,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Depoimentos',
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
          const SizedBox(height: 4),
          Text(
            'O que nossos usuários dizem',
            style:
                AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
          ),
          const SizedBox(height: 13),
          _buildCard(context),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final itens = _testimonials;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: CoresApp.black.withValues(alpha: isDark ? 0.25 : 0.045),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 164,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index),
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final item = itens[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildTestimonial(
                    context: context,
                    name: item.name,
                    text: item.text,
                    color: item.color,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildIndicators(context, itens.length),
        ],
      ),
    );
  }

  Widget _buildTestimonial({
    required BuildContext context,
    required String name,
    required String text,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarColor =
        color == CoresApp.softPurple ? CoresApp.primaryLight : color;
    final cardBg = isDark ? CoresApp.darkSurfaceAlt : CoresApp.background;
    final nameColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final textColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final inicial =
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: isDark
              ? CoresApp.darkBorder
              : avatarColor.withValues(alpha: 0.12),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -35,
            right: -28,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: isDark ? 0.10 : 0.055),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withValues(alpha: 0.18),
                          blurRadius: 9,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        inicial,
                        style: const TextStyle(
                          color: CoresApp.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: nameColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List<Widget>.generate(
                            5,
                            (index) => const Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Icon(
                                Icons.star_rounded,
                                color: CoresApp.warning,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.format_quote_rounded,
                    color: CoresApp.secondaryLight,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: isDark ? 0.12 : 0.055),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(BuildContext context, int total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        total,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _currentPage == index ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: _currentPage == index ? CoresApp.primary : inactiveColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
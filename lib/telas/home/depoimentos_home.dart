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
    final tituloColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
      child: Column(
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
                  'Depoimentos',
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
                    'O que nossos usuários dizem',
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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: CoresApp.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
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
    final avatarColor = color == CoresApp.softPurple ? CoresApp.primaryLight : color;
    final cardBg = isDark ? CoresApp.darkSurfaceAlt : CoresApp.background;
    final nameColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final textColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final inicial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
        ),
        boxShadow: [
          BoxShadow(
            color: CoresApp.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -24,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: isDark ? 0.12 : 0.06),
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withValues(alpha: 0.25),
                          blurRadius: 10,
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
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
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: avatarColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.format_quote_rounded,
                      color: avatarColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: isDark ? 0.14 : 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: avatarColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  ),
                ),
                child: Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: textColor,
                    fontWeight: FontWeight.w500,
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
          width: _currentPage == index ? 24 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: _currentPage == index ? CoresApp.primaryDark : inactiveColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
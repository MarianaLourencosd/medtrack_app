import 'package:flutter/material.dart';

import '../constantes/cores.dart';

class ConfigAcessibilidade {
  static final ValueNotifier<double> escalaFonte =
      ValueNotifier<double>(1.0);

  static final ValueNotifier<bool> daltonismo =
      ValueNotifier<bool>(false);

  static final ValueNotifier<bool> altoContraste =
      ValueNotifier<bool>(false);

  static final ValueNotifier<bool> reduzirAnimacoes =
      ValueNotifier<bool>(false);

  static void resetar() {
    escalaFonte.value = 1.0;
    daltonismo.value = false;
    altoContraste.value = false;
    reduzirAnimacoes.value = false;
  }
}

class FiltroDaltonismo {
  static const List<double> protanopia = [
    0.567, 0.433, 0.000, 0, 0,
    0.558, 0.442, 0.000, 0, 0,
    0.000, 0.242, 0.758, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> deuteranopia = [
    0.625, 0.375, 0.000, 0, 0,
    0.700, 0.300, 0.000, 0, 0,
    0.000, 0.300, 0.700, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> tritanopia = [
    0.950, 0.050, 0.000, 0, 0,
    0.000, 0.433, 0.567, 0, 0,
    0.000, 0.475, 0.525, 0, 0,
    0, 0, 0, 1, 0,
  ];
}

class BotaoAcessibilidade extends StatelessWidget {
  final bool isDark;
  final Color? iconColor;

  const BotaoAcessibilidade({
    super.key,
    required this.isDark,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark
          ? CoresApp.darkSurfaceAlt
          : CoresApp.primary.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => MenuAcessibilidade.abrir(context),
        child: Tooltip(
          message: 'Acessibilidade',
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.accessibility_new_rounded,
              color: iconColor ??
                  (isDark ? CoresApp.darkTextPrimary : CoresApp.primary),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuAcessibilidade extends StatelessWidget {
  const MenuAcessibilidade({super.key});

  static Future<void> abrir(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const MenuAcessibilidade(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final textColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CoresApp.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.accessibility_new_rounded,
                      color: CoresApp.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Acessibilidade',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: tituloColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Ajuste o app do jeito que for mais confortável para você.',
                style:
                    TextStyle(fontSize: 13, color: textColor, height: 1.4),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<double>(
                valueListenable: ConfigAcessibilidade.escalaFonte,
                builder: (context, escala, _) {
                  return _LinhaTamanhoFonte(
                    escala: escala,
                    isDark: isDark,
                    tituloColor: tituloColor,
                    textColor: textColor,
                  );
                },
              ),
              const SizedBox(height: 18),
              _LinhaSwitch(
                titulo: 'Modo daltônico',
                subtitulo: 'Aplica filtro para deuteranopia',
                icon: Icons.remove_red_eye_rounded,
                isDark: isDark,
                tituloColor: tituloColor,
                textColor: textColor,
                valueListenable: ConfigAcessibilidade.daltonismo,
              ),
              const SizedBox(height: 10),
              _LinhaSwitch(
                titulo: 'Alto contraste',
                subtitulo: 'Inverte as cores para melhor leitura',
                icon: Icons.contrast_rounded,
                isDark: isDark,
                tituloColor: tituloColor,
                textColor: textColor,
                valueListenable: ConfigAcessibilidade.altoContraste,
              ),
              const SizedBox(height: 10),
              _LinhaSwitch(
                titulo: 'Reduzir animações',
                subtitulo: 'Transições mais rápidas e diretas',
                icon: Icons.animation_rounded,
                isDark: isDark,
                tituloColor: tituloColor,
                textColor: textColor,
                valueListenable: ConfigAcessibilidade.reduzirAnimacoes,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: ConfigAcessibilidade.resetar,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text(
                    'Restaurar padrão',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.primary,
                    side: BorderSide(
                      color: CoresApp.primary.withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinhaTamanhoFonte extends StatelessWidget {
  final double escala;
  final bool isDark;
  final Color tituloColor;
  final Color textColor;

  const _LinhaTamanhoFonte({
    required this.escala,
    required this.isDark,
    required this.tituloColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isDark ? CoresApp.darkSurfaceAlt : CoresApp.greyBackground;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_size_rounded,
                  color: CoresApp.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tamanho da fonte',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: tituloColor,
                  ),
                ),
              ),
              Text(
                '${(escala * 100).round()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: CoresApp.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Ajuste o tamanho dos textos do app',
            style: TextStyle(fontSize: 11.5, color: textColor),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _BotaoControle(
                icon: Icons.remove_rounded,
                onTap: () {
                  final novo = (escala - 0.1).clamp(0.8, 1.6);
                  ConfigAcessibilidade.escalaFonte.value =
                      double.parse(novo.toStringAsFixed(1));
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: CoresApp.primary,
                    inactiveTrackColor:
                        CoresApp.primary.withValues(alpha: 0.20),
                    thumbColor: CoresApp.primary,
                    overlayColor: CoresApp.primary.withValues(alpha: 0.15),
                  ),
                  child: Slider(
                    value: escala.clamp(0.8, 1.6),
                    min: 0.8,
                    max: 1.6,
                    divisions: 8,
                    onChanged: (v) {
                      ConfigAcessibilidade.escalaFonte.value =
                          double.parse(v.toStringAsFixed(1));
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _BotaoControle(
                icon: Icons.add_rounded,
                onTap: () {
                  final novo = (escala + 0.1).clamp(0.8, 1.6);
                  ConfigAcessibilidade.escalaFonte.value =
                      double.parse(novo.toStringAsFixed(1));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BotaoControle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BotaoControle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CoresApp.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, color: CoresApp.primary, size: 18),
        ),
      ),
    );
  }
}

class _LinhaSwitch extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final bool isDark;
  final Color tituloColor;
  final Color textColor;
  final ValueNotifier<bool> valueListenable;

  const _LinhaSwitch({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.isDark,
    required this.tituloColor,
    required this.textColor,
    required this.valueListenable,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isDark ? CoresApp.darkSurfaceAlt : CoresApp.greyBackground;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: valueListenable,
        builder: (context, valor, _) {
          return Row(
            children: [
              Icon(icon, color: CoresApp.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: tituloColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: TextStyle(fontSize: 11, color: textColor),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: valor,
                activeThumbColor: CoresApp.primary,
                activeTrackColor:
                    CoresApp.primary.withValues(alpha: 0.40),
                onChanged: (v) => valueListenable.value = v,
              ),
            ],
          );
        },
      ),
    );
  }
}
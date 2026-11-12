import 'package:flutter/material.dart';

import '../constantes/cores.dart';
import '../constantes/estilos_texto.dart';

/// Configuração de um atalho exibido pela [SecaoAcoesRapidas].
class AcaoRapidaItem {
  const AcaoRapidaItem({
    required this.icone,
    required this.titulo,
    required this.cor,
    required this.fundo,
    required this.aoTocar,
  });

  final IconData icone;
  final String titulo;
  final Color cor;
  final Color fundo;
  final VoidCallback aoTocar;
}

/// Seção reutilizável de ações rápidas.
///
/// O layout mantém o padrão visual da Home: um cartão com brilho suave e
/// atalhos em grade. Em telas estreitas a grade fica 2x2; em telas largas
/// os atalhos são distribuídos em uma única linha.
class SecaoAcoesRapidas extends StatelessWidget {
  const SecaoAcoesRapidas({
    super.key,
    required this.acoes,
    this.titulo = 'Ações rápidas',
    this.subtitulo = 'Acesse funções importantes em poucos toques',
    this.padding = const EdgeInsets.fromLTRB(18, 4, 18, 30),
  });

  final List<AcaoRapidaItem> acoes;
  final String titulo;
  final String subtitulo;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tituloColor = isDark
        ? CoresApp.darkTextPrimary
        : CoresApp.textPrimary;
    final subtituloColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
          ),
          const SizedBox(height: 13),
          _CartaoAcoes(acoes: acoes),
        ],
      ),
    );
  }
}

class _CartaoAcoes extends StatelessWidget {
  const _CartaoAcoes({required this.acoes});

  final List<AcaoRapidaItem> acoes;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: CoresApp.black.withValues(alpha: isDark ? 0.25 : 0.045),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                color: CoresApp.mint.withValues(alpha: isDark ? 0.15 : 0.65),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: CoresApp.paleGreen.withValues(
                  alpha: isDark ? 0.15 : 0.8,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final colunas = constraints.maxWidth >= 620 ? 4 : 2;

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: acoes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: colunas,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 112,
                  ),
                  itemBuilder: (context, indice) {
                    return _AtalhoAcao(acao: acoes[indice]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AtalhoAcao extends StatelessWidget {
  const _AtalhoAcao({required this.acao});

  final AcaoRapidaItem acao;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isDark ? CoresApp.darkSurfaceAlt : CoresApp.white;
    final labelColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Semantics(
      button: true,
      label: acao.titulo,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: acao.aoTocar,
          borderRadius: BorderRadius.circular(20),
          splashColor: acao.cor.withValues(alpha: 0.08),
          highlightColor: acao.cor.withValues(alpha: 0.04),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: itemColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? CoresApp.darkBorder
                    : acao.cor.withValues(alpha: 0.10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: acao.fundo,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(acao.icone, color: acao.cor, size: 21),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        acao.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: labelColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: acao.cor,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

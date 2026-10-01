import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class FAQHome extends StatefulWidget {
  const FAQHome({super.key});

  @override
  State<FAQHome> createState() => _FAQHomeState();
}

class _FAQHomeState extends State<FAQHome> {
  int _aberto = -1;

  static const List<Map<String, String>> _perguntas = [
    {
      'pergunta': 'Como cadastro meus dados de saúde?',
      'resposta':
          'Acesse o Formulário de Saúde na Home e preencha as informações solicitadas. Tudo fica salvo na sua conta.',
    },
    {
      'pergunta': 'Meus dados estão seguros?',
      'resposta':
          'Sim. Utilizamos autenticação do Firebase e criptografia para proteger todas as informações armazenadas.',
    },
    {
      'pergunta': 'Posso acessar em emergências?',
      'resposta':
          'Sim. A opção Emergência mostra seus contatos e dados críticos em poucos toques.',
    },
    {
      'pergunta': 'O app funciona offline?',
      'resposta':
          'Algumas informações ficam em cache e podem ser vistas offline. Para sincronizar alterações é necessário internet.',
    },
  ];

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
            'Perguntas frequentes',
            style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Tire suas dúvidas rápidas',
            style:
                AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
          ),
          const SizedBox(height: 13),
          _buildList(context),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final itens = _perguntas;
    return Column(
      children: List<Widget>.generate(itens.length, (index) {
        final item = itens[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == itens.length - 1 ? 0 : 10,
          ),
          child: _buildItem(
            context: context,
            index: index,
            pergunta: item['pergunta'] ?? '',
            resposta: item['resposta'] ?? '',
          ),
        );
      }),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required String pergunta,
    required String resposta,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final perguntaColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final respostaColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final expandido = _aberto == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _aberto = expandido ? -1 : index);
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: CoresApp.primary.withValues(alpha: 0.06),
        highlightColor: CoresApp.primary.withValues(alpha: 0.03),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: expandido
                  ? CoresApp.primary.withValues(alpha: 0.45)
                  : borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: CoresApp.black.withValues(alpha: isDark ? 0.20 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: CoresApp.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: CoresApp.primary,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pergunta,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: perguntaColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: expandido ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: CoresApp.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 50),
                  child: Text(
                    resposta,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: respostaColor,
                    ),
                  ),
                ),
                crossFadeState: expandido
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
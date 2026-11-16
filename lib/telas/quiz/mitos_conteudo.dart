import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class MitosConteudo extends StatefulWidget {
  final Color tituloColor;

  const MitosConteudo({super.key, required this.tituloColor});

  @override
  State<MitosConteudo> createState() => _MitosConteudoState();
}

class _MitosConteudoState extends State<MitosConteudo> {
  String _filtroAtivo = 'Todos';

  final List<String> _filtros = ['Todos', 'Mitos', 'Verdades'];

  final List<Map<String, dynamic>> _itens = [
    {'mito': 'Manteiga cura queimadura', 'verdade': false, 'categoria': 'Emergência', 'explicacao': 'Nunca passe manteiga, pasta de dente ou álcool em queimaduras. Isso pode infeccionar e piorar a lesão. Lave com água fria corrente por 10 minutos.'},
    {'mito': 'Beber água em jejum emagrece', 'verdade': false, 'categoria': 'Alimentação', 'explicacao': 'Beber água em jejum hidrata o corpo, mas não emagrece por si só. O emagrecimento depende de déficit calórico e hábitos saudáveis.'},
    {'mito': 'Tomar banho quente depois de comer faz mal', 'verdade': false, 'categoria': 'Hábitos', 'explicacao': 'Não há comprovação científica de que banho quente após comer faça mal. Pessoas com problemas cardíacos devem ter cuidado, mas não é regra geral.'},
    {'mito': 'Ovo faz mal ao coração', 'verdade': false, 'categoria': 'Alimentação', 'explicacao': 'O ovo é nutritivo e tem colesterol bom. Estudos mostram que consumir 1 ovo por dia é seguro para a maioria das pessoas.'},
    {'mito': 'Chupar limão cura gripe', 'verdade': false, 'categoria': 'Saúde', 'explicacao': 'O limão tem vitamina C, mas não cura gripe. A gripe é causada por vírus e precisa de repouso e hidratação.'},
    {'mito': 'Ficar sem comer emagrece mais rápido', 'verdade': false, 'categoria': 'Alimentação', 'explicacao': 'Ficar sem comer desacelera o metabolismo e pode causar efeito rebote. O ideal é fazer refeições equilibradas ao longo do dia.'},
    {'mito': 'Exercício em jejum queima mais gordura', 'verdade': false, 'categoria': 'Exercício', 'explicacao': 'Não há evidência de que treinar em jejum queime mais gordura. O mais importante é a regularidade e a alimentação equilibrada.'},
    {'mito': 'Café faz mal à saúde', 'verdade': false, 'categoria': 'Alimentação', 'explicacao': 'O café, consumido com moderação (até 3 xícaras por dia), pode trazer benefícios. O excesso é que pode causar problemas como insônia e ansiedade.'},
    {'mito': 'Vacina causa autismo', 'verdade': false, 'categoria': 'Saúde', 'explicacao': 'Não há nenhuma comprovação científica que ligue vacinas ao autismo. O estudo que sugeria isso foi desmentido e retirado de circulação.'},
    {'mito': 'Dormir pouco é sinal de produtividade', 'verdade': false, 'categoria': 'Sono', 'explicacao': 'Dormir pouco prejudica a memória, a concentração e a imunidade. O ideal é dormir entre 7 e 9 horas por noite.'},
    {'mito': 'Remédio natural não faz mal', 'verdade': false, 'categoria': 'Medicamentos', 'explicacao': 'Tudo o que é consumido tem efeito. Plantas medicinais podem interagir com outros medicamentos. Só use com orientação de um médico.'},
    {'mito': 'Suar muito emagrece', 'verdade': false, 'categoria': 'Exercício', 'explicacao': 'Suar é a perda de líquido, não de gordura. Após beber água, o peso volta. O que emagrece é o déficit calórico.'},
    {'mito': 'Beber 2 litros de água por dia é essencial', 'verdade': true, 'categoria': 'Hidratação', 'explicacao': 'A recomendação geral é de cerca de 2 litros de água por dia para adultos, variando conforme peso e atividade física.'},
    {'mito': 'Praticar exercícios melhora o humor', 'verdade': true, 'categoria': 'Exercício', 'explicacao': 'A atividade física libera endorfina e serotonina, neurotransmissores que melhoram o bem-estar e reduzem o estresse.'},
    {'mito': 'Dormir bem fortalece a imunidade', 'verdade': true, 'categoria': 'Sono', 'explicacao': 'Durante o sono, o corpo produz citocinas, proteínas que combatem infecções. Dormir bem é essencial para a imunidade.'},
    {'mito': 'Comer frutas e verduras previne doenças', 'verdade': true, 'categoria': 'Alimentação', 'explicacao': 'Frutas e verduras são ricas em vitaminas, minerais e antioxidantes que ajudam a prevenir doenças crônicas.'},
    {'mito': 'Lavar as mãos previne doenças', 'verdade': true, 'categoria': 'Hábitos', 'explicacao': 'A lavagem correta das mãos com água e sabão elimina vírus e bactérias, prevenindo infecções respiratórias e gastrointestinais.'},
    {'mito': 'Tomar sol antes das 10h faz bem', 'verdade': true, 'categoria': 'Saúde', 'explicacao': 'A exposição moderada ao sol antes das 10h ajuda na produção de vitamina D, essencial para os ossos.'},
    {'mito': 'Vacinas previnem doenças graves', 'verdade': true, 'categoria': 'Saúde', 'explicacao': 'As vacinas são uma das maiores conquistas da medicina e previnem doenças como sarampo, poliomielite e gripe.'},
    {'mito': 'Meditar reduz o estresse', 'verdade': true, 'categoria': 'Saúde Mental', 'explicacao': 'A meditação regular reduz os níveis de cortisol (hormônio do estresse) e melhora a saúde mental.'},
  ];

  List<Map<String, dynamic>> get _itensFiltrados {
    if (_filtroAtivo == 'Todos') return _itens;
    if (_filtroAtivo == 'Mitos') return _itens.where((i) => i['verdade'] == false).toList();
    return _itens.where((i) => i['verdade'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtituloColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CoresApp.warning.withValues(alpha: 0.15),
                  CoresApp.warning.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: CoresApp.warning.withValues(alpha: 0.30)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [CoresApp.warning, CoresApp.warning.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: CoresApp.warning.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.fact_check_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mitos e Verdades',
                        style: AppTextStyles.tituloCardClaro.copyWith(
                          color: widget.tituloColor,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: CoresApp.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_itens.length} afirmações para julgar',
                            style: AppTextStyles.micro.copyWith(color: subtituloColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filtros.map((filtro) {
                final ativo = _filtroAtivo == filtro;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filtroAtivo = filtro),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: ativo ? CoresApp.primary : CoresApp.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        filtro,
                        style: AppTextStyles.chip.copyWith(
                          color: ativo ? Colors.white : CoresApp.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ..._itensFiltrados.map((item) => _buildCard(item, isDark, subtituloColor)),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, bool isDark, Color subtituloColor) {
    final verdade = item['verdade'] as bool;
    final cor = verdade ? CoresApp.success : CoresApp.error;
    final categoria = item['categoria'] as String;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? CoresApp.darkSurface : CoresApp.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? CoresApp.darkBorder : CoresApp.greyLight),
          boxShadow: [
            BoxShadow(
              color: cor.withValues(alpha: isDark ? 0.10 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _mostrarDetalhes(item, cor),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: cor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      verdade ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: cor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: cor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            categoria.toUpperCase(),
                            style: AppTextStyles.micro.copyWith(
                              color: cor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['mito'] as String,
                          style: AppTextStyles.tituloCardClaro.copyWith(
                            color: widget.tituloColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_rounded, color: cor, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalhes(Map<String, dynamic> item, Color cor) {
    final verdade = item['verdade'] as bool;
    final categoria = item['categoria'] as String;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
        final tituloColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
        final subtituloColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
          child: SafeArea(
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
                        color: subtituloColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [cor, cor.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: cor.withValues(alpha: 0.30),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          verdade ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: cor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                categoria.toUpperCase(),
                                style: AppTextStyles.micro.copyWith(
                                  color: cor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['mito'] as String,
                              style: AppTextStyles.tituloCardClaro.copyWith(
                                color: tituloColor,
                                fontSize: 18,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cor.withValues(alpha: 0.10),
                          cor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cor.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: cor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            verdade ? 'VERDADE' : 'MITO',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['explicacao'] as String,
                          style: AppTextStyles.legenda.copyWith(
                            color: subtituloColor,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Entendi',
                        style: AppTextStyles.botao.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
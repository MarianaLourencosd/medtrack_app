// Nome do arquivo: lib/telas/dicas/dicas_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

class DicasScreen extends StatefulWidget {
  const DicasScreen({super.key});

  @override
  State<DicasScreen> createState() => _DicasScreenState();
}

class _DicasScreenState extends State<DicasScreen> {
  String _categoriaAtiva = 'Todas';

  final List<String> _categorias = [
    'Todas',
    'Alimentação',
    'Sono',
    'Exercício',
    'Saúde Mental',
    'Medicamentos',
    'Emergência',
    'Hidratação',
  ];

  final List<Map<String, dynamic>> _dicas = [
    // Alimentação (4)
    {
      'categoria': 'Alimentação',
      'icone': Icons.restaurant_rounded,
      'cor': CoresApp.success,
      'titulo': 'Coma frutas todos os dias',
      'texto': 'Frutas são fontes de vitaminas e fibras. Tente incluir pelo menos 3 porções por dia.',
      'detalhe': 'Uma alimentação rica em frutas e verduras fortalece o sistema imunológico e ajuda na prevenção de doenças crônicas como diabetes e hipertensão.',
    },
    {
      'categoria': 'Alimentação',
      'icone': Icons.no_food_rounded,
      'cor': CoresApp.warning,
      'titulo': 'Reduza o consumo de açúcar',
      'texto': 'O excesso de açúcar aumenta o risco de diabetes e obesidade.',
      'detalhe': 'A Organização Mundial da Saúde recomenda menos de 25g de açúcar por dia. Evite refrigerantes e prefira frutas para adoçar naturalmente.',
    },
    {
      'categoria': 'Alimentação',
      'icone': Icons.rice_bowl_rounded,
      'cor': CoresApp.primary,
      'titulo': 'Inclua fibras na alimentação',
      'texto': 'Fibras ajudam no funcionamento do intestino e na saciedade.',
      'detalhe': 'Aveia, feijão, frutas e verduras são ricos em fibras. A recomendação é de 25g a 30g por dia para adultos.',
    },
    {
      'categoria': 'Alimentação',
      'icone': Icons.local_dining_rounded,
      'cor': CoresApp.info,
      'titulo': 'Evite ultraprocessados',
      'texto': 'Prefira alimentos naturais e evite embutidos e congelados.',
      'detalhe': 'Alimentos ultraprocessados são ricos em sódio, açúcar e gorduras ruins. Prefira comida fresca e caseira sempre que possível.',
    },

    // Sono (4)
    {
      'categoria': 'Sono',
      'icone': Icons.bedtime_rounded,
      'cor': CoresApp.info,
      'titulo': 'Durma 8 horas por noite',
      'texto': 'O sono reparador melhora a memória, o humor e a imunidade.',
      'detalhe': 'Durante o sono, o corpo libera hormônios que regulam o crescimento, o apetite e o estresse. Dormir bem também melhora a concentração e o desempenho no dia seguinte.',
    },
    {
      'categoria': 'Sono',
      'icone': Icons.nightlight_rounded,
      'cor': CoresApp.secondary,
      'titulo': 'Evite telas antes de dormir',
      'texto': 'A luz azul do celular atrapalha o sono.',
      'detalhe': 'A exposição à luz azul das telas reduz a produção de melatonina, o hormônio do sono. Tente desligar os eletrônicos 30 minutos antes de dormir.',
    },
    {
      'categoria': 'Sono',
      'icone': Icons.alarm_rounded,
      'cor': CoresApp.primary,
      'titulo': 'Mantenha horários regulares',
      'texto': 'Dormir e acordar no mesmo horário regula o relógio biológico.',
      'detalhe': 'A rotina de sono ajuda o corpo a se preparar para dormir e acordar. Tente manter os mesmos horários até nos fins de semana.',
    },
    {
      'categoria': 'Sono',
      'icone': Icons.coffee_rounded,
      'cor': CoresApp.warning,
      'titulo': 'Evite café depois das 16h',
      'texto': 'A cafeína pode atrapalhar o sono por até 6 horas.',
      'detalhe': 'O café, chá preto e refrigerantes contêm cafeína. Evite consumir essas bebidas no período da tarde para não prejudicar o sono.',
    },

    // Exercício (4)
    {
      'categoria': 'Exercício',
      'icone': Icons.directions_walk_rounded,
      'cor': CoresApp.primary,
      'titulo': 'Caminhe 20 minutos por dia',
      'texto': 'Uma caminhada leve já reduz o risco de doenças cardíacas.',
      'detalhe': 'A atividade física regular melhora a circulação, fortalece os ossos e reduz a ansiedade. Não precisa ser intenso: uma caminhada diária já traz benefícios significativos.',
    },
    {
      'categoria': 'Exercício',
      'icone': Icons.accessibility_new_rounded,
      'cor': CoresApp.primary,
      'titulo': 'Alongue-se ao acordar',
      'texto': 'Alongamentos matinais ativam a circulação e reduzem dores.',
      'detalhe': 'Cinco minutos de alongamento ao acordar melhoram a postura, reduzem a rigidez muscular e preparam o corpo para o dia.',
    },
    {
      'categoria': 'Exercício',
      'icone': Icons.fitness_center_rounded,
      'cor': CoresApp.error,
      'titulo': 'Fortaleça seus músculos',
      'texto': 'Exercícios de força 2x por semana previnem lesões.',
      'detalhe': 'Musculação, pilates ou exercícios com peso corporal ajudam a manter a massa muscular e a saúde dos ossos, especialmente após os 30 anos.',
    },
    {
      'categoria': 'Exercício',
      'icone': Icons.directions_bike_rounded,
      'cor': CoresApp.success,
      'titulo': 'Varie os exercícios',
      'texto': 'Alternar atividades evita lesões e melhora o condicionamento.',
      'detalhe': 'Combinar caminhada, natação e alongamento trabalha grupos musculares diferentes e evita a rotina. O corpo se adapta melhor com variedade.',
    },

    // Saúde Mental (4)
    {
      'categoria': 'Saúde Mental',
      'icone': Icons.psychology_rounded,
      'cor': CoresApp.secondary,
      'titulo': 'Respire fundo 3 vezes ao dia',
      'texto': 'A respiração profunda reduz o estresse e a ansiedade.',
      'detalhe': 'Exercícios simples de respiração ativam o sistema nervoso parassimpático, que acalma o corpo e a mente. Experimente inspirar por 4 segundos e expirar por 6.',
    },
    {
      'categoria': 'Saúde Mental',
      'icone': Icons.self_improvement_rounded,
      'cor': CoresApp.secondary,
      'titulo': 'Pratique gratidão diariamente',
      'texto': 'Anotar 3 coisas boas do dia melhora o humor.',
      'detalhe': 'Estudos mostram que a prática da gratidão reduz sintomas de ansiedade e depressão, além de melhorar a qualidade do sono.',
    },
    {
      'categoria': 'Saúde Mental',
      'icone': Icons.people_rounded,
      'cor': CoresApp.info,
      'titulo': 'Mantenha contato com amigos',
      'texto': 'Conversar com quem gosta faz bem à saúde mental.',
      'detalhe': 'O isolamento social é um fator de risco para depressão. Mantenha contato regular com familiares e amigos, mesmo que virtualmente.',
    },
    {
      'categoria': 'Saúde Mental',
      'icone': Icons.spa_rounded,
      'cor': CoresApp.success,
      'titulo': 'Reserve um tempo para você',
      'texto': '10 minutos de autocuidado por dia fazem diferença.',
      'detalhe': 'Ler, tomar um chá, ouvir música ou simplesmente descansar são formas de cuidar da mente. O autocuidado é essencial para o equilíbrio emocional.',
    },

    // Medicamentos (4)
    {
      'categoria': 'Medicamentos',
      'icone': Icons.medication_rounded,
      'cor': CoresApp.warning,
      'titulo': 'Nunca esqueça seus remédios',
      'texto': 'Use lembretes no celular para não perder os horários.',
      'detalhe': 'A adesão correta ao tratamento medicamentoso é fundamental para o sucesso da terapia. Use o recurso de Lembretes do MedTrack para organizar seus horários.',
    },
    {
      'categoria': 'Medicamentos',
      'icone': Icons.alarm_rounded,
      'cor': CoresApp.warning,
      'titulo': 'Use alarmes para os remédios',
      'texto': 'Configure alarmes nos horários certos dos seus medicamentos.',
      'detalhe': 'A adesão ao tratamento é fundamental. Use o recurso de Lembretes do MedTrack para nunca esquecer uma dose.',
    },
    {
      'categoria': 'Medicamentos',
      'icone': Icons.inventory_2_rounded,
      'cor': CoresApp.info,
      'titulo': 'Guarde os remédios corretamente',
      'texto': 'Mantenha os medicamentos longe da umidade e do calor.',
      'detalhe': 'Remédios devem ser guardados em local seco, arejado e fora do alcance de crianças. Verifique sempre a validade antes de usar.',
    },
    {
      'categoria': 'Medicamentos',
      'icone': Icons.medical_information_rounded,
      'cor': CoresApp.error,
      'titulo': 'Nunca se automedique',
      'texto': 'Sempre consulte um médico antes de tomar remédios.',
      'detalhe': 'A automedicação pode mascarar sintomas e causar efeitos colaterais graves. Procure sempre orientação médica antes de iniciar qualquer tratamento.',
    },

    // Emergência (4)
    {
      'categoria': 'Emergência',
      'icone': Icons.emergency_rounded,
      'cor': CoresApp.error,
      'titulo': 'Tenha contatos de emergência salvos',
      'texto': 'Cadastre seus contatos no app para usar no SOS.',
      'detalhe': 'Em uma emergência, ter os contatos certos à mão pode salvar vidas. Cadastre familiares e o número do SAMU (192) no seu perfil do MedTrack.',
    },
    {
      'categoria': 'Emergência',
      'icone': Icons.phone_in_talk_rounded,
      'cor': CoresApp.error,
      'titulo': 'Saiba o número do SAMU',
      'texto': 'O SAMU (192) atende emergências em todo o Brasil.',
      'detalhe': 'Em caso de emergência médica, ligue 192. O serviço é gratuito e funciona 24 horas por dia em todo o território nacional.',
    },
    {
      'categoria': 'Emergência',
      'icone': Icons.medical_services_rounded,
      'cor': CoresApp.warning,
      'titulo': 'Conheça os sintomas de AVC',
      'texto': 'Fraqueza em um lado do corpo e fala enrolada são sinais.',
      'detalhe': 'O AVC é uma emergência médica. Se notar fraqueza súbita, boca torta ou dificuldade para falar, ligue imediatamente para o 192.',
    },
    {
      'categoria': 'Emergência',
      'icone': Icons.favorite_rounded,
      'cor': CoresApp.primary,
      'titulo': 'Aprenda primeiros socorros',
      'texto': 'Saber o básico pode salvar vidas.',
      'detalhe': 'Cursos gratuitos de primeiros socorros estão disponíveis online. Saber como agir em engasgo, desmaio ou parada cardíaca faz toda a diferença.',
    },

    // Hidratação (4)
    {
      'categoria': 'Hidratação',
      'icone': Icons.water_drop_rounded,
      'cor': CoresApp.info,
      'titulo': 'Beba água ao longo do dia',
      'texto': 'A hidratação melhora a disposição e o metabolismo.',
      'detalhe': 'O corpo humano é composto por cerca de 60% de água. Beber pelo menos 2 litros por dia ajuda a regular a temperatura, transportar nutrientes e eliminar toxinas.',
    },
    {
      'categoria': 'Hidratação',
      'icone': Icons.local_drink_rounded,
      'cor': CoresApp.info,
      'titulo': 'Leve uma garrafa de água',
      'texto': 'Ter água por perto facilita a hidratação ao longo do dia.',
      'detalhe': 'A recomendação é de 35ml de água por quilo de peso. Uma pessoa de 70kg deve beber cerca de 2,4 litros por dia.',
    },
    {
      'categoria': 'Hidratação',
      'icone': Icons.thermostat_rounded,
      'cor': CoresApp.warning,
      'titulo': 'Aumente a água no calor',
      'texto': 'Em dias quentes, beba mais água que o habitual.',
      'detalhe': 'Com o calor, o corpo perde mais líquido pela transpiração. Beba água antes mesmo de sentir sede para evitar desidratação.',
    },
    {
      'categoria': 'Hidratação',
      'icone': Icons.sports_bar_rounded,
      'cor': CoresApp.success,
      'titulo': 'Beba água antes do exercício',
      'texto': 'Hidrate-se antes, durante e após a atividade física.',
      'detalhe': 'A hidratação adequada antes do exercício melhora o desempenho e evita câimbras. Beba cerca de 500ml de água 1 hora antes de se exercitar.',
    },
  ];

  List<Map<String, dynamic>> get _dicasFiltradas {
    if (_categoriaAtiva == 'Todas') return _dicas;
    return _dicas.where((d) => d['categoria'] == _categoriaAtiva).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkBackground : CoresApp.background;
    final tituloColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          'Dicas de Saúde',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Recarregar dicas',
            onPressed: () {
              setState(() => _categoriaAtiva = 'Todas');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dicas recarregadas!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(context),
              const SizedBox(height: 24),
              _buildHeader(context, tituloColor, subtituloColor),
              const SizedBox(height: 20),
              _buildCategorias(),
              const SizedBox(height: 22),
              _buildListaDicas(context, tituloColor, subtituloColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: isDark ? CoresApp.darkSurface : CoresApp.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: SvgPicture.asset(
        'assets/images/fundo-header.svg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color tituloColor, Color subtituloColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [CoresApp.darkSurface, CoresApp.darkSurfaceAlt]
              : [CoresApp.white, CoresApp.surface],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
        ),
        boxShadow: [
          BoxShadow(
            color: CoresApp.primary.withValues(alpha: isDark ? 0.12 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CoresApp.warning,
                  CoresApp.warning.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: CoresApp.warning.withValues(alpha: 0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dicas para o seu bem-estar',
                  style: AppTextStyles.tituloCardClaro.copyWith(
                    color: tituloColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: CoresApp.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_dicas.length} dicas disponíveis',
                      style: AppTextStyles.micro.copyWith(color: subtituloColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorias() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categorias.map((cat) {
          final ativo = _categoriaAtiva == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _categoriaAtiva = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: ativo
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            CoresApp.primary,
                            CoresApp.primary.withValues(alpha: 0.85),
                          ],
                        )
                      : null,
                  color: ativo ? null : CoresApp.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: ativo
                      ? [
                          BoxShadow(
                            color: CoresApp.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  cat,
                  style: AppTextStyles.chip.copyWith(
                    color: ativo ? Colors.white : CoresApp.primary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListaDicas(BuildContext context, Color tituloColor, Color subtituloColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    final lista = _dicasFiltradas;
    if (lista.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: subtituloColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 28,
                color: subtituloColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Nenhuma dica nessa categoria',
              textAlign: TextAlign.center,
              style: AppTextStyles.textoCorpoForte.copyWith(color: tituloColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Tente explorar outras categorias',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: subtituloColor),
            ),
          ],
        ),
      );
    }

    return Column(
      children: lista.map((dica) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _cardDica(
            context: context,
            dica: dica,
            tituloColor: tituloColor,
            subtituloColor: subtituloColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _cardDica({
    required BuildContext context,
    required Map<String, dynamic> dica,
    required Color tituloColor,
    required Color subtituloColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final cor = dica['cor'] as Color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _mostrarDetalhes(context, dica),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: cor.withValues(alpha: isDark ? 0.12 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cor.withValues(alpha: 0.20),
                      cor.withValues(alpha: 0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: cor.withValues(alpha: 0.20),
                    width: 1,
                  ),
                ),
                child: Icon(dica['icone'] as IconData, color: cor, size: 28),
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
                        dica['categoria'] as String,
                        style: AppTextStyles.micro.copyWith(
                          color: cor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dica['titulo'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.tituloCardClaro.copyWith(
                        color: tituloColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dica['texto'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.descricaoCardClaro.copyWith(
                        color: subtituloColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
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
    );
  }

  void _mostrarDetalhes(BuildContext context, Map<String, dynamic> dica) {
    final cor = dica['cor'] as Color;

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
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              cor,
                              cor.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: cor.withValues(alpha: 0.30),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(dica['icone'] as IconData, color: Colors.white, size: 34),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: cor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                dica['categoria'] as String,
                                style: AppTextStyles.micro.copyWith(
                                  color: cor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dica['titulo'] as String,
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
                  const SizedBox(height: 22),
                  Text(
                    dica['texto'] as String,
                    style: AppTextStyles.textoCorpo.copyWith(color: tituloColor),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cor.withValues(alpha: 0.10),
                          cor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cor.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.info_outline_rounded, size: 18, color: cor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            dica['detalhe'] as String,
                            style: AppTextStyles.legenda.copyWith(color: subtituloColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: cor.withValues(alpha: 0.40),
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';

enum NivelDificuldade { facil, medio, dificil }

class QuizConteudo extends StatefulWidget {
  final Color tituloColor;

  const QuizConteudo({super.key, required this.tituloColor});

  @override
  State<QuizConteudo> createState() => _QuizConteudoState();
}

class _QuizConteudoState extends State<QuizConteudo> {
  bool _iniciado = false;
  NivelDificuldade _nivel = NivelDificuldade.facil;

  int _perguntaAtual = 0;
  int _acertos = 0;
  int? _respostaSelecionada;
  bool _mostrarResultado = false;
  Timer? _cronometro;
  int _segundos = 40;

  final List<Map<String, dynamic>> _todasPerguntas = [
    // ==================== FÁCIL ====================
    {'pergunta': 'Qual é a quantidade recomendada de água por dia?', 'opcoes': ['1 litro', '2 litros', '5 litros', '10 litros'], 'correta': 1, 'explicacao': 'A recomendação é de cerca de 2 litros por dia.', 'nivel': 'facil'},
    {'pergunta': 'Quantas horas de sono um adulto deve dormir?', 'opcoes': ['4-5 horas', '5-6 horas', '7-9 horas', '10-12 horas'], 'correta': 2, 'explicacao': 'Adultos devem dormir entre 7 e 9 horas por noite.', 'nivel': 'facil'},
    {'pergunta': 'Qual é o número do SAMU?', 'opcoes': ['190', '191', '192', '193'], 'correta': 2, 'explicacao': 'O SAMU atende pelo número 192.', 'nivel': 'facil'},
    {'pergunta': 'Qual alimento é rico em fibras?', 'opcoes': ['Arroz branco', 'Aveia', 'Pão branco', 'Batata frita'], 'correta': 1, 'explicacao': 'A aveia é rica em fibras solúveis.', 'nivel': 'facil'},
    {'pergunta': 'Quantas porções de frutas são recomendadas por dia?', 'opcoes': ['1 porção', '3 porções', '5 porções', '10 porções'], 'correta': 1, 'explicacao': 'A recomendação é de pelo menos 3 porções por dia.', 'nivel': 'facil'},
    {'pergunta': 'O que devemos fazer antes de comer?', 'opcoes': ['Lavar as mãos', 'Beber água', 'Correr', 'Dormir'], 'correta': 0, 'explicacao': 'Lavar as mãos antes das refeições previne doenças.', 'nivel': 'facil'},
    {'pergunta': 'Qual bebida é mais saudável para se hidratar?', 'opcoes': ['Refrigerante', 'Água', 'Suco de caixinha', 'Energético'], 'correta': 1, 'explicacao': 'A água é a melhor opção para hidratação.', 'nivel': 'facil'},
    {'pergunta': 'Quantas vezes por dia devemos escovar os dentes?', 'opcoes': ['1 vez', '2 vezes', '3 vezes', '4 vezes'], 'correta': 2, 'explicacao': 'O ideal é escovar os dentes após as refeições principais.', 'nivel': 'facil'},
    {'pergunta': 'O que é bom fazer antes de dormir?', 'opcoes': ['Usar o celular', 'Tomar café', 'Relaxar', 'Correr'], 'correta': 2, 'explicacao': 'Relaxar antes de dormir melhora a qualidade do sono.', 'nivel': 'facil'},
    {'pergunta': 'Qual vitamina é encontrada na laranja?', 'opcoes': ['Vitamina A', 'Vitamina B', 'Vitamina C', 'Vitamina D'], 'correta': 2, 'explicacao': 'A laranja é rica em vitamina C, que fortalece a imunidade.', 'nivel': 'facil'},
    {'pergunta': 'O que devemos usar para proteger a pele do sol?', 'opcoes': ['Protetor solar', 'Água', 'Sabão', 'Creme dental'], 'correta': 0, 'explicacao': 'O protetor solar protege a pele dos raios UV.', 'nivel': 'facil'},
    {'pergunta': 'Quantas refeições por dia são recomendadas?', 'opcoes': ['1', '2', '3 a 5', '10'], 'correta': 2, 'explicacao': 'O ideal é fazer de 3 a 5 refeições equilibradas por dia.', 'nivel': 'facil'},

    // ==================== MÉDIO ====================
    {'pergunta': 'O que significa IMC?', 'opcoes': ['Índice de Massa Corpórea', 'Índice de Massa Corporal', 'Índice de Músculo Corporal', 'Índice de Medida Corporal'], 'correta': 1, 'explicacao': 'IMC significa Índice de Massa Corporal.', 'nivel': 'medio'},
    {'pergunta': 'Quantos minutos de exercício por dia são recomendados?', 'opcoes': ['5 minutos', '10 minutos', '30 minutos', '2 horas'], 'correta': 2, 'explicacao': 'A OMS recomenda pelo menos 30 minutos por dia.', 'nivel': 'medio'},
    {'pergunta': 'Qual vitamina é produzida pela exposição ao sol?', 'opcoes': ['Vitamina A', 'Vitamina B', 'Vitamina C', 'Vitamina D'], 'correta': 3, 'explicacao': 'A vitamina D é produzida pela pele quando exposta ao sol.', 'nivel': 'medio'},
    {'pergunta': 'Qual é o principal sintoma de desidratação?', 'opcoes': ['Sede', 'Fome', 'Cansaço', 'Febre'], 'correta': 0, 'explicacao': 'A sede é o primeiro sinal de desidratação.', 'nivel': 'medio'},
    {'pergunta': 'O que fazer em caso de queimadura leve?', 'opcoes': ['Passar manteiga', 'Passar pasta de dente', 'Lavar com água fria', 'Passar álcool'], 'correta': 2, 'explicacao': 'Lave com água fria corrente por 10 minutos.', 'nivel': 'medio'},
    {'pergunta': 'Quantas horas de sono são ideais para um adolescente?', 'opcoes': ['5-6 horas', '6-7 horas', '8-10 horas', '12 horas'], 'correta': 2, 'explicacao': 'Adolescentes devem dormir entre 8 e 10 horas.', 'nivel': 'medio'},
    {'pergunta': 'Qual desses alimentos é rico em proteína?', 'opcoes': ['Arroz', 'Feijão', 'Alface', 'Maçã'], 'correta': 1, 'explicacao': 'O feijão é rico em proteínas vegetais.', 'nivel': 'medio'},
    {'pergunta': 'O que devemos beber antes do exercício?', 'opcoes': ['Refrigerante', 'Água', 'Café', 'Leite'], 'correta': 1, 'explicacao': 'A água hidrata antes do exercício.', 'nivel': 'medio'},
    {'pergunta': 'Qual é a temperatura corporal considerada febre?', 'opcoes': ['36°C', '37°C', '38°C ou mais', '40°C'], 'correta': 2, 'explicacao': 'Considera-se febre a partir de 37,8°C a 38°C.', 'nivel': 'medio'},
    {'pergunta': 'Quantas vezes por semana devemos praticar exercícios?', 'opcoes': ['1 vez', '2 vezes', '3 a 5 vezes', 'Todos os dias'], 'correta': 2, 'explicacao': 'O ideal é praticar exercícios de 3 a 5 vezes por semana.', 'nivel': 'medio'},
    {'pergunta': 'Qual é o principal nutriente do ovo?', 'opcoes': ['Carboidrato', 'Proteína', 'Gordura trans', 'Açúcar'], 'correta': 1, 'explicacao': 'O ovo é rico em proteínas de alta qualidade.', 'nivel': 'medio'},
    {'pergunta': 'Qual é a melhor forma de prevenir a gripe?', 'opcoes': ['Tomar banho gelado', 'Tomar vacina', 'Comer doce', 'Dormir pouco'], 'correta': 1, 'explicacao': 'A vacina é a forma mais eficaz de prevenir a gripe.', 'nivel': 'medio'},
    {'pergunta': 'O que é bom para aliviar o estresse?', 'opcoes': ['Fumar', 'Beber álcool', 'Meditar', 'Comer demais'], 'correta': 2, 'explicacao': 'A meditação é uma ótima forma de aliviar o estresse.', 'nivel': 'medio'},

    // ==================== DIFÍCIL ====================
    {'pergunta': 'Qual é o tempo máximo recomendado para lavar as mãos?', 'opcoes': ['5 segundos', '10 segundos', '20 segundos', '60 segundos'], 'correta': 2, 'explicacao': 'A OMS recomenda lavar as mãos por pelo menos 20 segundos.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é a pressão arterial considerada normal?', 'opcoes': ['90/60 mmHg', '120/80 mmHg', '140/90 mmHg', '160/100 mmHg'], 'correta': 1, 'explicacao': 'A pressão arterial normal é de 120/80 mmHg.', 'nivel': 'dificil'},
    {'pergunta': 'Quantas horas de jejum são recomendadas antes de um exame de sangue?', 'opcoes': ['2 horas', '4 horas', '8 horas', '12 horas'], 'correta': 2, 'explicacao': 'O jejum recomendado é de 8 a 12 horas.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é o principal sintoma de AVC?', 'opcoes': ['Dor de cabeça', 'Fraqueza em um lado do corpo', 'Febre alta', 'Tosse'], 'correta': 1, 'explicacao': 'O AVC pode causar fraqueza súbita em um lado do corpo.', 'nivel': 'dificil'},
    {'pergunta': 'Quantas horas de exercício aeróbico por semana são recomendadas?', 'opcoes': ['30 minutos', '1 hora', '2 horas e meia', '5 horas'], 'correta': 2, 'explicacao': 'A OMS recomenda pelo menos 150 minutos (2h30) por semana.', 'nivel': 'dificil'},
    {'pergunta': 'O que significa a sigla RCP?', 'opcoes': ['Reanimação Cardiopulmonar', 'Respiração Controlada', 'Ritmo Cardíaco', 'Recuperação Cardíaca'], 'correta': 0, 'explicacao': 'RCP significa Reanimação Cardiopulmonar.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é a quantidade diária de sal recomendada?', 'opcoes': ['2g', '5g', '10g', '15g'], 'correta': 1, 'explicacao': 'A OMS recomenda menos de 5g de sal por dia.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é o melhor horário para tomar sol para vitamina D?', 'opcoes': ['Ao meio-dia', 'Antes das 10h e após 16h', 'Após 22h', 'Não precisa de sol'], 'correta': 1, 'explicacao': 'Antes das 10h e após 16h o sol é mais seguro.', 'nivel': 'dificil'},
    {'pergunta': 'O que fazer ao presenciar um desmaio?', 'opcoes': ['Jogar água', 'Deitar a pessoa e elevar as pernas', 'Sacudir', 'Dar água'], 'correta': 1, 'explicacao': 'Deite a pessoa e eleve as pernas para melhorar a circulação.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é o tempo ideal de escovação dos dentes?', 'opcoes': ['30 segundos', '1 minuto', '2 minutos', '5 minutos'], 'correta': 2, 'explicacao': 'O tempo ideal de escovação é de 2 minutos.', 'nivel': 'dificil'},
    {'pergunta': 'Qual desses NÃO é um sintoma de infarto?', 'opcoes': ['Dor no peito', 'Dor no braço esquerdo', 'Dor de garganta', 'Suor frio'], 'correta': 2, 'explicacao': 'Dor de garganta não é sintoma de infarto.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é a função da insulina no corpo?', 'opcoes': ['Regular o açúcar no sangue', 'Produzir energia', 'Fortalecer os ossos', 'Regular o sono'], 'correta': 0, 'explicacao': 'A insulina regula o açúcar no sangue.', 'nivel': 'dificil'},
    {'pergunta': 'Quantas vezes por dia devemos medir a pressão?', 'opcoes': ['1 vez', '2 vezes', '3 vezes', 'Só quando necessário'], 'correta': 3, 'explicacao': 'A pressão deve ser medida quando necessário ou conforme orientação médica.', 'nivel': 'dificil'},
    {'pergunta': 'Qual é a quantidade de açúcar recomendada por dia?', 'opcoes': ['5g', '25g', '50g', '100g'], 'correta': 1, 'explicacao': 'A OMS recomenda menos de 25g de açúcar por dia.', 'nivel': 'dificil'},
    {'pergunta': 'O que fazer em caso de engasgo?', 'opcoes': ['Dar água', 'Manobra de Heimlich', 'Deitar', 'Sacudir'], 'correta': 1, 'explicacao': 'A manobra de Heimlich é a técnica correta para desengasgo.', 'nivel': 'dificil'},
  ];

  List<Map<String, dynamic>> get _perguntasFiltradas {
    return _todasPerguntas.where((p) => p['nivel'] == _nivel.name).toList();
  }

  int get _tempoPorPergunta {
    switch (_nivel) {
      case NivelDificuldade.facil:
        return 40;
      case NivelDificuldade.medio:
        return 30;
      case NivelDificuldade.dificil:
        return 20;
    }
  }

  @override
  void dispose() {
    _cronometro?.cancel();
    super.dispose();
  }

  void _iniciarCronometro() {
    _cronometro?.cancel();
    _segundos = _tempoPorPergunta;
    _cronometro = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_segundos > 0) {
          _segundos--;
        } else {
          timer.cancel();
          _respostaSelecionada ??= -1;
        }
      });
    });
  }

  void _iniciarQuiz() {
    if (_perguntasFiltradas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma pergunta nesse nível.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _iniciado = true;
      _perguntaAtual = 0;
      _acertos = 0;
      _respostaSelecionada = null;
      _mostrarResultado = false;
    });
    _iniciarCronometro();
  }

  void _responder(int index) {
    if (_respostaSelecionada != null) return;
    setState(() {
      _respostaSelecionada = index;
      if (index == _perguntasFiltradas[_perguntaAtual]['correta']) {
        _acertos++;
        Confetti.launch(context, options: const ConfettiOptions(particleCount: 50, spread: 60, y: 0.6));
      }
    });
  }

  void _proximaPergunta() {
    _cronometro?.cancel();
    if (_perguntaAtual < _perguntasFiltradas.length - 1) {
      setState(() {
        _perguntaAtual++;
        _respostaSelecionada = null;
      });
      _iniciarCronometro();
    } else {
      setState(() => _mostrarResultado = true);
      _verificarBadges();
      Confetti.launch(context, options: const ConfettiOptions(particleCount: 150, spread: 100, y: 0.4));
    }
  }

  void _verificarBadges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final ref = FirebaseFirestore.instance.collection('badges_quiz').doc(user.uid);
    if (_acertos >= 10) ref.set({'acertou_10': true}, SetOptions(merge: true));
    if (_acertos == _perguntasFiltradas.length) ref.set({'acertou_tudo': true}, SetOptions(merge: true));
    ref.set({'primeiro_quiz': true}, SetOptions(merge: true));
  }

  void _reiniciar() {
    _cronometro?.cancel();
    setState(() {
      _iniciado = false;
      _perguntaAtual = 0;
      _acertos = 0;
      _respostaSelecionada = null;
      _mostrarResultado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!_iniciado) return _buildConfiguracao(isDark);
    if (_mostrarResultado) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
        child: _buildResultado(isDark),
      );
    }
    return _buildQuiz(isDark);
  }

  Widget _buildConfiguracao(bool isDark) {
    final total = _perguntasFiltradas.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CoresApp.primary, CoresApp.primaryDark],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.quiz_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Prepare-se para o Quiz', style: AppTextStyles.tituloCardEscuro.copyWith(fontSize: 17)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Escolha o nível de dificuldade. $total perguntas disponíveis.',
                  style: AppTextStyles.subtituloCardEscuro.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Nível de dificuldade', style: AppTextStyles.tituloSecao.copyWith(color: widget.tituloColor)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildNivelChip(NivelDificuldade.facil, 'Fácil', Icons.sentiment_satisfied_rounded, CoresApp.success),
              const SizedBox(width: 8),
              _buildNivelChip(NivelDificuldade.medio, 'Médio', Icons.sentiment_neutral_rounded, CoresApp.warning),
              const SizedBox(width: 8),
              _buildNivelChip(NivelDificuldade.dificil, 'Difícil', Icons.sentiment_very_dissatisfied_rounded, CoresApp.error),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? CoresApp.darkSurface : CoresApp.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? CoresApp.darkBorder : CoresApp.greyLight),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_rounded, color: CoresApp.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tempo por pergunta: ${_tempoPorPergunta}s',
                    style: AppTextStyles.textoCorpoForte.copyWith(color: widget.tituloColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _iniciarQuiz,
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: Text('Começar Quiz', style: AppTextStyles.botao.copyWith(fontSize: 14.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNivelChip(NivelDificuldade nivel, String label, IconData icone, Color cor) {
    final ativo = _nivel == nivel;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _nivel = nivel),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: ativo ? cor.withValues(alpha: 0.15) : (isDark ? CoresApp.darkSurface : CoresApp.surface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ativo ? cor : (isDark ? CoresApp.darkBorder : CoresApp.greyLight),
              width: ativo ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icone, color: ativo ? cor : (isDark ? CoresApp.darkTextMuted : CoresApp.textMuted), size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: ativo ? cor : (isDark ? CoresApp.darkTextMuted : CoresApp.textMuted),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz(bool isDark) {
    final perguntas = _perguntasFiltradas;
    final pergunta = perguntas[_perguntaAtual];
    final progresso = (_perguntaAtual + 1) / perguntas.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? CoresApp.darkSurface : CoresApp.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? CoresApp.darkBorder : CoresApp.greyLight),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Pergunta ${_perguntaAtual + 1} de ${perguntas.length}',
                      style: AppTextStyles.micro.copyWith(color: widget.tituloColor, fontWeight: FontWeight.w800, fontSize: 12.5),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _segundos <= 10 ? CoresApp.error.withValues(alpha: 0.15) : CoresApp.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_rounded, size: 12, color: _segundos <= 10 ? CoresApp.error : CoresApp.warning),
                          const SizedBox(width: 4),
                          Text(
                            '${_segundos}s',
                            style: AppTextStyles.micro.copyWith(
                              color: _segundos <= 10 ? CoresApp.error : CoresApp.warning,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CoresApp.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$_acertos acertos',
                        style: AppTextStyles.micro.copyWith(color: CoresApp.success, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 8,
                    backgroundColor: CoresApp.primary.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(CoresApp.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CoresApp.primary, CoresApp.primaryDark],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              pergunta['pergunta'] as String,
              style: AppTextStyles.tituloCardEscuro.copyWith(fontSize: 17, height: 1.35),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(pergunta['opcoes'].length, (index) {
            final opcao = pergunta['opcoes'][index] as String;
            final correta = pergunta['correta'] as int;
            final selecionada = _respostaSelecionada == index;
            final respondida = _respostaSelecionada != null;
            final acertou = index == correta;

            Color bg;
            Color border;
            Color texto;
            IconData? icone;

            if (!respondida) {
              bg = isDark ? CoresApp.darkSurface : CoresApp.surface;
              border = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
              texto = widget.tituloColor;
            } else if (acertou) {
              bg = CoresApp.success.withValues(alpha: 0.15);
              border = CoresApp.success;
              texto = CoresApp.success;
              icone = Icons.check_circle_rounded;
            } else if (selecionada) {
              bg = CoresApp.error.withValues(alpha: 0.15);
              border = CoresApp.error;
              texto = CoresApp.error;
              icone = Icons.cancel_rounded;
            } else {
              bg = isDark ? CoresApp.darkSurface : CoresApp.surface;
              border = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
              texto = widget.tituloColor;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _responder(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border, width: respondida && (selecionada || acertou) ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opcao,
                            style: AppTextStyles.textoCorpoForte.copyWith(color: texto, fontSize: 13.5),
                          ),
                        ),
                        if (icone != null) Icon(icone, color: texto, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          if (_respostaSelecionada != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CoresApp.info.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CoresApp.info.withValues(alpha: 0.30)),
              ),
              child: Text(
                pergunta['explicacao'] as String,
                style: AppTextStyles.legenda.copyWith(color: isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _proximaPergunta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _perguntaAtual < perguntas.length - 1 ? 'Próxima pergunta' : 'Ver resultado',
                  style: AppTextStyles.botao.copyWith(fontSize: 14.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultado(bool isDark) {
    final total = _perguntasFiltradas.length;
    final porcentagem = total == 0 ? 0 : (_acertos / total * 100).round();
    final mensagem = porcentagem >= 80
        ? 'Excelente! Você é um expert em saúde!'
        : porcentagem >= 50
            ? 'Bom trabalho! Você sabe bastante sobre saúde.'
            : 'Continue aprendendo! A saúde é um tema importante.';
    final cor = porcentagem >= 80 ? CoresApp.success : porcentagem >= 50 ? CoresApp.warning : CoresApp.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? CoresApp.darkSurface : CoresApp.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? CoresApp.darkBorder : CoresApp.greyLight),
      ),
      child: Column(
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(color: cor.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(porcentagem >= 80 ? Icons.emoji_events_rounded : Icons.school_rounded, color: cor, size: 46),
          ),
          const SizedBox(height: 20),
          Text('Resultado', style: AppTextStyles.tituloSecao.copyWith(color: widget.tituloColor)),
          const SizedBox(height: 12),
          Text('$_acertos de $total', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: cor)),
          const SizedBox(height: 6),
          Text('$porcentagem% de acerto', style: AppTextStyles.textoCorpo.copyWith(color: isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(16)),
            child: Text(mensagem, textAlign: TextAlign.center, style: AppTextStyles.textoCorpoForte.copyWith(color: cor, fontSize: 13)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _reiniciar,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Jogar novamente', style: AppTextStyles.botao.copyWith(fontSize: 14.5)),
            ),
          ),
        ],
      ),
    );
  }
}
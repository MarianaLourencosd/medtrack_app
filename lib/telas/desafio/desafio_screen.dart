
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../servicos/servico_desafio.dart';

class DesafioScreen extends StatefulWidget {
  const DesafioScreen({super.key});

  @override
  State<DesafioScreen> createState() => _DesafioScreenState();
}

class _DesafioScreenState extends State<DesafioScreen> {
  final ServicoDesafio _servico = ServicoDesafio();

  final List<Map<String, dynamic>> _habitos = [
    {
      'titulo': 'Beber água ao longo do dia',
      'descricao': 'Manter-se hidratada',
      'icone': Icons.water_drop_rounded,
    },
    {
      'titulo': 'Movimentar o corpo',
      'descricao': 'Fazer alguma atividade confortável',
      'icone': Icons.directions_walk_rounded,
    },
    {
      'titulo': 'Cuidar da rotina de sono',
      'descricao': 'Reservar um momento para descansar',
      'icone': Icons.bedtime_rounded,
    },
    {
      'titulo': 'Incluir frutas na alimentação',
      'descricao': 'Variar os alimentos do dia',
      'icone': Icons.apple_rounded,
    },
    {
      'titulo': 'Fazer uma pausa para alongar',
      'descricao': 'Dedicar um momento ao corpo',
      'icone': Icons.accessibility_new_rounded,
    },
    {
      'titulo': 'Reservar um momento para relaxar',
      'descricao': 'Respirar e desacelerar',
      'icone': Icons.spa_rounded,
    },
    {
      'titulo': 'Registrar como foi seu dia',
      'descricao': 'Observar seu bem-estar',
      'icone': Icons.favorite_rounded,
    },
  ];

  List<bool> _concluidos = List.filled(7, false);

  bool _carregando = true;
  bool _salvando = false;
  bool _medalha7Dias = false;
  bool _diaRecompensado = false;

  int _sequenciaAtual = 0;
  int _maiorSequencia = 0;
  int _xp = 0;

  String? _uid;
  String? _erro;

  int get _totalConcluidos =>
      _concluidos.where((concluido) => concluido).length;

  double get _progresso => _totalConcluidos / _habitos.length;

  bool get _diaCompleto => _totalConcluidos == _habitos.length;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  Future<void> _carregarProgresso() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      setState(() {
        _carregando = false;
        _erro = 'Faça login para acessar o desafio.';
      });
      return;
    }

    _uid = usuario.uid;

    try {
      final dados = await _servico.carregarProgresso(_uid!);

      if (!mounted) return;

      setState(() {
        _concluidos = List<bool>.from(
          dados['habitosHoje'] ?? List.filled(7, false),
        );
        _sequenciaAtual = dados['sequenciaAtual'] ?? 0;
        _maiorSequencia = dados['maiorSequencia'] ?? 0;
        _xp = dados['xp'] ?? 0;
        _medalha7Dias = dados['medalha7Dias'] ?? false;
        _diaRecompensado = dados['diaRecompensado'] ?? false;
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar seu progresso.';
      });
    }
  }

  Future<void> _alterarHabito(int index, bool value) async {
    if (_salvando || _uid == null || _diaRecompensado) return;

    final anterior = _concluidos[index];

    setState(() {
      _concluidos[index] = value;
      _salvando = true;
    });

    try {
      await _servico.atualizarHabito(
        uid: _uid!,
        indice: index,
        concluido: value,
      );

      final dados = await _servico.carregarProgresso(_uid!);

      if (!mounted) return;

      setState(() {
        _concluidos = List<bool>.from(
          dados['habitosHoje'] ?? List.filled(7, false),
        );
        _sequenciaAtual = dados['sequenciaAtual'] ?? 0;
        _maiorSequencia = dados['maiorSequencia'] ?? 0;
        _xp = dados['xp'] ?? 0;
        _medalha7Dias = dados['medalha7Dias'] ?? false;
        _diaRecompensado = dados['diaRecompensado'] ?? false;
        _salvando = false;
      });

      if (_diaRecompensado && !anterior && _diaCompleto) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Parabéns! Você concluiu os 7 hábitos e ganhou 50 XP!',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _concluidos[index] = anterior;
        _salvando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar seu progresso.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final texto =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final textoSecundario =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final card = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        title: Text(
          'Desafio de 7 dias',
          style: AppTextStyles.tituloTela.copyWith(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: CoresApp.primary,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _erro!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: texto),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _carregando = true;
                              _erro = null;
                            });
                            _carregarProgresso();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCabecalho(),
                      const SizedBox(height: 18),
                      _buildEstatisticas(card, texto, textoSecundario),
                      const SizedBox(height: 22),
                      _buildProgresso(card, texto, textoSecundario),
                      const SizedBox(height: 22),
                      _buildTitulo(
                        'Hábitos de hoje',
                        'Marque as atividades conforme forem concluídas.',
                        texto,
                        textoSecundario,
                      ),
                      const SizedBox(height: 14),
                      ...List.generate(
                        _habitos.length,
                        (index) => _buildHabito(
                          index,
                          card,
                          texto,
                          textoSecundario,
                          isDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildConquista(card, texto, textoSecundario),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCabecalho() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: CoresApp.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Colors.white,
            size: 38,
          ),
          const SizedBox(height: 14),
          const Text(
            'Uma semana cuidando de você!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pequenas atitudes podem fazer parte de uma rotina mais saudável. '
            'Complete os hábitos no seu ritmo!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticas(
    Color card,
    Color texto,
    Color textoSecundario,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildEstatistica(
            card,
            texto,
            textoSecundario,
            Icons.stars_rounded,
            '$_xp XP',
            'Experiência',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _buildEstatistica(
            card,
            texto,
            textoSecundario,
            Icons.local_fire_department_rounded,
            '$_sequenciaAtual',
            'Sequência atual',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _buildEstatistica(
            card,
            texto,
            textoSecundario,
            Icons.emoji_events_rounded,
            '$_maiorSequencia',
            'Maior sequência',
          ),
        ),
      ],
    );
  }

  Widget _buildEstatistica(
    Color card,
    Color texto,
    Color textoSecundario,
    IconData icone,
    String valor,
    String titulo,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Icon(icone, color: CoresApp.primary, size: 25),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              color: texto,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgresso(
    Color card,
    Color texto,
    Color textoSecundario,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: CoresApp.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seu progresso de hoje',
                style: TextStyle(
                  color: texto,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '$_totalConcluidos/7',
                style: const TextStyle(
                  color: CoresApp.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_totalConcluidos',
                style: const TextStyle(
                  color: CoresApp.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  ' / 7 hábitos concluídos',
                  style: TextStyle(
                    color: textoSecundario,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progresso,
              minHeight: 11,
              backgroundColor: CoresApp.primary.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                CoresApp.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _diaCompleto
                ? 'Parabéns! Você concluiu todos os hábitos de hoje!'
                : 'Continue no seu ritmo. Cada pequena conquista conta!',
            style: TextStyle(
              color: textoSecundario,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitulo(
    String titulo,
    String subtitulo,
    Color texto,
    Color textoSecundario,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: texto,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitulo,
          style: TextStyle(
            color: textoSecundario,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHabito(
    int index,
    Color card,
    Color texto,
    Color textoSecundario,
    bool isDark,
  ) {
    final habito = _habitos[index];
    final concluido = _concluidos[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: concluido
              ? CoresApp.primary.withValues(alpha: 0.45)
              : isDark
                  ? CoresApp.darkBorder
                  : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: CheckboxListTile(
        value: concluido,
        onChanged: (_salvando || _diaRecompensado)
            ? null
            : (value) {
                if (value != null) {
                  _alterarHabito(index, value);
                }
              },
        activeColor: CoresApp.primary,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 5,
        ),
        secondary: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: CoresApp.mint,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            habito['icone'] as IconData,
            color: CoresApp.primary,
            size: 22,
          ),
        ),
        title: Text(
          habito['titulo'] as String,
          style: TextStyle(
            color: texto,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            decoration: concluido ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            habito['descricao'] as String,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConquista(
    Color card,
    Color texto,
    Color textoSecundario,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _medalha7Dias
              ? Colors.amber.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: _medalha7Dias
                  ? Colors.amber.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              _medalha7Dias
                  ? Icons.workspace_premium_rounded
                  : Icons.lock_outline_rounded,
              color: _medalha7Dias ? Colors.amber : Colors.grey,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _medalha7Dias
                      ? 'Medalha desbloqueada!'
                      : 'Medalha bloqueada',
                  style: TextStyle(
                    color: texto,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _medalha7Dias
                      ? 'Você completou 7 dias consecutivos. Parabéns!'
                      : 'Complete os hábitos por 7 dias consecutivos para desbloquear sua medalha.',
                  style: TextStyle(
                    color: textoSecundario,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

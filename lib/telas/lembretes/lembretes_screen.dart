import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../modelos/lembrete.dart';
import '../../servicos/servico_lembretes.dart';

/// Tela de lembretes locais do usuário.
///
/// Cada lembrete é salvo no dispositivo e dispara uma notificação na data e
/// no horário escolhidos.
class LembretesScreen extends StatefulWidget {
  const LembretesScreen({super.key});

  @override
  State<LembretesScreen> createState() => _LembretesScreenState();
}

class _LembretesScreenState extends State<LembretesScreen>
    with WidgetsBindingObserver {
  final ServicoLembretes _servico = ServicoLembretes();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _servico.inicializar(solicitarPermissoes: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // O usuário pode ter alterado a permissão nas configurações do sistema.
    if (state == AppLifecycleState.resumed) {
      _servico.verificarPermissoesDeNotificacao();
    }
  }

  Future<void> _novoLembrete() async {
    final dados = await _abrirFormulario();
    if (dados == null) return;

    try {
      await _servico.adicionar(
        titulo: dados.titulo,
        descricao: dados.descricao,
        dataHora: dados.dataHora,
      );
      if (!mounted) return;
      // Consulta o estado real: o plugin inicializado não garante que o
      // usuário autorizou os avisos do sistema.
      final autorizadas = await _servico.verificarPermissoesDeNotificacao();
      if (!mounted) return;
      _mostrarMensagem(
        autorizadas == true ? 'Lembrete criado e notificação agendada.' : 'Lembrete salvo. Ative as notificações do sistema para ser avisado.',
        autorizadas == true ? CoresApp.primary : CoresApp.warning,
      );
    } catch (erro) {
      if (!mounted) return;
      _mostrarMensagem(
        erro is ArgumentError
            ? erro.message.toString()
            : 'Não foi possível criar o lembrete.',
        CoresApp.error,
      );
    }
  }

  Future<void> _editarLembrete(Lembrete lembrete) async {
    final dados = await _abrirFormulario(lembrete: lembrete);
    if (dados == null) return;

    try {
      await _servico.atualizar(
        Lembrete(
          id: lembrete.id,
          titulo: dados.titulo,
          descricao: dados.descricao,
          dataHora: dados.dataHora,
          concluido: lembrete.concluido,
          notificacaoId: lembrete.notificacaoId,
        ),
      );
      if (!mounted) return;
      final autorizadas = await _servico.verificarPermissoesDeNotificacao();
      if (!mounted) return;
      _mostrarMensagem(
        autorizadas == true ? 'Lembrete atualizado.' : 'Lembrete atualizado. Ative as notificações do sistema para ser avisado.',
        autorizadas == true ? CoresApp.primary : CoresApp.warning,
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem(
        'Não foi possível atualizar o lembrete.',
        CoresApp.error,
      );
    }
  }

  Future<void> _removerLembrete(Lembrete lembrete) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remover lembrete?'),
        content: Text(
          'O lembrete "${lembrete.titulo}" será apagado e a notificação '
          'cancelada.',
          style: AppTextStyles.textoCorpoSecundario,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contexto, true),
            style: TextButton.styleFrom(foregroundColor: CoresApp.error),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _servico.remover(lembrete);
    if (!mounted) return;
    _mostrarMensagem('Lembrete removido.', CoresApp.primary);
  }

  Future<_DadosLembrete?> _abrirFormulario({Lembrete? lembrete}) {
    return showModalBottomSheet<_DadosLembrete>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FormularioLembrete(lembrete: lembrete),
    );
  }

  void _mostrarMensagem(String texto, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoresApp.primary,
        foregroundColor: CoresApp.white,
        title: const Text('Lembretes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novoLembrete,
        backgroundColor: CoresApp.primary,
        foregroundColor: CoresApp.white,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text(
          'Novo lembrete',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _servico.carregando,
        builder: (context, carregando, _) {
          if (carregando) {
            return const Center(
              child: CircularProgressIndicator(color: CoresApp.primary),
            );
          }

          return ValueListenableBuilder<List<Lembrete>>(
            valueListenable: _servico.lembretes,
            builder: (context, lembretes, _) {
              return ValueListenableBuilder<bool?>(
                valueListenable: _servico.notificacoesAutorizadas,
                builder: (context, autorizadas, _) {
                  final aviso = _avisoNotificacoes(autorizadas);
                  if (lembretes.isEmpty) return _vazio(aviso);
                  return _lista(lembretes, aviso);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _lista(List<Lembrete> lembretes, Widget? aviso) {
    final possuiAviso = aviso != null;
    final deslocamento = possuiAviso ? 2 : 1;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
      itemCount: lembretes.length + deslocamento,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, indice) {
        if (indice == 0) return _cabecalho(lembretes.length);
        if (possuiAviso && indice == 1) return aviso;
        return _cartaoLembrete(lembretes[indice - deslocamento]);
      },
    );
  }

  /// Aviso exibido quando o sistema não vai mostrar as notificações.
  Widget? _avisoNotificacoes(bool? autorizadas) {
    if (!_servico.notificacoesSuportadas || !_servico.notificacoesIniciadas) {
      return _cartaoAviso(
        icone: Icons.notifications_off_rounded,
        cor: CoresApp.info,
        fundo: CoresApp.softBlue,
        titulo: 'Notificações indisponíveis',
        texto:
            'Neste dispositivo os lembretes ficam salvos, mas não é possível '
            'exibir avisos.',
      );
    }

    if (autorizadas != false) return null;

    return _cartaoAviso(
      icone: Icons.notifications_paused_rounded,
      cor: CoresApp.warning,
      fundo: CoresApp.softYellow,
      titulo: 'Notificações desativadas',
      texto:
          'Seus lembretes continuam salvos, mas o sistema não vai exibir os '
          'avisos até você permitir.',
      acao: 'Ativar',
      aoTocarAcao: _abrirConfiguracoesDeNotificacao,
    );
  }

  Future<void> _abrirConfiguracoesDeNotificacao() async {
    await _servico.abrirConfiguracoesDeNotificacao();
    // Revalida ao voltar do sistema (o ciclo de vida também cobre esse caso).
    await _servico.verificarPermissoesDeNotificacao();
  }

  Widget _cartaoAviso({
    required IconData icone,
    required Color cor,
    required Color fundo,
    required String titulo,
    required String texto,
    String? acao,
    VoidCallback? aoTocarAcao,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: isDark ? CoresApp.darkSurfaceAlt : fundo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? CoresApp.darkBorder : cor.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: cor, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppTextStyles.textoCorpoForte.copyWith(
                    color: textColor,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  texto,
                  style: AppTextStyles.micro.copyWith(color: subtitleColor),
                ),
              ],
            ),
          ),
          if (acao != null)
            TextButton(
              onPressed: aoTocarAcao,
              style: TextButton.styleFrom(foregroundColor: cor),
              child: Text(
                acao,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cabecalho(int total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seus cuidados',
          style: AppTextStyles.tituloSecao.copyWith(color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          total == 1
              ? '1 lembrete salvo neste dispositivo'
              : '$total lembretes salvos neste dispositivo',
          style: AppTextStyles.subtituloSecao.copyWith(color: subtitleColor),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _vazio(Widget? aviso) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (aviso != null) ...[aviso, const SizedBox(height: 24)],
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: CoresApp.softYellow,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: CoresApp.warning,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Nenhum lembrete ainda',
              textAlign: TextAlign.center,
              style: AppTextStyles.tituloCardClaro.copyWith(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie avisos para medicamentos, consultas e outros cuidados. '
              'Os lembretes ficam salvos apenas neste aparelho.',
              textAlign: TextAlign.center,
              style: AppTextStyles.textoCorpoSecundario.copyWith(
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: _novoLembrete,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primary,
                foregroundColor: CoresApp.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add_alert_rounded, size: 19),
              label: const Text('Criar primeiro lembrete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartaoLembrete(Lembrete lembrete) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    final cor = lembrete.concluido
        ? CoresApp.success
        : lembrete.atrasado
        ? CoresApp.warning
        : CoresApp.primary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? CoresApp.darkBorder : cor.withValues(alpha: 0.16),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _editarLembrete(lembrete),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 8, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  lembrete.concluido
                      ? Icons.task_alt_rounded
                      : Icons.alarm_rounded,
                  color: cor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lembrete.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textoCorpoForte.copyWith(
                        color: textColor,
                        fontSize: 14.5,
                        decoration: lembrete.concluido
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (lembrete.descricao != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        lembrete.descricao!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: subtitleColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formatarDataHora(lembrete.dataHora),
                            style: AppTextStyles.micro.copyWith(
                              color: lembrete.atrasado
                                  ? CoresApp.warning
                                  : subtitleColor,
                              fontWeight: lembrete.atrasado
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (lembrete.atrasado)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CoresApp.softYellow,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'Atrasado',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: CoresApp.warning,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                children: [
                  IconButton(
                    tooltip: lembrete.concluido
                        ? 'Reabrir lembrete'
                        : 'Marcar como concluído',
                    onPressed: () => _servico.alternarConcluido(lembrete),
                    icon: Icon(
                      lembrete.concluido
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: lembrete.concluido
                          ? CoresApp.success
                          : CoresApp.textMuted,
                      size: 22,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remover',
                    onPressed: () => _removerLembrete(lembrete),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: CoresApp.error,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formata datas no padrão brasileiro sem depender de dados de locale.
String formatarDataHora(DateTime data) {
  const meses = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  final dia = data.day.toString().padLeft(2, '0');
  final mes = meses[data.month - 1];
  final ano = data.year;
  final hora = data.hour.toString().padLeft(2, '0');
  final minuto = data.minute.toString().padLeft(2, '0');

  return '$dia de $mes de $ano às $hora:$minuto';
}

class _DadosLembrete {
  const _DadosLembrete({
    required this.titulo,
    required this.dataHora,
    this.descricao,
  });

  final String titulo;
  final String? descricao;
  final DateTime dataHora;
}

class _FormularioLembrete extends StatefulWidget {
  const _FormularioLembrete({this.lembrete});

  final Lembrete? lembrete;

  @override
  State<_FormularioLembrete> createState() => _FormularioLembreteState();
}

class _FormularioLembreteState extends State<_FormularioLembrete> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descricao;
  late DateTime _dataHora;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.lembrete?.titulo ?? '');
    _descricao = TextEditingController(text: widget.lembrete?.descricao ?? '');
    _dataHora =
        widget.lembrete?.dataHora ??
        DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final agora = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _dataHora.isBefore(agora) ? agora : _dataHora,
      firstDate: DateTime(agora.year, agora.month, agora.day),
      lastDate: DateTime(agora.year + 5),
      helpText: 'DATA DO LEMBRETE',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CoresApp.primary,
              onPrimary: Colors.white,
              onSurface: CoresApp.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (escolhida == null || !mounted) return;

    setState(() {
      _dataHora = DateTime(
        escolhida.year,
        escolhida.month,
        escolhida.day,
        _dataHora.hour,
        _dataHora.minute,
      );
    });
  }

  Future<void> _escolherHora() async {
    final escolhida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dataHora),
      helpText: 'HORÁRIO DO LEMBRETE',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (escolhida == null || !mounted) return;

    setState(() {
      _dataHora = DateTime(
        _dataHora.year,
        _dataHora.month,
        _dataHora.day,
        escolhida.hour,
        escolhida.minute,
      );
    });
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_dataHora.isAfter(DateTime.now())) {
      setState(() => _erro = 'Escolha uma data e um horário futuros.');
      return;
    }

    Navigator.pop(
      context,
      _DadosLembrete(
        titulo: _titulo.text.trim(),
        descricao: _descricao.text.trim().isEmpty
            ? null
            : _descricao.text.trim(),
        dataHora: _dataHora,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fundo = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final editando = widget.lembrete != null;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: CoresApp.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: CoresApp.softYellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.alarm_add_rounded,
                          color: CoresApp.warning,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          editando ? 'Editar lembrete' : 'Novo lembrete',
                          style: AppTextStyles.tituloCardClaro.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Fechar',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Título', style: AppTextStyles.labelInput),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titulo,
                    autofocus: !editando,
                    textInputAction: TextInputAction.next,
                    maxLength: 80,
                    style: AppTextStyles.inputTexto.copyWith(color: textColor),
                    decoration: _decoracao(
                      hint: 'Ex: Tomar remédio para pressão',
                      icone: Icons.edit_note_rounded,
                      isDark: isDark,
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe um título.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Descrição (opcional)',
                    style: AppTextStyles.labelInput,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descricao,
                    maxLines: 3,
                    maxLength: 200,
                    style: AppTextStyles.inputTexto.copyWith(color: textColor),
                    decoration: _decoracao(
                      hint: 'Ex: 1 comprimido após o almoço',
                      icone: Icons.notes_rounded,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Quando avisar?', style: AppTextStyles.labelInput),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _escolherData,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textColor,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? CoresApp.darkBorder
                                  : CoresApp.greyLight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            size: 17,
                            color: CoresApp.primary,
                          ),
                          label: Text(
                            '${_dataHora.day.toString().padLeft(2, '0')}/'
                            '${_dataHora.month.toString().padLeft(2, '0')}/'
                            '${_dataHora.year}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _escolherHora,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textColor,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? CoresApp.darkBorder
                                  : CoresApp.greyLight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.schedule_rounded,
                            size: 17,
                            color: CoresApp.primary,
                          ),
                          label: Text(
                            '${_dataHora.hour.toString().padLeft(2, '0')}:'
                            '${_dataHora.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatarDataHora(_dataHora),
                    style: AppTextStyles.micro.copyWith(
                      color: isDark
                          ? CoresApp.darkTextSecondary
                          : CoresApp.textSecondary,
                    ),
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 8),
                    Text(_erro!, style: AppTextStyles.erro),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CoresApp.primary,
                      foregroundColor: CoresApp.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 20),
                    label: Text(
                      editando ? 'Salvar alterações' : 'Criar lembrete',
                      style: AppTextStyles.botaoPequeno,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracao({
    required String hint,
    required IconData icone,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.inputHint.copyWith(
        color: isDark ? CoresApp.darkTextMuted : CoresApp.textMuted,
      ),
      counterText: '',
      prefixIcon: Icon(
        icone,
        color: CoresApp.primary.withValues(alpha: 0.8),
        size: 20,
      ),
      filled: true,
      fillColor: isDark ? CoresApp.darkSurfaceAlt : CoresApp.greyBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CoresApp.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CoresApp.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CoresApp.error, width: 1.8),
      ),
    );
  }
}

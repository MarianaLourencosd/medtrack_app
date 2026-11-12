import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modelos/lembrete.dart';
import 'servico_notificacoes.dart';

/// Mantém os lembretes do usuário atual no armazenamento local.
///
/// A lista é exposta por [ValueNotifier] para que a interface acompanhe
/// inclusões, edições e remoções sem precisar de outro gerenciador de estado.
class ServicoLembretes {
  ServicoLembretes({ServicoNotificacoes? notificacoes})
    : _notificacoes = notificacoes ?? ServicoNotificacoes.instancia;

  static const String _prefixoChave = 'lembretes_';

  final ServicoNotificacoes _notificacoes;

  final ValueNotifier<List<Lembrete>> lembretes = ValueNotifier<List<Lembrete>>(
    const [],
  );
  final ValueNotifier<bool> carregando = ValueNotifier<bool>(true);

  /// Estado da permissão de notificação no sistema.
  ///
  /// Repassado por [ServicoNotificacoes] para que a interface consiga avisar
  /// quando o lembrete está salvo, mas o aviso não será exibido.
  ValueListenable<bool?> get notificacoesAutorizadas =>
      _notificacoes.permissoesConcedidas;

  /// Indica se a plataforma atual possui suporte a notificações locais.
  bool get notificacoesSuportadas => _notificacoes.suportado;

  /// Indica se o plugin de notificações terminou de inicializar.
  bool get notificacoesIniciadas => _notificacoes.inicializado;

  /// Consulta novamente a permissão sem abrir o diálogo do sistema.
  Future<bool?> verificarPermissoesDeNotificacao() =>
      _notificacoes.verificarPermissoes();

  /// Abre as configurações de notificação do aplicativo no sistema.
  Future<bool> abrirConfiguracoesDeNotificacao() =>
      _notificacoes.abrirConfiguracoesDeNotificacao();

  String get _chave {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'dispositivo';
    return '$_prefixoChave$uid';
  }

  /// Lê os lembretes salvos e ordena pelos mais próximos.
  Future<void> inicializar({bool solicitarPermissoes = false}) async {
    carregando.value = true;

    if (solicitarPermissoes) {
      await _notificacoes.inicializar(solicitarPermissoes: true);
    }

    final prefs = await SharedPreferences.getInstance();
    final salvos = prefs.getStringList(_chave) ?? const <String>[];

    final lista = salvos.map(Lembrete.fromJson).whereType<Lembrete>().toList()
      ..sort((a, b) => a.dataHora.compareTo(b.dataHora));

    lembretes.value = List<Lembrete>.unmodifiable(lista);
    carregando.value = false;
  }

  /// Cria um lembrete, salva localmente e agenda a notificação.
  Future<Lembrete> adicionar({
    required String titulo,
    required DateTime dataHora,
    String? descricao,
  }) async {
    final agora = DateTime.now();
    if (!dataHora.isAfter(agora)) {
      throw ArgumentError('Escolha uma data e um horário futuros.');
    }

    final texto = titulo.trim();
    if (texto.isEmpty) {
      throw ArgumentError('Informe um título para o lembrete.');
    }

    final lembrete = Lembrete(
      id: agora.microsecondsSinceEpoch.toString(),
      titulo: texto,
      descricao: _texto(descricao),
      dataHora: dataHora,
      notificacaoId: agora.millisecondsSinceEpoch.remainder(2147483000),
    );

    await _notificacoes.inicializar();
    await _notificacoes.agendar(lembrete);
    await _persistir([...lembretes.value, lembrete]);

    return lembrete;
  }

  /// Atualiza título, descrição ou horário e reagenda a notificação.
  Future<void> atualizar(Lembrete lembrete) async {
    final lista = [...lembretes.value];
    final indice = lista.indexWhere((item) => item.id == lembrete.id);
    if (indice < 0) return;

    final anterior = lista[indice];
    lista[indice] = lembrete;

    await _notificacoes.cancelar(anterior.notificacaoId);
    if (!lembrete.concluido && lembrete.dataHora.isAfter(DateTime.now())) {
      await _notificacoes.inicializar();
      await _notificacoes.agendar(lembrete);
    }

    await _persistir(lista);
  }

  /// Marca/desmarca como concluído, cancelando ou recriando o aviso.
  Future<void> alternarConcluido(Lembrete lembrete) async {
    final atualizado = lembrete.copyWith(concluido: !lembrete.concluido);
    await atualizar(atualizado);
  }

  Future<void> remover(Lembrete lembrete) async {
    await _notificacoes.cancelar(lembrete.notificacaoId);
    final lista = lembretes.value
        .where((item) => item.id != lembrete.id)
        .toList(growable: false);
    await _persistir(lista);
  }

  Future<void> _persistir(List<Lembrete> lista) async {
    final ordenada = [...lista]
      ..sort((a, b) => a.dataHora.compareTo(b.dataHora));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _chave,
      ordenada.map((item) => item.toJson()).toList(growable: false),
    );
    lembretes.value = List<Lembrete>.unmodifiable(ordenada);
  }

  static String? _texto(String? valor) {
    final texto = valor?.trim();
    return (texto == null || texto.isEmpty) ? null : texto;
  }
}

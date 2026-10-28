import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../modelos/modelo_medicamento.dart';

/// Serviço responsável por gerenciar a base local de medicamentos da ANVISA.
///
/// Funcionalidades:
/// - Carregamento assíncrono do JSON (prioriza diretório de documentos, fallback para assets)
/// - Filtragem otimizada para autocomplete (prefixo + substring)
/// - Atualização silenciosa Over-The-Air via Firebase Storage
/// - Cache em memória com [ValueNotifier] para UI reativa
class ServicoMedicamentos {
  ServicoMedicamentos._internal();

  static final ServicoMedicamentos _instance = ServicoMedicamentos._internal();
  factory ServicoMedicamentos() => _instance;

  // =========================================================================
  // Estado reativo (ValueNotifier para UI nativa sem pacotes externos)
  // =========================================================================

  /// Lista completa de medicamentos carregados (em memória).
  ///
  /// Expõe o ValueNotifier diretamente para permitir ValueListenableBuilder na UI.
  final ValueNotifier<List<Medicamento>> medicamentos = ValueNotifier<List<Medicamento>>([]);

  /// Indica se está carregando dados (útil para mostrar spinner).
  final ValueNotifier<bool> carregando = ValueNotifier<bool>(false);

  /// Indica se há uma atualização disponível/em progresso.
  final ValueNotifier<bool> atualizando = ValueNotifier<bool>(false);

  /// Erro ocorrido na última operação (null se sucesso).
  final ValueNotifier<String?> erro = ValueNotifier<String?>(null);

  // =========================================================================
  // Configurações
  // =========================================================================

  /// Caminho do arquivo no Firebase Storage (bucket padrão do projeto).
  static const String _storagePath = 'medicamentos/medicamentos.json';

  /// Nome do arquivo local no diretório de documentos do app.
  static const String _localFileName = 'medicamentos.json';

  /// Limite máximo de resultados no autocomplete (performance).
  static const int _limiteResultados = 50;

  /// Flag para evitar carregamentos simultâneos.
  bool _inicializado = false;

  // =========================================================================
  // API Pública
  // =========================================================================

  /// Inicializa o serviço: carrega cache local e verifica atualização OTA em background.
  ///
  /// Deve ser chamado uma única vez no startup do app (ex: no main.dart ou initState).
  Future<void> inicializar({bool forcar = false}) async {
    if (_inicializado && !forcar && erro.value == null) return;
    _inicializado = true;

    carregando.value = true;
    erro.value = null;

    try {
      // 1. Carrega do armazenamento local (documentos do app) ou assets
      await _carregarLocal();

      // 2. Verifica atualização OTA em background (apenas plataformas não-web)
      if (!kIsWeb) {
        _verificarAtualizacaoOTA();
      }
    } catch (e) {
      _inicializado = false; // Permite tentar novamente após erro
      erro.value = 'Falha ao carregar medicamentos: $e';
    } finally {
      carregando.value = false;
    }
  }

  /// Força verificação e download de nova versão do Firebase Storage.
  ///
  /// Útil para botão "Atualizar base" em configurações.
  Future<bool> forcarAtualizacao() async {
    if (kIsWeb) return false;
    if (atualizando.value) return false;
    atualizando.value = true;
    erro.value = null;

    try {
      final atualizado = await _baixarESalvarSeNovo();
      if (atualizado) {
        await _carregarLocal(); // Recarrega a lista atualizada
      }
      return atualizado;
    } catch (e) {
      erro.value = 'Erro na atualização: $e';
      return false;
    } finally {
      atualizando.value = false;
    }
  }

  /// Busca medicamentos otimizada para autocomplete.
  ///
  /// Algoritmo:
  /// 1. Prioriza correspondência de **prefixo** no nome (mais relevante para digitação)
  /// 2. Depois correspondência de **substring** no nome
  /// 3. Por fim correspondência no princípio ativo
  /// 4. Limita a [_limiteResultados] resultados
  ///
  /// Retorna lista já ordenada por relevância.
  List<Medicamento> buscar(String termo) {
    final t = termo.trim().toLowerCase();
    if (t.isEmpty) return [];

    final List<Medicamento> prefixo = [];
    final List<Medicamento> substring = [];
    final List<Medicamento> principio = [];

    for (final m in medicamentos.value) {
      final nomeLower = m.nome.toLowerCase();
      final principioLower = m.principioAtivo.toLowerCase();

      if (nomeLower.startsWith(t)) {
        prefixo.add(m);
      } else if (nomeLower.contains(t)) {
        substring.add(m);
      } else if (principioLower.contains(t)) {
        principio.add(m);
      }
    }

    // Concatena mantendo ordem de relevância e aplica limite
    final resultados = <Medicamento>[];
    resultados.addAll(prefixo);
    if (resultados.length < _limiteResultados) {
      resultados.addAll(substring.take(_limiteResultados - resultados.length));
    }
    if (resultados.length < _limiteResultados) {
      resultados.addAll(principio.take(_limiteResultados - resultados.length));
    }

    return resultados;
  }

  /// Busca síncrona simples (para uso em AutocompleteView).
  Iterable<Medicamento> autocomplete(String termo) => buscar(termo);

  // =========================================================================
  // Implementação Interna
  // =========================================================================

  /// Carrega medicamentos do armazenamento local (documentos) ou assets.
  Future<void> _carregarLocal() async {
    String jsonString;

    if (kIsWeb) {
      // No ambiente Web, não há suporte a sistema de arquivos local (path_provider/File).
      // Carrega diretamente dos assets da aplicação.
      jsonString = await rootBundle.loadString('assets/medicamentos.json');
    } else {
      final arquivoLocal = await _obterArquivoLocal();

      if (await arquivoLocal.exists()) {
        jsonString = await arquivoLocal.readAsString(encoding: utf8);
      } else {
        // Fallback para assets (primeira execução)
        jsonString = await rootBundle.loadString('assets/medicamentos.json');
      }
    }

    final List<dynamic> lista = json.decode(jsonString);
    medicamentos.value = lista.map((e) => Medicamento.fromJson(e)).toList();
  }

  /// Verifica se existe versão mais nova no Firebase Storage e baixa se necessário.
  Future<void> _verificarAtualizacaoOTA() async {
    if (kIsWeb) return;
    // Não bloqueia a UI - roda completamente em background
    try {
      await _baixarESalvarSeNovo();
    } catch (_) {
      // Silencioso: falha de rede não deve quebrar o app
      // O usuário continua com a versão local
    }
  }

  /// Baixa do Firebase Storage se o arquivo for mais novo (baseado em tamanho/ETag).
  ///
  /// Retorna true se baixou e salvou nova versão.
  Future<bool> _baixarESalvarSeNovo() async {
    if (kIsWeb) return false;
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(_storagePath);

    try {
      // Obtém metadados remotos (size, updated, md5Hash)
      final metaRemoto = await ref.getMetadata();
      final tamanhoRemoto = metaRemoto.size ?? 0;

      // Compara com arquivo local
      final arquivoLocal = await _obterArquivoLocal();
      int tamanhoLocal = 0;
      if (await arquivoLocal.exists()) {
        tamanhoLocal = await arquivoLocal.length();
      }

      // Se tamanhos diferentes, baixa nova versão
      // Nota: Em produção, preferir comparar md5Hash ou updated timestamp
      if (tamanhoRemoto != tamanhoLocal && tamanhoRemoto > 0) {
        final bytes = await ref.getData();
        if (bytes != null && bytes.isNotEmpty) {
          await arquivoLocal.writeAsBytes(bytes, flush: true);
          return true;
        }
      }
      return false;
    } on FirebaseException catch (e) {
      // Se arquivo não existe no Storage (404), ignora silenciosamente
      if (e.code != 'object-not-found') {
        rethrow;
      }
      return false;
    }
  }

  /// Retorna o [File] apontando para o JSON no diretório de documentos do app.
  Future<File> _obterArquivoLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_localFileName');
  }

  // =========================================================================
  // Utilitários
  // =========================================================================

  /// Libera recursos.
  /// Nota: Como é um singleton compartilhado durante todo o ciclo do app,
  /// não descartamos os ValueNotifiers para não corromper o estado em reaberturas de telas.
  void dispose() {
    // No-op para proteger o singleton
  }
}
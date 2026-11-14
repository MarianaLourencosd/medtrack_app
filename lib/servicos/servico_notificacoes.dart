import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../modelos/lembrete.dart';

/// Encapsula a configuração e o agendamento das notificações locais.
///
/// A classe é tolerante a plataformas sem suporte: se a inicialização falhar,
/// os lembretes continuam salvos e a interface avisa o usuário.
class ServicoNotificacoes {
  ServicoNotificacoes._();

  static final ServicoNotificacoes instancia = ServicoNotificacoes._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _canalId = 'medtrack_lembretes';
  static const String _canalNome = 'Lembretes MedTrack';
  static const String _canalDescricao =
      'Avisos de medicamentos, consultas e cuidados de saúde.';

  bool _inicializado = false;

  bool get inicializado => _inicializado;

  bool get suportado => !kIsWeb;

  /// Último estado conhecido da permissão de notificação.
  ///
  /// `null` = ainda não verificado (ou plataforma sem suporte), `true` =
  /// concedida e `false` = negada pelo usuário/sistema. A interface usa este
  /// valor para não prometer um aviso que o sistema não vai exibir.
  final ValueNotifier<bool?> permissoesConcedidas = ValueNotifier<bool?>(null);

  /// Prepara o plugin, o fuso horário e (opcionalmente) pede permissões.
  Future<bool> inicializar({bool solicitarPermissoes = false}) async {
    if (kIsWeb) return false;

    if (!_inicializado) {
      try {
        await _configurarFusoHorario();

        const settings = InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
        );

        await _plugin.initialize(settings: settings);
        _inicializado = true;
      } catch (_) {
        _inicializado = false;
        permissoesConcedidas.value = null;
      }
    }

    if (_inicializado) {
      if (solicitarPermissoes) {
        await solicitarPermissoesAoUsuario();
      } else {
        // Consulta silenciosa: serve apenas para saber se o aviso será exibido.
        await verificarPermissoes();
      }
    }

    return _inicializado;
  }

  Future<void> _configurarFusoHorario() async {
    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Mantém o fuso padrão do pacote `timezone` quando o plugin falha.
    }
  }

  /// Solicita as permissões de notificação ao usuário.
  ///
  /// Atualiza [permissoesConcedidas] com a resposta do sistema. A permissão de
  /// alarme exato no Android não é solicitada aqui: pedi-la abre uma tela de
  /// configurações do sistema e o agendamento funciona em modo inexato sem ela.
  Future<bool> solicitarPermissoesAoUsuario() async {
    if (!_inicializado) {
      permissoesConcedidas.value = null;
      return false;
    }

    bool concedida = false;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        concedida = await android?.requestNotificationsPermission() ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        concedida =
            await ios?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macos = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        concedida =
            await macos?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (_) {
      // Permissões negadas ou indisponíveis: o agendamento será ignorado.
      concedida = false;
    }

    permissoesConcedidas.value = concedida;
    return concedida;
  }

  /// Consulta o estado atual da permissão sem abrir o diálogo do sistema.
  ///
  /// Retorna `null` quando a plataforma não suporta notificações ou o estado
  /// não pôde ser determinado.
  Future<bool?> verificarPermissoes() async {
    if (kIsWeb || !_inicializado) return null;

    bool? concedida;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        concedida = await android?.areNotificationsEnabled();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        final opcoes = await ios?.checkPermissions();
        if (opcoes != null) {
          concedida = opcoes.isEnabled || opcoes.isProvisionalEnabled;
        }
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macos = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        final opcoes = await macos?.checkPermissions();
        if (opcoes != null) {
          concedida = opcoes.isEnabled || opcoes.isProvisionalEnabled;
        }
      }
    } catch (_) {
      concedida = null;
    }

    permissoesConcedidas.value = concedida;
    return concedida;
  }

  /// Abre a tela de notificações do aplicativo nas configurações do sistema.
  Future<bool> abrirConfiguracoesDeNotificacao() async {
    if (kIsWeb || !_inicializado) return false;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await android?.openAppNotificationSettings() ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        return await ios?.openAppNotificationSettings() ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macos = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        return await macos?.openAppNotificationSettings() ?? false;
      }
    } catch (_) {
      // Sem tela de configurações disponível nesta plataforma.
    }

    return false;
  }

  /// Agenda (ou reagenda) a notificação de um lembrete futuro.
  Future<bool> agendar(Lembrete lembrete) async {
    if (!_inicializado) return false;
    if (!lembrete.dataHora.isAfter(DateTime.now())) return false;

    try {
      final modo = await _modoAgendamentoAndroid();
      await _plugin.zonedSchedule(
        id: lembrete.notificacaoId,
        scheduledDate: tz.TZDateTime.from(lembrete.dataHora, tz.local),
        notificationDetails: _detalhesNotificacao,
        androidScheduleMode: modo,
        title: lembrete.titulo,
        body: _corpoNotificacao(lembrete),
        payload: lembrete.id,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<AndroidScheduleMode> _modoAgendamentoAndroid() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }

    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final exato = await android?.canScheduleExactNotifications() ?? false;
      return exato
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (_) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }

  Future<void> cancelar(int idNotificacao) async {
    if (!_inicializado) return;
    try {
      await _plugin.cancel(id: idNotificacao);
    } catch (_) {
      // Nada a fazer: o lembrete local continua removido da lista.
    }
  }

  String _corpoNotificacao(Lembrete lembrete) {
    final descricao = lembrete.descricao?.trim();
    if (descricao != null && descricao.isNotEmpty) return descricao;
    return 'Hora do seu lembrete de saúde.';
  }

  NotificationDetails get _detalhesNotificacao {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _canalId,
        _canalNome,
        channelDescription: _canalDescricao,
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
      ),
    );
  }
}

import 'dart:convert';

/// Representa um lembrete pessoal salvo apenas no dispositivo.
///
/// O lembrete não é enviado ao Firestore: ele existe para disparar uma
/// notificação local e por isso guarda também o identificador usado pelo
/// `flutter_local_notifications`.
class Lembrete {
  const Lembrete({
    required this.id,
    required this.titulo,
    required this.dataHora,
    required this.notificacaoId,
    this.descricao,
    this.concluido = false,
  });

  final String id;
  final String titulo;
  final String? descricao;
  final DateTime dataHora;
  final bool concluido;
  final int notificacaoId;

  /// Indica que o horário já passou e o lembrete continua pendente.
  bool get atrasado => !concluido && dataHora.isBefore(DateTime.now());

  Lembrete copyWith({
    String? titulo,
    String? descricao,
    DateTime? dataHora,
    bool? concluido,
    int? notificacaoId,
  }) {
    return Lembrete(
      id: id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataHora: dataHora ?? this.dataHora,
      concluido: concluido ?? this.concluido,
      notificacaoId: notificacaoId ?? this.notificacaoId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
      'concluido': concluido,
      'notificacaoId': notificacaoId,
    };
  }

  factory Lembrete.fromMap(Map<String, dynamic> map) {
    return Lembrete(
      id: map['id']?.toString() ?? '',
      titulo: map['titulo']?.toString() ?? 'Lembrete',
      descricao: _texto(map['descricao']),
      dataHora:
          DateTime.tryParse(map['dataHora']?.toString() ?? '') ??
          DateTime.now(),
      concluido: map['concluido'] == true,
      notificacaoId: _inteiro(map['notificacaoId']),
    );
  }

  String toJson() => jsonEncode(toMap());

  /// Converte o texto salvo no dispositivo, tolerando dados inválidos.
  static Lembrete? fromJson(String fonte) {
    try {
      final dados = jsonDecode(fonte);
      if (dados is Map<String, dynamic>) return Lembrete.fromMap(dados);
      if (dados is Map) {
        return Lembrete.fromMap(Map<String, dynamic>.from(dados));
      }
    } catch (_) {
      // Registro corrompido: é ignorado pelo serviço.
    }
    return null;
  }

  static String? _texto(dynamic valor) {
    if (valor == null) return null;
    final texto = valor.toString().trim();
    return texto.isEmpty ? null : texto;
  }

  static int _inteiro(dynamic valor) {
    if (valor is int) return valor.abs();
    return int.tryParse(valor?.toString() ?? '')?.abs() ?? 0;
  }
}

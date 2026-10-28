/// Modelo que representa um medicamento da base da ANVISA.
///
/// Contém apenas os campos essenciais para o autocomplete:
/// - [nome]: Nome comercial do medicamento (ex: "Dipirona Sódica 500mg")
/// - [principioAtivo]: Princípio ativo (ex: "Dipirona Sódica")
///
/// O modelo é imutável e otimizado para serialização JSON eficiente.
class Medicamento {
  final String nome;
  final String principioAtivo;

  const Medicamento({
    required this.nome,
    required this.principioAtivo,
  });

  /// Cria um [Medicamento] a partir de um mapa JSON.
  ///
  /// Espera chaves 'nome' e 'principio_ativo' (snake_case conforme gerado pelo script Python).
  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      nome: json['nome'] as String,
      principioAtivo: json['principio_ativo'] as String,
    );
  }

  /// Converte para mapa JSON (útil para debug ou cache local).
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'principio_ativo': principioAtivo,
    };
  }

  /// Retorna uma string formatada para exibição no autocomplete.
  ///
  /// Exemplo: "Dipirona Sódica 500mg (Dipirona Sódica)"
  String get displayString => '$nome ($principioAtivo)';

  /// Busca case-insensitive em ambos os campos.
  ///
  /// Retorna true se [termo] estiver contido no nome OU no princípio ativo.
  bool matches(String termo) {
    final t = termo.toLowerCase().trim();
    if (t.isEmpty) return true;
    return nome.toLowerCase().contains(t) ||
        principioAtivo.toLowerCase().contains(t);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicamento &&
          runtimeType == other.runtimeType &&
          nome == other.nome &&
          principioAtivo == other.principioAtivo;

  @override
  int get hashCode => nome.hashCode ^ principioAtivo.hashCode;

  @override
  String toString() => 'Medicamento(nome: $nome, principioAtivo: $principioAtivo)';
}
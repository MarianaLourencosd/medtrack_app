/// Dados de perfil que podem ser exibidos para outro usuário.
///
/// O documento completo continua no Firestore, mas a interface compartilhada
/// mostra apenas informações úteis para identificação e atendimento médico.
class PerfilPublico {
  const PerfilPublico({
    required this.uid,
    required this.nome,
    this.idade,
    this.sexo,
    this.tipoSanguineo,
    this.alergias,
    this.condicoesPreexistentes,
    this.medicamentos,
    this.contatoEmergencia,
    this.contatoEmergenciaParentesco,
    this.contatoEmergenciaTelefone,
  });

  final String uid;
  final String nome;
  final String? idade;
  final String? sexo;
  final String? tipoSanguineo;
  final String? alergias;
  final String? condicoesPreexistentes;
  final String? medicamentos;
  final String? contatoEmergencia;
  final String? contatoEmergenciaParentesco;
  final String? contatoEmergenciaTelefone;

  /// Constrói o perfil público a partir dos documentos do Firestore.
  factory PerfilPublico.fromMap(
    String uid,
    Map<String, dynamic> usuario,
    Map<String, dynamic>? formulario,
  ) {
    final dados = <String, dynamic>{...usuario, ...?formulario};

    return PerfilPublico(
      uid: uid,
      nome: _texto(dados['nome']) ?? 'Usuário MedTrack',
      idade: _texto(dados['idade']),
      sexo: _texto(dados['sexo']),
      tipoSanguineo: _texto(dados['tipoSanguineo']),
      alergias: _texto(dados['alergias']),
      condicoesPreexistentes: _texto(dados['condicoesPreexistentes']),
      medicamentos: _texto(dados['medicamentos']),
      contatoEmergencia: _texto(dados['contatoEmergencia']),
      contatoEmergenciaParentesco: _texto(dados['contatoEmergenciaParentesco']),
      contatoEmergenciaTelefone: _texto(dados['contatoEmergenciaTelefone']),
    );
  }

  static String? _texto(dynamic valor) {
    if (valor == null) return null;
    final texto = valor.toString().trim();
    return texto.isEmpty ? null : texto;
  }
}

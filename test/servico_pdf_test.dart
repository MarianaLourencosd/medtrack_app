import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/servicos/servico_pdf.dart';

void main() {
  final servico = ServicoPdf();

  test('gera um PDF válido com o perfil completo', () async {
    final bytes = await servico.gerarBytes({
      'uid': 'usuario123',
      'nome': 'Maria da Silva',
      'email': 'maria@exemplo.com',
      'cpf': '123.456.789-00',
      'dataNascimento': '01/02/1990',
      'idade': 36,
      'sexo': 'Feminino',
      'tipoSanguineo': 'O+',
      'altura': '1.65',
      'peso': '62',
      'imc': 22.8,
      'imcClassificacao': 'Peso adequado',
      'alergias': 'Dipirona',
      'condicoesPreexistentes': 'Asma',
      'medicamentos': 'Budesonida',
      'telefone': '(11) 99999-9999',
      'cartaoSus': '123456789012345',
      'planoSaude': 'SUS',
      'contatoEmergencia': 'João da Silva',
      'contatoEmergenciaParentesco': 'Irmão',
      'contatoEmergenciaTelefone': '(11) 98888-8888',
      'observacoes': 'Usar inalador em crises.',
    });

    expect(bytes, isNotEmpty);
    // Todo PDF começa com a assinatura "%PDF".
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('gera PDF mesmo com perfil vazio', () async {
    final bytes = await servico.gerarBytes(const {});
    expect(bytes, isNotEmpty);
  });
}

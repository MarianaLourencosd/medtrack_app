import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/modelos/lembrete.dart';

void main() {
  final dataFutura = DateTime.now().add(const Duration(days: 1));

  Lembrete criar() => Lembrete(
    id: '123',
    titulo: 'Tomar remédio',
    descricao: '1 comprimido após o almoço',
    dataHora: dataFutura,
    notificacaoId: 42,
  );

  test('converte para mapa e volta sem perder dados', () {
    final original = criar();
    final copia = Lembrete.fromMap(original.toMap());

    expect(copia.id, original.id);
    expect(copia.titulo, original.titulo);
    expect(copia.descricao, original.descricao);
    expect(copia.dataHora, original.dataHora);
    expect(copia.concluido, isFalse);
    expect(copia.notificacaoId, original.notificacaoId);
  });

  test('converte para JSON e volta sem perder dados', () {
    final original = criar();
    final copia = Lembrete.fromJson(original.toJson());

    expect(copia, isNotNull);
    expect(copia!.titulo, original.titulo);
    expect(copia.dataHora, original.dataHora);
  });

  test('ignora JSON inválido', () {
    expect(Lembrete.fromJson('não é json'), isNull);
    expect(Lembrete.fromJson('[]'), isNull);
  });

  test('detecta lembrete atrasado somente quando pendente', () {
    final atrasado = criar().copyWith(
      dataHora: DateTime.now().subtract(const Duration(hours: 2)),
    );
    expect(atrasado.atrasado, isTrue);

    final concluido = atrasado.copyWith(concluido: true);
    expect(concluido.atrasado, isFalse);

    expect(criar().atrasado, isFalse);
  });

  test('copyWith preserva identificadores', () {
    final original = criar();
    final alterado = original.copyWith(titulo: 'Novo título');

    expect(alterado.id, original.id);
    expect(alterado.notificacaoId, original.notificacaoId);
    expect(alterado.titulo, 'Novo título');
  });
}

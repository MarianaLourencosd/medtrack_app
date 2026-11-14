import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/telas/formulario/formulario_screen.dart';

void main() {
  Future<void> abrirFormulario(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TelaFormulario()));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Renderiza tela de formulário com sucesso e exibe campos essenciais',
    (WidgetTester tester) async {
      await abrirFormulario(tester);

      // Cabeçalho
      expect(find.text('MedTrack'), findsOneWidget);
      expect(find.text('PREENCHA O FORMULÁRIO'), findsOneWidget);
      expect(find.text('Seu espaço para cuidar da saúde.'), findsOneWidget);

      // Seções principais
      expect(find.text('Dados Biométricos e Físicos'), findsOneWidget);
      expect(find.text('Informações Médicas'), findsOneWidget);
      expect(find.text('Contatos de Emergência'), findsOneWidget);
      expect(find.text('Medicamentos'), findsOneWidget);
      expect(find.text('Observações Gerais'), findsOneWidget);

      // Campos da seção aberta por padrão (rótulos com * usam RichText).
      expect(find.text('dd/mm/aaaa'), findsOneWidget);
      expect(find.text('Ex: 1.75'), findsOneWidget);
      expect(find.text('Ex: 70'), findsOneWidget);

      await tester.ensureVisible(find.text('Número do cartão'));
      expect(find.text('Número do cartão'), findsOneWidget);

      // Botão de submissão
      await tester.ensureVisible(find.text('Salvar Informações'));
      expect(find.text('Salvar Informações'), findsOneWidget);
    },
  );

  testWidgets('Alterna expansão das seções do formulário', (
    WidgetTester tester,
  ) async {
    await abrirFormulario(tester);

    // Contatos de Emergência começa recolhido.
    final contatosTile = find.text('Contatos de Emergência');
    await tester.ensureVisible(contatosTile);
    await tester.tap(contatosTile);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ex: Maria da Silva'), findsOneWidget);

    // Medicamentos também começa recolhido.
    final medicamentosTile = find.text('Medicamentos');
    await tester.ensureVisible(medicamentosTile);
    await tester.tap(medicamentosTile);
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('Buscar medicamento (nome ou princípio ativo)...'),
      findsOneWidget,
    );
  });

  testWidgets('Alterna o modo escuro no botão da AppBar', (
    WidgetTester tester,
  ) async {
    await abrirFormulario(tester);

    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

    await tester.tap(find.byIcon(Icons.nightlight_round));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
  });

  testWidgets('Valida campos obrigatórios ao salvar formulário vazio', (
    WidgetTester tester,
  ) async {
    await abrirFormulario(tester);

    final salvarBtn = find.text('Salvar Informações');
    await tester.ensureVisible(salvarBtn);
    await tester.tap(salvarBtn);
    await tester.pumpAndSettle();

    expect(find.text('Informe a data'), findsOneWidget);
    expect(find.text('Informe a altura'), findsOneWidget);
    expect(find.text('Informe o peso'), findsOneWidget);
    expect(find.text('Informe o cartão SUS'), findsOneWidget);
  });
}

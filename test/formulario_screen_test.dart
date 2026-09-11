import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/widgets/formulario/formulario_screen.dart';

void main() {
  testWidgets('Renderiza tela de formulário com sucesso e exibe campos essenciais', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FormularioScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica elementos do cabeçalho
    expect(find.text('MedTrack'), findsOneWidget);
    expect(find.text('PREENCHA O FORMULÁRIO'), findsOneWidget);
    expect(find.text('Seu espaço para cuidar da saúde.'), findsOneWidget);

    // Verifica se as seções principais estão presentes
    expect(find.text('Dados Pessoais'), findsOneWidget);
    expect(find.text('Informações Médicas'), findsOneWidget);
    expect(find.text('Contatos de Emergência'), findsOneWidget);
    expect(find.text('Medicamentos'), findsOneWidget);
    expect(find.text('Observações Gerais'), findsOneWidget);

    // Verifica campos de Dados Pessoais
    expect(find.text('Digite seu nome completo'), findsOneWidget);
    expect(find.text('Digite seu CPF'), findsOneWidget);
    expect(find.text('dd/mm/aaaa'), findsOneWidget);
    expect(find.text('Ex: 1.75'), findsOneWidget);
    expect(find.text('Ex: 70'), findsOneWidget);
    expect(find.text('Digite o número do cartão SUS'), findsOneWidget);

    // Verifica botão de submissão
    expect(find.text('Salvar Informações'), findsOneWidget);
  });

  testWidgets('Alterna expansão das seções do formulário', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FormularioScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Rola e clica em 'Contatos de Emergência' para expandir
    final contatosTile = find.text('Contatos de Emergência');
    await tester.ensureVisible(contatosTile);
    await tester.tap(contatosTile);
    await tester.pumpAndSettle();

    // Campo interno agora deve estar visível
    expect(find.text('Ex: Maria da Silva'), findsOneWidget);

    // Rola e clica em 'Medicamentos' para expandir
    final medicamentosTile = find.text('Medicamentos');
    await tester.ensureVisible(medicamentosTile);
    await tester.tap(medicamentosTile);
    await tester.pumpAndSettle();

    // Campo interno de medicamentos visível
    expect(find.text('Liste seus medicamentos regulares (dosagem, horário)...'), findsOneWidget);
  });

  testWidgets('Alterna o modo escuro no botão da AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FormularioScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica ícone de modo escuro inicial
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

    // Clica no botão de tema
    await tester.tap(find.byIcon(Icons.nightlight_round));
    await tester.pumpAndSettle();

    // Agora deve exibir ícone de sol
    expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
  });

  testWidgets('Valida campos obrigatórios ao clicar em Salvar Informações com formulário vazio', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FormularioScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Rola até o botão de salvar se necessário e clica
    final salvarBtn = find.text('Salvar Informações');
    await tester.ensureVisible(salvarBtn);
    await tester.tap(salvarBtn);
    await tester.pumpAndSettle();

    // Deve exibir mensagens de validação
    expect(find.text('Informe seu nome completo'), findsOneWidget);
    expect(find.text('Informe o CPF'), findsOneWidget);
    expect(find.text('Informe a data'), findsOneWidget);
  });
}

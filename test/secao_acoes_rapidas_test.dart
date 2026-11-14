import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/constantes/cores.dart';
import 'package:medtrack_app/recursos/secao_acoes_rapidas.dart';

List<AcaoRapidaItem> _acoes(VoidCallback aoTocar) {
  return [
    AcaoRapidaItem(
      icone: Icons.qr_code_rounded,
      titulo: 'QR Code',
      cor: CoresApp.primary,
      fundo: CoresApp.mint,
      aoTocar: aoTocar,
    ),
    AcaoRapidaItem(
      icone: Icons.share_rounded,
      titulo: 'Compartilhar',
      cor: CoresApp.info,
      fundo: CoresApp.softBlue,
      aoTocar: aoTocar,
    ),
    AcaoRapidaItem(
      icone: Icons.notifications_rounded,
      titulo: 'Lembretes',
      cor: CoresApp.warning,
      fundo: CoresApp.softYellow,
      aoTocar: aoTocar,
    ),
    AcaoRapidaItem(
      icone: Icons.picture_as_pdf_rounded,
      titulo: 'PDF',
      cor: CoresApp.error,
      fundo: CoresApp.softRed,
      aoTocar: aoTocar,
    ),
  ];
}

void main() {
  testWidgets('exibe os quatro atalhos e responde ao toque', (tester) async {
    var tocado = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SecaoAcoesRapidas(acoes: _acoes(() => tocado = 'Lembretes')),
          ),
        ),
      ),
    );

    expect(find.text('Ações rápidas'), findsOneWidget);
    expect(find.text('QR Code'), findsOneWidget);
    expect(find.text('Compartilhar'), findsOneWidget);
    expect(find.text('Lembretes'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);

    await tester.tap(find.text('Lembretes'));
    await tester.pump();

    expect(tocado, 'Lembretes');
  });

  testWidgets('não estoura o layout com fonte ampliada', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!,
          );
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: SecaoAcoesRapidas(acoes: _acoes(() {})),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('usa quatro colunas em telas largas', (tester) async {
    tester.view.physicalSize = const Size(900, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SecaoAcoesRapidas(acoes: _acoes(() {})),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 4);
  });
}

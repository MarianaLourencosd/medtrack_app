import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/telas/lembretes/lembretes_screen.dart';

void main() {
  test('formata data e hora no padrão brasileiro', () {
    final texto = formatarDataHora(DateTime(2026, 3, 9, 7, 5));
    expect(texto, '09 de mar de 2026 às 07:05');
  });

  test('formata meses de dois dígitos corretamente', () {
    final texto = formatarDataHora(DateTime(2026, 12, 25, 23, 59));
    expect(texto, '25 de dez de 2026 às 23:59');
  });
}

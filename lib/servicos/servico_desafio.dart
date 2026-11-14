
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicoDesafio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _referencia(String uid) {
    return _db.collection('desafios').doc(uid);
  }

  String _dataFormatada(DateTime data) {
    return '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';
  }

  String _dataAtual() => _dataFormatada(DateTime.now());

  Future<Map<String, dynamic>> carregarProgresso(String uid) async {
    final referencia = _referencia(uid);
    final hoje = _dataAtual();
    final ontem = _dataFormatada(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    return _db.runTransaction((transaction) async {
      final documento = await transaction.get(referencia);
      final dados = documento.data() ?? {};

      final dias = Map<String, dynamic>.from(dados['dias'] ?? {});
      final dia = Map<String, dynamic>.from(dias[hoje] ?? {});

      final habitos = (dia['habitos'] as List?)
              ?.map((item) => item == true)
              .toList() ??
          List.filled(7, false);

      int sequencia = dados['sequenciaAtual'] ?? 0;
      final ultimoDia = dados['ultimoDiaCompleto'] as String?;

      if (ultimoDia != null &&
          ultimoDia != hoje &&
          ultimoDia != ontem &&
          sequencia != 0) {
        sequencia = 0;

        transaction.set(
          referencia,
          {
            'sequenciaAtual': 0,
            'atualizadoEm': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      return {
        'sequenciaAtual': sequencia,
        'maiorSequencia': dados['maiorSequencia'] ?? 0,
        'xp': dados['xp'] ?? 0,
        'medalha7Dias': dados['medalha7Dias'] ?? false,
        'habitosHoje': habitos,
        'diaRecompensado': dia['recompensaConcedida'] == true,
      };
    });
  }

  Future<void> atualizarHabito({
    required String uid,
    required int indice,
    required bool concluido,
  }) async {
    if (indice < 0 || indice >= 7) {
      throw ArgumentError('Índice de hábito inválido.');
    }

    final referencia = _referencia(uid);
    final hoje = _dataAtual();
    final ontem = _dataFormatada(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    await _db.runTransaction((transaction) async {
      final documento = await transaction.get(referencia);
      final dados = documento.data() ?? {};

      final dias = Map<String, dynamic>.from(dados['dias'] ?? {});
      final dia = Map<String, dynamic>.from(dias[hoje] ?? {});

      if (dia['recompensaConcedida'] == true) {
        return;
      }

      final habitos = List<bool>.from(
        (dia['habitos'] as List?)?.map((item) => item == true) ??
            List.filled(7, false),
      );

      habitos[indice] = concluido;

      final diaCompleto = habitos.every((item) => item);

      dia['habitos'] = habitos;
      dia['concluido'] = diaCompleto;
      dia['atualizadoEm'] = Timestamp.now();

      dias[hoje] = dia;

      int sequencia = dados['sequenciaAtual'] ?? 0;
      int maiorSequencia = dados['maiorSequencia'] ?? 0;
      int xp = dados['xp'] ?? 0;
      bool medalha = dados['medalha7Dias'] ?? false;

      final ultimoDia = dados['ultimoDiaCompleto'] as String?;

      if (ultimoDia != null &&
          ultimoDia != hoje &&
          ultimoDia != ontem) {
        sequencia = 0;
      }

      if (diaCompleto && dia['recompensaConcedida'] != true) {
        sequencia = ultimoDia == ontem ? sequencia + 1 : 1;

        if (sequencia > maiorSequencia) {
          maiorSequencia = sequencia;
        }

        xp += 50;

        if (sequencia >= 7 && !medalha) {
          medalha = true;
          xp += 200;
        }

        dia['recompensaConcedida'] = true;

        transaction.set(
          referencia,
          {
            'ultimoDiaCompleto': hoje,
            'sequenciaAtual': sequencia,
            'maiorSequencia': maiorSequencia,
            'xp': xp,
            'medalha7Dias': medalha,
            'dias': dias,
            'atualizadoEm': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      } else {
        transaction.set(
          referencia,
          {
            'sequenciaAtual': sequencia,
            'dias': dias,
            'atualizadoEm': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
    });
  }
}

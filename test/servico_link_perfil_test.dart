import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack_app/constantes/config_links.dart';
import 'package:medtrack_app/servicos/servico_link_perfil.dart';

void main() {
  const servico = ServicoLinkPerfil();
  const uid = 'usuario123';

  group('geração de link', () {
    test('usa o custom scheme medtrack', () {
      expect(ConfigLinks.linkPerfil(uid), 'medtrack://perfil/$uid');
      expect(servico.gerarLink(uid), 'medtrack://perfil/$uid');
    });

    test('texto de compartilhamento contém o link e o nome', () {
      final texto = servico.textoCompartilhamento(uid, nome: 'Maria');
      expect(texto, contains('Maria'));
      expect(texto, contains('medtrack://perfil/$uid'));
    });
  });

  group('leitura de UID', () {
    test('aceita medtrack://perfil/<uid>', () {
      expect(servico.extrairUid('medtrack://perfil/$uid'), uid);
    });

    test('aceita medtrack://perfil?uid=<uid>', () {
      expect(servico.extrairUid('medtrack://perfil?uid=$uid'), uid);
    });

    test('aceita link HTTPS com /perfil/<uid>', () {
      expect(servico.extrairUid('https://medtrack.app/perfil/$uid'), uid);
    });

    test('aceita JSON com a chave uid', () {
      expect(servico.extrairUid('{"uid":"$uid"}'), uid);
    });

    test('aceita UID puro', () {
      expect(servico.extrairUid('  $uid  '), uid);
    });

    test('aceita o formato antigo medtrack://<uid>', () {
      expect(servico.extrairUid('medtrack://$uid'), uid);
    });

    test('recusa conteúdo inválido', () {
      expect(servico.extrairUid(null), isNull);
      expect(servico.extrairUid(''), isNull);
      expect(servico.extrairUid('apenas um texto qualquer'), isNull);
      expect(servico.extrairUid('medtrack://perfil/'), isNull);
      expect(servico.extrairUid('https://medtrack.app/'), isNull);
      // Host desconhecido com caminho não deve virar UID.
      expect(servico.extrairUid('medtrack://outracoisa/$uid'), isNull);
    });
  });
}

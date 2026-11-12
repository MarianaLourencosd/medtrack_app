import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'servico_link_perfil.dart';

/// Resultado da geração do PDF, incluindo os locais onde ele foi salvo.
class ResultadoPdf {
  const ResultadoPdf({
    required this.bytes,
    required this.nomeArquivo,
    this.caminhoInterno,
    this.caminhoPublico,
  });

  final Uint8List bytes;
  final String nomeArquivo;

  /// Cópia interna do aplicativo (documentos do app).
  final String? caminhoInterno;

  /// Cópia acessível ao usuário (Downloads no Android/desktop ou Arquivos no iOS).
  final String? caminhoPublico;

  bool get salvo => caminhoInterno != null || caminhoPublico != null;
}

/// Gera o PDF completo do perfil e salva as cópias internas e públicas.
class ServicoPdf {
  ServicoPdf({ServicoLinkPerfil? links})
    : _links = links ?? const ServicoLinkPerfil();

  final ServicoLinkPerfil _links;

  static const PdfColor _verde = PdfColor.fromInt(0xFF00614C);
  static const PdfColor _verdeClaro = PdfColor.fromInt(0xFFE6F7F1);
  static const PdfColor _cinza = PdfColor.fromInt(0xFF555555);
  static const PdfColor _borda = PdfColor.fromInt(0xFFDDE5E2);

  /// Gera somente os bytes (usado nos testes e na pré-visualização).
  Future<Uint8List> gerarBytes(Map<String, dynamic> perfil) async {
    final documento = pw.Document(
      title: 'Perfil MedTrack',
      author: 'MedTrack',
      creator: 'MedTrack',
      subject: 'Resumo do perfil de saúde',
    );

    final nome = _texto(perfil['nome']) ?? 'Usuário MedTrack';
    final uid = _texto(perfil['uid']);
    final agora = DateTime.now();
    final geradoEm = DateFormat('dd/MM/yyyy HH:mm').format(agora);

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(34, 34, 34, 40),
        build: (contexto) {
          return [
            _cabecalho(nome, geradoEm),
            pw.SizedBox(height: 18),
            _secao('Identificação', [
              _linha('Nome completo', nome),
              _linha('E-mail', _texto(perfil['email'])),
              _linha('CPF', _texto(perfil['cpf'])),
              _linha('Data de nascimento', _texto(perfil['dataNascimento'])),
              _linha('Idade', _comIdade(perfil['idade'])),
              _linha('Sexo', _texto(perfil['sexo'])),
            ]),
            pw.SizedBox(height: 12),
            _secao('Dados clínicos', [
              _linha('Tipo sanguíneo', _texto(perfil['tipoSanguineo'])),
              _linha('Altura', _comUnidade(perfil['altura'], 'm')),
              _linha('Peso', _comUnidade(perfil['peso'], 'kg')),
              _linha('IMC', _imc(perfil)),
              _linha('Alergias', _texto(perfil['alergias'])),
              _linha(
                'Condições preexistentes',
                _texto(perfil['condicoesPreexistentes']),
              ),
              _linha('Medicamentos em uso', _texto(perfil['medicamentos'])),
            ]),
            pw.SizedBox(height: 12),
            _secao('Contatos', [
              _linha('Telefone / WhatsApp', _texto(perfil['telefone'])),
              _linha('Cartão SUS', _texto(perfil['cartaoSus'])),
              _linha('Plano de saúde', _texto(perfil['planoSaude'])),
              _linha(
                'Contato de emergência',
                _texto(perfil['contatoEmergencia']),
              ),
              _linha(
                'Parentesco',
                _texto(perfil['contatoEmergenciaParentesco']),
              ),
              _linha(
                'Telefone de emergência',
                _texto(perfil['contatoEmergenciaTelefone']),
              ),
            ]),
            pw.SizedBox(height: 12),
            _secao('Observações', [
              _linha('Observações gerais', _texto(perfil['observacoes'])),
            ]),
            pw.SizedBox(height: 18),
            _aviso(uid),
          ];
        },
        footer: (contexto) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 12),
            child: pw.Text(
              'MedTrack - página ${contexto.pageNumber} de ${contexto.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: _cinza),
            ),
          );
        },
      ),
    );

    return documento.save();
  }

  /// Gera o PDF e grava duas cópias:
  /// - interna, na pasta do aplicativo;
  /// - pública, em Downloads (Android/desktop/web) ou Documentos (iOS).
  Future<ResultadoPdf> gerarESalvar(Map<String, dynamic> perfil) async {
    final bytes = await gerarBytes(perfil);
    final nome = _nomeArquivo(perfil);

    String? caminhoInterno;
    String? caminhoPublico;

    if (!kIsWeb) {
      try {
        caminhoInterno = _caminhoValido(
          await FileSaver.instance.saveFile(
            name: nome,
            bytes: bytes,
            fileExtension: '.pdf',
            mimeType: MimeType.pdf,
          ),
        );
      } catch (_) {
        // Sem cópia interna: a cópia pública ainda pode ser gravada.
      }
    }

    // No Android e na web a cópia interna não fica acessível ao usuário, então
    // gravamos também em Downloads. No iOS e no desktop o `saveFile` já usa
    // Documentos/Downloads, ou seja, a mesma cópia serve para os dois fins.
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      try {
        caminhoPublico = _caminhoValido(
          await FileSaver.instance.saveToDownloads(
            name: nome,
            bytes: bytes,
            fileExtension: '.pdf',
            mimeType: MimeType.pdf,
          ),
        );
      } catch (_) {
        // Sem cópia pública: a cópia interna continua disponível.
      }
    } else {
      caminhoPublico = caminhoInterno;
    }

    return ResultadoPdf(
      bytes: bytes,
      nomeArquivo: '$nome.pdf',
      caminhoInterno: caminhoInterno,
      caminhoPublico: caminhoPublico,
    );
  }

  /// Descarta o texto de erro devolvido pelo `file_saver` em vez de lançar.
  static String? _caminhoValido(String? caminho) {
    final texto = caminho?.trim();
    if (texto == null || texto.isEmpty) return null;
    if (texto.startsWith('Something went wrong')) return null;
    return texto;
  }

  pw.Widget _cabecalho(String nome, String geradoEm) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: _verdeClaro,
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: _verde, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'MedTrack',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: _verde,
                ),
              ),
              pw.Text(
                'Perfil de saúde',
                style: const pw.TextStyle(fontSize: 10, color: _cinza),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            nome,
            style: pw.TextStyle(
              fontSize: 17,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'Documento gerado em $geradoEm',
            style: const pw.TextStyle(fontSize: 9, color: _cinza),
          ),
        ],
      ),
    );
  }

  pw.Widget _secao(String titulo, List<pw.Widget?> linhas) {
    final visiveis = linhas.whereType<pw.Widget>().toList(growable: false);
    if (visiveis.isEmpty) return pw.SizedBox.shrink();

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _borda),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            titulo.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _verde,
              letterSpacing: 0.7,
            ),
          ),
          pw.SizedBox(height: 8),
          ...visiveis,
        ],
      ),
    );
  }

  pw.Widget? _linha(String rotulo, String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(
              rotulo,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _cinza,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              valor.trim(),
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _aviso(String? uid) {
    final link = uid == null ? null : _links.gerarLink(uid);

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF7F9F8),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Documento gerado automaticamente pelo MedTrack.',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: _verde,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'As informações são de responsabilidade do usuário. Em caso de '
            'emergência, procure atendimento médico imediatamente.',
            style: const pw.TextStyle(fontSize: 8.5, color: _cinza),
          ),
          if (link != null) ...[
            pw.SizedBox(height: 6),
            pw.Text(
              'Link do perfil: $link',
              style: const pw.TextStyle(fontSize: 8.5, color: _cinza),
            ),
          ],
        ],
      ),
    );
  }

  String _nomeArquivo(Map<String, dynamic> perfil) {
    final nome = _texto(perfil['nome']) ?? 'perfil';
    final limpo = nome
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final base = limpo.isEmpty ? 'perfil' : limpo.toLowerCase();
    final data = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    return 'medtrack_${base}_$data';
  }

  String? _comIdade(dynamic valor) {
    final idade = _texto(valor);
    return idade == null ? null : '$idade anos';
  }

  String? _comUnidade(dynamic valor, String unidade) {
    final texto = _texto(valor);
    return texto == null ? null : '$texto $unidade';
  }

  String? _imc(Map<String, dynamic> perfil) {
    final imc = _texto(perfil['imc']);
    if (imc == null) return null;
    final classificacao = _texto(perfil['imcClassificacao']);
    return classificacao == null ? imc : '$imc ($classificacao)';
  }

  static String? _texto(dynamic valor) {
    if (valor == null) return null;
    final texto = valor.toString().trim();
    return texto.isEmpty ? null : texto;
  }
}

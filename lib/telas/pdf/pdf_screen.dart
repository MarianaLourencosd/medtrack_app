import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../servicos/servico_pdf.dart';
import '../../servicos/servico_perfil.dart';
import '../formulario/formulario_screen.dart';

/// Tela de geração, pré-visualização e salvamento do PDF do perfil.
class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final ServicoPerfil _servicoPerfil = ServicoPerfil();
  final ServicoPdf _servicoPdf = ServicoPdf();

  Map<String, dynamic>? _perfil;
  Uint8List? _bytes;
  ResultadoPdf? _resultado;
  bool _carregando = true;
  bool _gerando = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final perfil = await _servicoPerfil.carregarPerfilCompletoAtual();
    if (!mounted) return;
    setState(() {
      _perfil = perfil;
      // Os bytes e o resultado anteriores podem pertencer a uma versão
      // desatualizada do formulário; força nova geração ao visualizar.
      _bytes = null;
      _resultado = null;
      _carregando = false;
    });
  }

  Future<Uint8List?> _obterBytes() async {
    final perfil = _perfil;
    if (perfil == null) return null;

    if (_bytes != null) return _bytes;
    final bytes = await _servicoPdf.gerarBytes(perfil);
    _bytes = bytes;
    return bytes;
  }

  Future<void> _gerarESalvar() async {
    final perfil = _perfil;
    if (perfil == null || _gerando) return;

    setState(() => _gerando = true);

    try {
      final resultado = await _servicoPdf.gerarESalvar(perfil);
      if (!mounted) return;
      setState(() {
        _resultado = resultado;
        _bytes = resultado.bytes;
      });

      if (resultado.salvo) {
        _mostrarMensagem('PDF gerado e salvo com sucesso.', CoresApp.primary);
      } else {
        _mostrarMensagem(
          'O PDF foi gerado, mas não foi possível salvar o arquivo.',
          CoresApp.warning,
        );
      }
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem(
        'Não foi possível gerar o PDF. Tente novamente.',
        CoresApp.error,
      );
    } finally {
      if (mounted) setState(() => _gerando = false);
    }
  }

  Future<void> _visualizar() async {
    final bytes = await _obterBytes();
    if (bytes == null || !mounted) return;

    try {
      await Printing.layoutPdf(
        name: 'medtrack_perfil.pdf',
        onLayout: (_) async => bytes,
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem(
        'Não foi possível abrir a visualização.',
        CoresApp.error,
      );
    }
  }

  Future<void> _compartilhar() async {
    final bytes = await _obterBytes();
    if (bytes == null || !mounted) return;

    try {
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'medtrack_perfil.pdf',
        subject: 'Meu perfil MedTrack',
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem('Não foi possível compartilhar o PDF.', CoresApp.error);
    }
  }

  void _mostrarMensagem(String texto, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoresApp.primary,
        foregroundColor: CoresApp.white,
        title: const Text('Exportar PDF'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: CoresApp.primary),
            )
          : _perfil == null
          ? _semPerfil()
          : _conteudo(),
    );
  }

  Widget _semPerfil() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: CoresApp.softYellow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: CoresApp.warning,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Preencha seu formulário',
              textAlign: TextAlign.center,
              style: AppTextStyles.tituloCardClaro,
            ),
            const SizedBox(height: 8),
            const Text(
              'O PDF é montado com as informações de saúde do seu formulário. '
              'Preencha os dados para poder exportar.',
              textAlign: TextAlign.center,
              style: AppTextStyles.textoCorpoSecundario,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TelaFormulario()),
              ).then((_) => _carregarPerfil()),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primary,
                foregroundColor: CoresApp.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: const Icon(Icons.edit_document, size: 19),
              label: const Text('Preencher formulário'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conteudo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    final nome = _texto(_perfil?['nome']) ?? 'Usuário MedTrack';
    final resumo = _resumoPerfil(_perfil!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Seu perfil em PDF',
            style: AppTextStyles.tituloSecao.copyWith(color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Gere um documento com todas as suas informações de saúde. Ele '
            'funciona sem internet depois de gerado.',
            style: AppTextStyles.subtituloSecao.copyWith(color: subtitleColor),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: CoresApp.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: CoresApp.softRed,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: CoresApp.error,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.tituloCardClaro.copyWith(
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Perfil completo • ${resumo.itens} informações',
                            style: AppTextStyles.micro.copyWith(
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: resumo.areas
                      .map(
                        (area) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: CoresApp.paleGreen,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            area,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: CoresApp.primary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _gerando ? null : _gerarESalvar,
            style: ElevatedButton.styleFrom(
              backgroundColor: CoresApp.primary,
              foregroundColor: CoresApp.white,
              disabledBackgroundColor: CoresApp.primary.withValues(alpha: 0.45),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: _gerando
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.2,
                    ),
                  )
                : const Icon(Icons.download_rounded, size: 20),
            label: Text(
              _gerando ? 'Gerando PDF...' : 'Gerar e salvar PDF',
              style: AppTextStyles.botaoPequeno,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _visualizar,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.primary,
                    side: const BorderSide(color: CoresApp.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const Text('Visualizar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _compartilhar,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.info,
                    side: const BorderSide(color: CoresApp.info),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Compartilhar'),
                ),
              ),
            ],
          ),
          if (_resultado != null) ...[
            const SizedBox(height: 18),
            _cartaoResultado(_resultado!, isDark),
          ],
          const SizedBox(height: 20),
          _avisoArmazenamento(),
        ],
      ),
    );
  }

  Widget _cartaoResultado(ResultadoPdf resultado, bool isDark) {
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CoresApp.success.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: CoresApp.softGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: CoresApp.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  resultado.nomeArquivo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textoCorpoForte.copyWith(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (resultado.caminhoInterno != null &&
              resultado.caminhoInterno != resultado.caminhoPublico)
            _linhaCaminho('Cópia interna', resultado.caminhoInterno!),
          if (resultado.caminhoPublico != null) ...[
            if (resultado.caminhoInterno != null &&
                resultado.caminhoInterno != resultado.caminhoPublico)
              const SizedBox(height: 6),
            _linhaCaminho(
              resultado.caminhoInterno == resultado.caminhoPublico
                  ? 'Arquivo salvo'
                  : defaultTargetPlatform == TargetPlatform.iOS && !kIsWeb
                  ? 'Arquivos do iPhone'
                  : 'Downloads',
              resultado.caminhoPublico!,
            ),
          ],
          if (!resultado.salvo)
            Text(
              'Não foi possível gravar o arquivo neste dispositivo.',
              style: AppTextStyles.erro,
            ),
        ],
      ),
    );
  }

  Widget _linhaCaminho(String rotulo, String caminho) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rotulo, style: AppTextStyles.labelCategoria),
        const SizedBox(height: 2),
        SelectableText(
          caminho,
          style: AppTextStyles.microEscuro.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _avisoArmazenamento() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CoresApp.softBlue.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.folder_copy_outlined,
            color: CoresApp.info,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'O PDF é salvo em uma pasta do aplicativo e também em Downloads. '
              'No iPhone, ele aparece no app Arquivos, em "Meu iPhone > '
              'MedTrack".',
              style: AppTextStyles.micro.copyWith(color: CoresApp.info),
            ),
          ),
        ],
      ),
    );
  }

  ResumoPdf _resumoPerfil(Map<String, dynamic> perfil) {
    const campos = [
      'nome',
      'email',
      'cpf',
      'dataNascimento',
      'idade',
      'sexo',
      'tipoSanguineo',
      'altura',
      'peso',
      'imc',
      'alergias',
      'condicoesPreexistentes',
      'medicamentos',
      'telefone',
      'cartaoSus',
      'planoSaude',
      'contatoEmergencia',
      'contatoEmergenciaTelefone',
      'observacoes',
    ];

    final preenchidos = campos
        .where((campo) => _texto(perfil[campo]) != null)
        .length;
    final areas = <String>[];

    if (_texto(perfil['tipoSanguineo']) != null) areas.add('Sangue');
    if (_texto(perfil['alergias']) != null) areas.add('Alergias');
    if (_texto(perfil['medicamentos']) != null) areas.add('Medicamentos');
    if (_texto(perfil['condicoesPreexistentes']) != null) {
      areas.add('Condições');
    }
    if (_texto(perfil['contatoEmergencia']) != null) {
      areas.add('Emergência');
    }

    return ResumoPdf(itens: preenchidos, areas: areas);
  }

  static String? _texto(dynamic valor) {
    if (valor == null) return null;
    final texto = valor.toString().trim();
    return texto.isEmpty ? null : texto;
  }
}

class ResumoPdf {
  const ResumoPdf({required this.itens, required this.areas});

  final int itens;
  final List<String> areas;
}

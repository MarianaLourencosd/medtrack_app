import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../recursos/perfil_preview_sheet.dart';
import '../../servicos/servico_compartilhamento.dart';
import '../../servicos/servico_link_perfil.dart';
import '../../servicos/servico_perfil.dart';
import '../perfil/perfil_publico_screen.dart';

/// Tela de QR Code com duas abas: exibir o próprio código e escanear outro.
class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen>
    with SingleTickerProviderStateMixin {
  final ServicoPerfil _perfil = ServicoPerfil();
  final ServicoCompartilhamento _compartilhamento = ServicoCompartilhamento();
  final ServicoLinkPerfil _links = const ServicoLinkPerfil();
  final GlobalKey _botaoCompartilharKey = GlobalKey();

  final MobileScannerController _scanner = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  late final TabController _abas;

  String? _uid;
  String _nome = 'Usuário MedTrack';
  String _link = '';
  bool _carregando = true;
  bool _processandoLeitura = false;
  bool _lanternaLigada = false;
  DateTime? _ultimoAviso;

  @override
  void initState() {
    super.initState();
    _abas = TabController(length: 2, vsync: this);
    _abas.addListener(_aoMudarAba);
    _carregar();
  }

  Future<void> _carregar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _carregando = false);
      return;
    }

    final nome = await _perfil.nomeUsuarioAtual();

    if (!mounted) return;
    setState(() {
      _uid = user.uid;
      _nome = nome;
      _link = _compartilhamento.gerarLink(user.uid);
      _carregando = false;
    });
  }

  void _aoMudarAba() {
    if (_abas.indexIsChanging) return;

    if (_abas.index == 1) {
      _iniciarCamera();
    } else {
      _pararCamera();
    }
  }

  Future<void> _iniciarCamera() async {
    try {
      await _scanner.start();

      // Se o usuário trocou de aba enquanto a câmera iniciava, evita deixá-la
      // ligada em segundo plano.
      if (mounted && _abas.index != 1) {
        await _scanner.stop();
      }
    } catch (_) {
      // Permissão negada ou câmera indisponível: o errorBuilder orienta.
    }
  }

  Future<void> _pararCamera() async {
    try {
      await _scanner.stop();
    } catch (_) {}
  }

  Future<void> _alternarLanterna() async {
    try {
      await _scanner.toggleTorch();
      if (mounted) setState(() => _lanternaLigada = !_lanternaLigada);
    } catch (_) {}
  }

  Future<void> _trocarCamera() async {
    try {
      await _scanner.switchCamera();
    } catch (_) {}
  }

  void _aoDetectar(BarcodeCapture captura) {
    if (_processandoLeitura) return;

    for (final codigo in captura.barcodes) {
      final uid = _links.extrairUid(codigo.rawValue);
      if (uid == null) continue;

      _processandoLeitura = true;
      _pararCamera();
      _abrirPreviaDoPerfil(uid);
      return;
    }

    _avisarQrInvalido();
  }

  /// Mostra a prévia e, se pedido, abre o perfil completo.
  ///
  /// A câmera só volta a ligar quando esta tela está visível novamente.
  Future<void> _abrirPreviaDoPerfil(String uid) async {
    try {
      final abrirCompleto = await abrirPerfilPreview(context, uid: uid);
      if (!mounted) return;

      if (abrirCompleto == true) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TelaPerfilPublico(uid: uid)),
        );
        if (!mounted) return;
      }
    } catch (_) {
      // Falha ao abrir a prévia: a câmera é religada abaixo.
    } finally {
      _processandoLeitura = false;
    }

    if (mounted && _abas.index == 1) {
      _iniciarCamera();
    }
  }

  void _avisarQrInvalido() {
    final agora = DateTime.now();
    if (_ultimoAviso != null && agora.difference(_ultimoAviso!).inSeconds < 3) {
      return;
    }
    _ultimoAviso = agora;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QR Code não reconhecido pelo MedTrack.'),
        backgroundColor: CoresApp.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _copiarLink() async {
    if (_link.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _link));
    if (!mounted) return;
    _mostrarMensagem('Link copiado.', CoresApp.primary);
  }

  Future<void> _compartilhar() async {
    final uid = _uid;
    if (uid == null) return;

    try {
      // No iPad o menu nativo precisa de uma âncora para o popover.
      final box =
          _botaoCompartilharKey.currentContext?.findRenderObject()
              as RenderBox?;
      final origem = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : Rect.fromLTWH(
              0,
              0,
              MediaQuery.sizeOf(context).width,
              MediaQuery.sizeOf(context).height,
            );

      await _compartilhamento.compartilharPerfil(
        uid: uid,
        nome: _nome,
        origem: origem,
      );
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem(
        'Não foi possível abrir o compartilhamento.',
        CoresApp.error,
      );
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
  void dispose() {
    _abas.removeListener(_aoMudarAba);
    _abas.dispose();
    _scanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoresApp.primary,
        foregroundColor: CoresApp.white,
        title: const Text('QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _abas,
          indicatorColor: CoresApp.white,
          indicatorWeight: 3,
          labelColor: CoresApp.white,
          unselectedLabelColor: CoresApp.white.withValues(alpha: 0.7),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.qr_code_2_rounded), text: 'Meu QR'),
            Tab(icon: Icon(Icons.qr_code_scanner_rounded), text: 'Escanear'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _abas,
        children: [_abaMeuQr(), _abaEscanear()],
      ),
    );
  }

  Widget _abaMeuQr() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(color: CoresApp.primary),
      );
    }

    if (_uid == null) {
      return const _Estado(
        icone: Icons.lock_outline_rounded,
        titulo: 'Entre na sua conta',
        mensagem: 'O QR Code é gerado a partir do seu perfil no MedTrack.',
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
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
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: CoresApp.greyLight),
                  ),
                  child: QrImageView(
                    data: _link,
                    version: QrVersions.auto,
                    size: 210,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _nome,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textoCorpoForte,
                ),
                const SizedBox(height: 3),
                const Text(
                  'Mostre este código para compartilhar seu perfil',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.microEscuro,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            key: _botaoCompartilharKey,
            onPressed: _compartilhar,
            style: ElevatedButton.styleFrom(
              backgroundColor: CoresApp.primary,
              foregroundColor: CoresApp.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.share_rounded, size: 20),
            label: const Text(
              'Compartilhar link do perfil',
              style: AppTextStyles.botaoPequeno,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _copiarLink,
            style: OutlinedButton.styleFrom(
              foregroundColor: CoresApp.primary,
              side: const BorderSide(color: CoresApp.primary),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.copy_rounded, size: 19),
            label: const Text('Copiar link'),
          ),
        ],
      ),
    );
  }

  Widget _abaEscanear() {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _scanner,
          onDetect: _aoDetectar,
          errorBuilder: (context, erro) {
            return _Estado(
              icone: Icons.no_photography_rounded,
              titulo: 'Câmera indisponível',
              mensagem:
                  'Permita o acesso à câmera nas configurações do aparelho '
                  'para ler QR Codes.',
              acao: TextButton.icon(
                onPressed: _iniciarCamera,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Tentar novamente'),
                style: TextButton.styleFrom(foregroundColor: CoresApp.primary),
              ),
            );
          },
        ),
        IgnorePointer(
          child: Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.9),
                  width: 3,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CoresApp.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Aponte para o QR Code de outro perfil do MedTrack.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _botaoCamera(
                  icone: _lanternaLigada
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  onTap: _alternarLanterna,
                ),
                const SizedBox(width: 6),
                _botaoCamera(
                  icone: Icons.cameraswitch_rounded,
                  onTap: _trocarCamera,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _botaoCamera({required IconData icone, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icone, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _Estado extends StatelessWidget {
  const _Estado({
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.acao,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoresApp.darkBackground,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 72, color: Colors.white.withValues(alpha: 0.85)),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
            if (acao != null) ...[const SizedBox(height: 16), acao!],
          ],
        ),
      ),
    );
  }
}

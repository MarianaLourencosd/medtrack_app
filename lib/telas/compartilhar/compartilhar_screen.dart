import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../servicos/servico_compartilhamento.dart';
import '../../servicos/servico_perfil.dart';

/// Tela de compartilhamento do próprio perfil.
///
/// Mostra o QR Code, o link copiável e o botão que abre o menu nativo de
/// compartilhamento do sistema.
class CompartilharScreen extends StatefulWidget {
  const CompartilharScreen({super.key});

  @override
  State<CompartilharScreen> createState() => _CompartilharScreenState();
}

class _CompartilharScreenState extends State<CompartilharScreen> {
  final ServicoCompartilhamento _compartilhamento = ServicoCompartilhamento();
  final ServicoPerfil _perfil = ServicoPerfil();
  final GlobalKey _botaoCompartilharKey = GlobalKey();

  String? _uid;
  String _nome = 'Usuário MedTrack';
  String _link = '';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
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

  Future<void> _copiarLink() async {
    if (_link.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _link));
    if (!mounted) return;
    _mostrarMensagem('Link copiado para a área de transferência.');
  }

  Future<void> _compartilhar() async {
    final uid = _uid;
    if (uid == null) return;

    try {
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
      _mostrarMensagem('Não foi possível abrir o compartilhamento.');
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: CoresApp.primary,
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
        title: const Text('Compartilhar perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: CoresApp.primary),
            )
          : _uid == null
          ? _AcessoNecessario(onEntrar: () => Navigator.pop(context))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _cabecalho(),
                  const SizedBox(height: 18),
                  _cartaoQrCode(),
                  const SizedBox(height: 16),
                  _cartaoLink(),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _compartilhar,
                    key: _botaoCompartilharKey,
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
                      'Compartilhar pelo celular',
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
                  const SizedBox(height: 20),
                  _aviso(),
                ],
              ),
            ),
    );
  }

  Widget _cabecalho() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compartilhe seu perfil',
          style: AppTextStyles.tituloSecao.copyWith(color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Envie o link ou mostre o QR Code para que outra pessoa veja suas '
          'informações de saúde no MedTrack.',
          style: AppTextStyles.subtituloSecao.copyWith(color: subtitleColor),
        ),
      ],
    );
  }

  Widget _cartaoQrCode() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return Container(
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
              size: 190,
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _nome,
            textAlign: TextAlign.center,
            style: AppTextStyles.textoCorpoForte,
          ),
          const SizedBox(height: 2),
          const Text(
            'Escaneie para abrir o perfil',
            style: AppTextStyles.microEscuro,
          ),
        ],
      ),
    );
  }

  Widget _cartaoLink() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Seu link', style: AppTextStyles.labelCategoria),
          const SizedBox(height: 8),
          SelectableText(
            _link,
            style: AppTextStyles.micro.copyWith(
              color: textColor,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _aviso() {
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
            Icons.info_outline_rounded,
            color: CoresApp.info,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'O link usa o endereço do MedTrack (medtrack://). Ele funciona '
              'com o aplicativo instalado. Para abrir em qualquer navegador, '
              'será necessário um site hospedado no futuro.',
              style: AppTextStyles.micro.copyWith(color: CoresApp.info),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcessoNecessario extends StatelessWidget {
  const _AcessoNecessario({required this.onEntrar});

  final VoidCallback onEntrar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 68,
              color: CoresApp.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Entre na sua conta',
              style: AppTextStyles.tituloCardClaro,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'É necessário estar logado para compartilhar o seu perfil.',
              style: AppTextStyles.textoCorpoSecundario,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onEntrar, child: const Text('Voltar')),
          ],
        ),
      ),
    );
  }
}

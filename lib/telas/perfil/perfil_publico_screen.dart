import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../modelos/perfil_publico.dart';
import '../../recursos/perfil_publico_conteudo.dart';
import '../../servicos/servico_perfil.dart';

/// Exibe o perfil de outro usuário aberto por QR Code ou deep link.
class TelaPerfilPublico extends StatefulWidget {
  const TelaPerfilPublico({super.key, required this.uid});

  final String uid;

  @override
  State<TelaPerfilPublico> createState() => _TelaPerfilPublicoState();
}

class _TelaPerfilPublicoState extends State<TelaPerfilPublico> {
  final ServicoPerfil _servico = ServicoPerfil();
  late Future<PerfilPublico?> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _servico.carregarPerfilPublico(widget.uid);
  }

  Future<void> _recarregar() async {
    final futuro = _servico.carregarPerfilPublico(widget.uid);
    setState(() {
      _futuro = futuro;
    });

    // Aguarda o término para que o indicador do pull-to-refresh permaneça
    // visível durante a nova consulta.
    try {
      await futuro;
    } catch (_) {
      // O FutureBuilder já apresenta o estado de erro.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoresApp.primary,
        foregroundColor: CoresApp.white,
        title: const Text('Perfil compartilhado'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<PerfilPublico?>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: CoresApp.primary),
            );
          }

          if (snapshot.hasError) {
            return _Estado(
              icone: Icons.wifi_off_rounded,
              titulo: 'Não foi possível carregar',
              mensagem:
                  'Verifique sua conexão. Se o problema continuar, o acesso a '
                  'perfis de outros usuários pode estar bloqueado pelas regras '
                  'do Firestore.',
              onTentarNovamente: _recarregar,
            );
          }

          final perfil = snapshot.data;
          if (perfil == null) {
            return _Estado(
              icone: Icons.person_off_rounded,
              titulo: 'Perfil não encontrado',
              mensagem:
                  'O link pode estar desatualizado ou o usuário foi removido.',
              onTentarNovamente: _recarregar,
            );
          }

          return RefreshIndicator(
            color: CoresApp.primary,
            onRefresh: _recarregar,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: PerfilPublicoConteudo(perfil: perfil),
            ),
          );
        },
      ),
    );
  }
}

class _Estado extends StatelessWidget {
  const _Estado({
    required this.icone,
    required this.titulo,
    required this.mensagem,
    required this.onTentarNovamente,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

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
                color: CoresApp.softRed,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icone, color: CoresApp.error, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: AppTextStyles.tituloCardClaro.copyWith(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: AppTextStyles.textoCorpoSecundario,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh_rounded, size: 19),
              label: const Text('Tentar novamente'),
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
            ),
          ],
        ),
      ),
    );
  }
}

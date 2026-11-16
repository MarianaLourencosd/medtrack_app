import 'package:flutter/material.dart';

import '../../constantes/cores.dart';
import '../../modelos/perfil_publico.dart';
import '../../recursos/perfil_publico_conteudo.dart';
import '../../servicos/servico_perfil.dart';

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

    try {
      await futuro;
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF6F5FA),
      appBar: AppBar(
        backgroundColor: CoresApp.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Perfil compartilhado',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<PerfilPublico?>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _Carregando();
          }

          if (snapshot.hasError) {
            return _Estado(
              icone: Icons.wifi_off_rounded,
              titulo: 'Não foi possível carregar',
              mensagem:
                  'Verifique sua conexão. Se o problema continuar, '
                  'o acesso a perfis de outros usuários pode estar '
                  'bloqueado pelas regras do Firestore.',
              onTentarNovamente: _recarregar,
            );
          }

          final perfil = snapshot.data;

          if (perfil == null) {
            return _Estado(
              icone: Icons.person_off_rounded,
              titulo: 'Perfil não encontrado',
              mensagem:
                  'O link pode estar desatualizado ou o usuário '
                  'foi removido.',
              onTentarNovamente: _recarregar,
            );
          }

          return RefreshIndicator(
            color: CoresApp.primary,
            onRefresh: _recarregar,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: PerfilPublicoConteudo(perfil: perfil),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Carregando extends StatelessWidget {
  const _Carregando();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CoresApp.primary.withOpacity(isDark ? 0.18 : 0.10),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              color: CoresApp.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Carregando perfil...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? CoresApp.darkTextSecondary
                  : const Color(0xFF7A7690),
            ),
          ),
        ],
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

    final corTexto =
        isDark ? CoresApp.darkTextPrimary : const Color(0xFF2A2738);
    final corSecundaria =
        isDark ? CoresApp.darkTextSecondary : const Color(0xFF7A7690);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CoresApp.primary.withOpacity(isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CoresApp.primary.withOpacity(isDark ? 0.26 : 0.16),
                      CoresApp.primary.withOpacity(isDark ? 0.12 : 0.07),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(
                  icone,
                  color: CoresApp.primary,
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: corTexto,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                mensagem,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: corSecundaria,
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 19,
              ),
              label: const Text(
                'Tentar novamente',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
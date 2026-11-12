import 'package:flutter/material.dart';

import '../constantes/cores.dart';
import '../constantes/estilos_texto.dart';
import '../modelos/perfil_publico.dart';
import '../servicos/servico_perfil.dart';
import 'perfil_publico_conteudo.dart';

/// Abre a prévia do perfil lido por QR Code em uma bottom sheet.
///
/// Retorna `true` quando o usuário pediu para abrir o perfil completo.
Future<bool?> abrirPerfilPreview(BuildContext context, {required String uid}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PerfilPreviewSheet(uid: uid),
  );
}

class _PerfilPreviewSheet extends StatefulWidget {
  const _PerfilPreviewSheet({required this.uid});

  final String uid;

  @override
  State<_PerfilPreviewSheet> createState() => _PerfilPreviewSheetState();
}

class _PerfilPreviewSheetState extends State<_PerfilPreviewSheet> {
  final ServicoPerfil _servico = ServicoPerfil();
  late Future<PerfilPublico?> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _servico.carregarPerfilPublico(widget.uid);
  }

  void _recarregar() {
    setState(() {
      _futuro = _servico.carregarPerfilPublico(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fundo = isDark ? CoresApp.darkSurface : CoresApp.surface;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: fundo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: CoresApp.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 6),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: CoresApp.mint.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.badge_rounded,
                        color: CoresApp.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Perfil encontrado',
                        style: AppTextStyles.tituloCardClaro,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fechar',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<PerfilPublico?>(
                  future: _futuro,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: CoresApp.primary,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return _Erro(
                        mensagem:
                            'Não foi possível carregar este perfil. Verifique '
                            'sua conexão e tente novamente.',
                        onTentarNovamente: _recarregar,
                      );
                    }

                    final perfil = snapshot.data;
                    if (perfil == null) {
                      return _Erro(
                        mensagem:
                            'Perfil não encontrado. O link pode estar '
                            'desatualizado ou o usuário removido.',
                        onTentarNovamente: _recarregar,
                      );
                    }

                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PerfilPublicoConteudo(perfil: perfil, compacto: true),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              // A navegação fica a cargo de quem abriu a
                              // prévia, que controla a câmera ao voltar.
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CoresApp.primary,
                              foregroundColor: CoresApp.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(
                              Icons.open_in_new_rounded,
                              size: 19,
                            ),
                            label: const Text(
                              'Abrir perfil completo',
                              style: AppTextStyles.botaoPequeno,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Erro extends StatelessWidget {
  const _Erro({required this.mensagem, required this.onTentarNovamente});

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: CoresApp.softRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.person_off_rounded,
              color: CoresApp.error,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: AppTextStyles.textoCorpoSecundario.copyWith(
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onTentarNovamente,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Tentar novamente'),
            style: OutlinedButton.styleFrom(
              foregroundColor: CoresApp.primary,
              side: const BorderSide(color: CoresApp.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

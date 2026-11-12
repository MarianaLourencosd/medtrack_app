import 'package:flutter/material.dart';

import '../constantes/cores.dart';
import '../constantes/estilos_texto.dart';
import '../modelos/perfil_publico.dart';

/// Conteúdo compartilhado entre a prévia em bottom sheet e a tela de perfil.
class PerfilPublicoConteudo extends StatelessWidget {
  const PerfilPublicoConteudo({
    super.key,
    required this.perfil,
    this.compacto = false,
  });

  final PerfilPublico perfil;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;
    final cardColor = isDark ? CoresApp.darkSurfaceAlt : CoresApp.white;

    final nome = _texto(perfil.nome) ?? 'Usuário MedTrack';
    final iniciais = _iniciais(nome);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: compacto ? 52 : 64,
              height: compacto ? 52 : 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [CoresApp.primary, CoresApp.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                iniciais,
                style: TextStyle(
                  color: CoresApp.white,
                  fontWeight: FontWeight.w800,
                  fontSize: compacto ? 18 : 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (compacto
                                ? AppTextStyles.tituloCardClaro
                                : AppTextStyles.tituloTela)
                            .copyWith(color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Perfil de saúde MedTrack',
                    style: AppTextStyles.micro.copyWith(color: subtitleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (_texto(perfil.tipoSanguineo) != null)
              _ChipInfo(
                icone: Icons.bloodtype_rounded,
                texto: 'Sangue ${perfil.tipoSanguineo}',
                cor: CoresApp.error,
                fundo: CoresApp.softRed,
              ),
            if (_texto(perfil.idade) != null)
              _ChipInfo(
                icone: Icons.cake_rounded,
                texto: '${perfil.idade} anos',
                cor: CoresApp.warning,
                fundo: CoresApp.softYellow,
              ),
            if (_texto(perfil.sexo) != null)
              _ChipInfo(
                icone: Icons.person_rounded,
                texto: perfil.sexo.toString(),
                cor: CoresApp.info,
                fundo: CoresApp.softBlue,
              ),
          ],
        ),
        const SizedBox(height: 16),
        _BlocoInformacoes(
          titulo: 'Informações médicas',
          icone: Icons.favorite_rounded,
          cor: CoresApp.error,
          fundo: cardColor,
          itens: [
            _ItemInfo('Alergias', _texto(perfil.alergias)),
            _ItemInfo(
              'Condições preexistentes',
              _texto(perfil.condicoesPreexistentes),
            ),
            _ItemInfo('Medicamentos', _texto(perfil.medicamentos)),
          ],
        ),
        const SizedBox(height: 12),
        _BlocoInformacoes(
          titulo: 'Contato de emergência',
          icone: Icons.contact_phone_rounded,
          cor: CoresApp.primary,
          fundo: cardColor,
          itens: [
            _ItemInfo('Nome', _texto(perfil.contatoEmergencia)),
            _ItemInfo('Parentesco', _texto(perfil.contatoEmergenciaParentesco)),
            _ItemInfo('Telefone', _texto(perfil.contatoEmergenciaTelefone)),
          ],
        ),
      ],
    );
  }

  static String? _texto(dynamic valor) {
    if (valor == null) return null;
    final texto = valor.toString().trim();
    return texto.isEmpty ? null : texto;
  }

  static String _iniciais(String nome) {
    final partes = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((parte) => parte.isNotEmpty)
        .toList();

    if (partes.isEmpty) return 'MT';
    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }
}

class _ItemInfo {
  const _ItemInfo(this.rotulo, this.valor);

  final String rotulo;
  final String? valor;
}

class _BlocoInformacoes extends StatelessWidget {
  const _BlocoInformacoes({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.fundo,
    required this.itens,
  });

  final String titulo;
  final IconData icone;
  final Color cor;
  final Color fundo;
  final List<_ItemInfo> itens;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtitleColor = isDark
        ? CoresApp.darkTextSecondary
        : CoresApp.textSecondary;

    final visiveis = itens.where((item) => item.valor != null).toList();
    if (visiveis.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icone, color: cor, size: 17),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: AppTextStyles.textoCorpoForte.copyWith(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...visiveis.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.textoCorpoSecundario.copyWith(
                    color: subtitleColor,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: '${item.rotulo}: ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: item.valor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  const _ChipInfo({
    required this.icone,
    required this.texto,
    required this.cor,
    required this.fundo,
  });

  final IconData icone;
  final String texto;
  final Color cor;
  final Color fundo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: cor),
          const SizedBox(width: 5),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

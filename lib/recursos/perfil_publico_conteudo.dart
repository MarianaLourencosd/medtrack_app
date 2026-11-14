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
    final paleta = _Paleta.of(context);
    final nome = _texto(perfil.nome) ?? 'Usuário MedTrack';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cabeçalho do perfil (com informações principais)
        _Cabecalho(
          nome: nome,
          iniciais: _iniciais(nome),
          compacto: compacto,
          paleta: paleta,
          chips: [
            if (_texto(perfil.tipoSanguineo) != null)
              _ChipInfo(
                icone: Icons.bloodtype_rounded,
                texto: 'Sangue ${perfil.tipoSanguineo}',
                cor: CoresApp.error,
                fundo: CoresApp.softRed,
              ),
            if (_texto(perfil.idade) != null)
              _ChipInfo(
                icone: Icons.cake_outlined,
                texto: '${perfil.idade} anos',
                cor: CoresApp.warning,
                fundo: CoresApp.softYellow,
              ),
            if (_texto(perfil.sexo) != null)
              _ChipInfo(
                icone: Icons.person_outline_rounded,
                texto: perfil.sexo.toString(),
                cor: CoresApp.info,
                fundo: CoresApp.softBlue,
              ),
          ],
        ),

        SizedBox(height: compacto ? 14 : 18),

        // Informações médicas
        _BlocoInformacoes(
          titulo: 'Informações médicas',
          subtitulo: 'Dados importantes sobre sua saúde',
          icone: Icons.favorite_outline_rounded,
          cor: CoresApp.error,
          paleta: paleta,
          itens: [
            _ItemInfo(
              'Alergias',
              _texto(perfil.alergias),
              Icons.warning_amber_rounded,
            ),
            _ItemInfo(
              'Condições preexistentes',
              _texto(perfil.condicoesPreexistentes),
              Icons.monitor_heart_outlined,
            ),
            _ItemInfo(
              'Medicamentos',
              _texto(perfil.medicamentos),
              Icons.medication_outlined,
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Contato de emergência
        _BlocoInformacoes(
          titulo: 'Contato de emergência',
          subtitulo: 'Pessoa para contato em situações urgentes',
          icone: Icons.contact_phone_outlined,
          cor: CoresApp.primary,
          paleta: paleta,
          itens: [
            _ItemInfo(
              'Nome',
              _texto(perfil.contatoEmergencia),
              Icons.person_outline_rounded,
            ),
            _ItemInfo(
              'Parentesco',
              _texto(perfil.contatoEmergenciaParentesco),
              Icons.people_outline_rounded,
            ),
            _ItemInfo(
              'Telefone',
              _texto(perfil.contatoEmergenciaTelefone),
              Icons.phone_outlined,
            ),
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

/// Cores derivadas do tema, centralizadas para manter tudo consistente.
class _Paleta {
  const _Paleta({
    required this.isDark,
    required this.texto,
    required this.textoSecundario,
    required this.superficie,
    required this.borda,
    required this.divisor,
  });

  factory _Paleta.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _Paleta(
      isDark: isDark,
      texto: isDark ? CoresApp.darkTextPrimary : const Color(0xFF2A2738),
      textoSecundario:
          isDark ? CoresApp.darkTextSecondary : const Color(0xFF7A7690),
      superficie: isDark ? CoresApp.darkSurfaceAlt : Colors.white,
      borda: isDark ? CoresApp.darkBorder : const Color(0xFFECE9F3),
      divisor: isDark ? CoresApp.darkBorder : const Color(0xFFF1EFF5),
    );
  }

  final bool isDark;
  final Color texto;
  final Color textoSecundario;
  final Color superficie;
  final Color borda;
  final Color divisor;

  List<BoxShadow> get sombra => isDark
      ? const []
      : [
          BoxShadow(
            color: const Color(0xFF1E1A33).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho({
    required this.nome,
    required this.iniciais,
    required this.compacto,
    required this.paleta,
    required this.chips,
  });

  final String nome;
  final String iniciais;
  final bool compacto;
  final _Paleta paleta;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    final alturaFaixa = compacto ? 64.0 : 88.0;
    final raioAvatar = compacto ? 32.0 : 44.0;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: paleta.superficie,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: paleta.borda),
        boxShadow: paleta.sombra,
      ),
      child: Stack(
        children: [
          // Faixa decorativa no topo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: alturaFaixa,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CoresApp.primary,
                    Color.lerp(CoresApp.primary, Colors.white, 0.28)!,
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                compacto ? 22 : 34,
                20,
                compacto ? 18 : 24,
              ),
              child: Column(
                children: [
                  // Avatar com anel na cor da superfície
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: paleta.superficie,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(paleta.isDark ? 0.30 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: raioAvatar,
                      backgroundColor: CoresApp.primary,
                      child: Text(
                        iniciais,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: compacto ? 20 : 26,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: compacto ? 12 : 16),

                  Text(
                    nome,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: (compacto
                            ? AppTextStyles.tituloCardClaro
                            : AppTextStyles.tituloTela)
                        .copyWith(
                      color: paleta.texto,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _Selo(paleta: paleta),

                  if (chips.isNotEmpty) ...[
                    SizedBox(height: compacto ? 14 : 18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: chips,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  const _Selo({required this.paleta});

  final _Paleta paleta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CoresApp.primary.withOpacity(paleta.isDark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 14,
            color: CoresApp.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'Perfil de saúde MedTrack',
            style: AppTextStyles.micro.copyWith(
              color: CoresApp.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemInfo {
  const _ItemInfo(this.rotulo, this.valor, this.icone);

  final String rotulo;
  final String? valor;
  final IconData icone;
}

class _BlocoInformacoes extends StatelessWidget {
  const _BlocoInformacoes({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cor,
    required this.paleta,
    required this.itens,
  });

  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color cor;
  final _Paleta paleta;
  final List<_ItemInfo> itens;

  @override
  Widget build(BuildContext context) {
    final visiveis = itens.where((item) => item.valor != null).toList();

    if (visiveis.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      decoration: BoxDecoration(
        color: paleta.superficie,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: paleta.borda),
        boxShadow: paleta.sombra,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cor.withOpacity(paleta.isDark ? 0.24 : 0.16),
                      cor.withOpacity(paleta.isDark ? 0.10 : 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: cor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: paleta.texto,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        color: paleta.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(height: 1, thickness: 1, color: paleta.divisor),

          for (var i = 0; i < visiveis.length; i++) ...[
            _LinhaInfo(item: visiveis[i], cor: cor, paleta: paleta),
            if (i != visiveis.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 46,
                color: paleta.divisor,
              ),
          ],
        ],
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({
    required this.item,
    required this.cor,
    required this.paleta,
  });

  final _ItemInfo item;
  final Color cor;
  final _Paleta paleta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cor.withOpacity(paleta.isDark ? 0.14 : 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icone, size: 17, color: cor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.rotulo,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: paleta.textoSecundario,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.valor!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: paleta.texto,
                  ),
                ),
              ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? cor.withOpacity(0.16) : fundo,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: cor.withOpacity(isDark ? 0.28 : 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 15, color: cor),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}
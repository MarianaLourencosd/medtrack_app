import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constantes/cores.dart';
import '../constantes/estilos_texto.dart';

class TelaEmConstrucao extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color cor;

  const TelaEmConstrucao({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkBackground : CoresApp.background;
    final surfaceCard = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final iconColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final tituloTelaColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;
    final tituloCardColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final corpoSecundarioColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Espacamentos.paddingTela),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: surfaceCard,
                        borderRadius:
                            BorderRadius.circular(Espacamentos.bordaMedia),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: iconColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: Espacamentos.medio),
                  Expanded(
                    child: Text(
                      titulo,
                      style: AppTextStyles.tituloTela
                          .copyWith(color: tituloTelaColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Espacamentos.grande),
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius:
                      BorderRadius.circular(Espacamentos.bordaEnorme),
                  boxShadow: [
                    BoxShadow(
                      color: cor.withValues(alpha: isDark ? 0.40 : 0.30),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/images/fundo-header.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CoresApp.white.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CoresApp.white.withValues(alpha: 0.35),
                            width: 2,
                          ),
                        ),
                        child: Icon(icone, size: 50, color: CoresApp.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Espacamentos.grande),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ops! Estamos preparando tudo por aqui',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.tituloCardClaro.copyWith(
                          fontSize: 20,
                          color: tituloCardColor,
                        ),
                      ),
                      const SizedBox(height: Espacamentos.pequeno),
                      Text(
                        subtitulo,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtituloSecao
                            .copyWith(color: subtituloColor),
                      ),
                      const SizedBox(height: Espacamentos.normal),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Espacamentos.normal,
                          vertical: Espacamentos.pequeno,
                        ),
                        decoration: BoxDecoration(
                          color: cor.withValues(alpha: isDark ? 0.20 : 0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                size: 14, color: cor),
                            const SizedBox(width: Espacamentos.micro),
                            Text(
                              'Novidade em breve',
                              style: AppTextStyles.micro.copyWith(
                                color: cor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Espacamentos.normal),
                      Text(
                        'Em breve você terá acesso a todos os recursos desta área. Estamos trabalhando para oferecer a melhor experiência para você.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textoCorpoSecundario.copyWith(
                          height: 1.5,
                          color: corpoSecundarioColor,
                        ),
                      ),
                      const SizedBox(height: Espacamentos.grande),
                      _buildInfoRow(
                        context: context,
                        icon: Icons.schedule_rounded,
                        titulo: 'Disponível em breve',
                        descricao:
                            'Estamos finalizando os últimos detalhes',
                        cor: cor,
                      ),
                      const SizedBox(height: Espacamentos.pequeno),
                      _buildInfoRow(
                        context: context,
                        icon: Icons.verified_rounded,
                        titulo: 'Qualidade garantida',
                        descricao:
                            'Tudo sendo testado com muito cuidado',
                        cor: cor,
                      ),
                      const SizedBox(height: Espacamentos.pequeno),
                      _buildInfoRow(
                        context: context,
                        icon: Icons.favorite_rounded,
                        titulo: 'Feito para você',
                        descricao:
                            'Pensado para facilitar o seu dia a dia',
                        cor: cor,
                      ),
                      const SizedBox(height: Espacamentos.grande),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Espacamentos.normal,
                          vertical: Espacamentos.pequeno,
                        ),
                        decoration: BoxDecoration(
                          color: cor.withValues(alpha: isDark ? 0.22 : 0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.construction_rounded,
                                size: 16, color: cor),
                            const SizedBox(width: Espacamentos.micro),
                            Text(
                              'Em construção',
                              style: AppTextStyles.micro.copyWith(color: cor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Espacamentos.normal),
              SizedBox(
                width: double.infinity,
                height: Espacamentos.alturaBotao,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cor,
                    foregroundColor: CoresApp.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Espacamentos.bordaNormal),
                    ),
                  ),
                  child: const Text('Voltar', style: AppTextStyles.botao),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String titulo,
    required String descricao,
    required Color cor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor =
        isDark ? CoresApp.darkBorder : cor.withValues(alpha: 0.15);
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final descColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Espacamentos.normal,
        vertical: Espacamentos.medio,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(Espacamentos.bordaMedia),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cor.withValues(alpha: isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: cor),
          ),
          const SizedBox(width: Espacamentos.medio),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppTextStyles.micro.copyWith(
                    color: tituloColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  descricao,
                  style: AppTextStyles.micro.copyWith(
                    color: descColor,
                    fontSize: 11,
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

class TelaMedicamentos extends StatelessWidget {
  const TelaMedicamentos({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Medicamentos',
        subtitulo: 'Seus remédios e horários',
        icone: Icons.medication_rounded,
        cor: CoresApp.primary,
      );
}

class TelaInformacoes extends StatelessWidget {
  const TelaInformacoes({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Informações',
        subtitulo: 'Seus dados de saúde',
        icone: Icons.description_rounded,
        cor: CoresApp.secondary,
      );
}

class TelaCarteira extends StatelessWidget {
  const TelaCarteira({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Carteira Digital',
        subtitulo: 'Seus documentos de saúde',
        icone: Icons.badge_rounded,
        cor: CoresApp.primaryDark,
      );
}

class TelaQrCode extends StatelessWidget {
  const TelaQrCode({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'QR Code',
        subtitulo: 'Compartilhe seus dados com um toque',
        icone: Icons.qr_code_rounded,
        cor: CoresApp.primary,
      );
}

class TelaCompartilhar extends StatelessWidget {
  const TelaCompartilhar({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Compartilhar',
        subtitulo: 'Envie seus dados com segurança',
        icone: Icons.share_rounded,
        cor: CoresApp.info,
      );
}

class TelaLembretes extends StatelessWidget {
  const TelaLembretes({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Lembretes',
        subtitulo: 'Nunca esqueça seus medicamentos',
        icone: Icons.notifications_rounded,
        cor: CoresApp.warning,
      );
}

class TelaPdf extends StatelessWidget {
  const TelaPdf({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'PDF',
        subtitulo: 'Exporte seus dados de saúde',
        icone: Icons.picture_as_pdf_rounded,
        cor: CoresApp.error,
      );
}

class TelaImc extends StatelessWidget {
  const TelaImc({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'IMC',
        subtitulo: 'Acompanhe seu índice corporal',
        icone: Icons.fitness_center_rounded,
        cor: CoresApp.primary,
      );
}

class TelaHospitais extends StatelessWidget {
  const TelaHospitais({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Hospitais',
        subtitulo: 'Encontre informações de hospitais',
        icone: Icons.local_hospital_rounded,
        cor: CoresApp.info,
      );
}

class TelaContato extends StatelessWidget {
  const TelaContato({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Contato',
        subtitulo: 'Acesse seus contatos importantes',
        icone: Icons.phone_rounded,
        cor: CoresApp.secondary,
      );
}

class TelaTipoSanguineo extends StatelessWidget {
  const TelaTipoSanguineo({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Tipo Sanguíneo',
        subtitulo: 'Consulte seu tipo sanguíneo',
        icone: Icons.bloodtype_rounded,
        cor: CoresApp.error,
      );
}

class TelaAlergias extends StatelessWidget {
  const TelaAlergias({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Alergias',
        subtitulo: 'Consulte suas alergias',
        icone: Icons.healing_rounded,
        cor: CoresApp.warning,
      );
}

class TelaPlanoSaude extends StatelessWidget {
  const TelaPlanoSaude({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Plano de Saúde',
        subtitulo: 'Acesse seus dados do plano',
        icone: Icons.medical_services_rounded,
        cor: CoresApp.info,
      );
}

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Sobre',
        subtitulo: 'Conheça mais sobre o MedTrack',
        icone: Icons.info_rounded,
        cor: CoresApp.primary,
      );
}

class TelaAjuda extends StatelessWidget {
  const TelaAjuda({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Ajuda',
        subtitulo: 'Precisa de ajuda? Estamos aqui',
        icone: Icons.help_rounded,
        cor: CoresApp.info,
      );
}

class TelaFacebook extends StatelessWidget {
  const TelaFacebook({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Facebook',
        subtitulo: 'Siga o MedTrack no Facebook',
        icone: Icons.facebook_rounded,
        cor: CoresApp.info,
      );
}

class TelaInstagram extends StatelessWidget {
  const TelaInstagram({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Instagram',
        subtitulo: 'Siga o MedTrack no Instagram',
        icone: Icons.camera_alt_rounded,
        cor: CoresApp.secondary,
      );
}

class TelaYouTube extends StatelessWidget {
  const TelaYouTube({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'YouTube',
        subtitulo: 'Assista nossos vídeos no YouTube',
        icone: Icons.play_circle_fill_rounded,
        cor: CoresApp.error,
      );
}

class TelaTwitter extends StatelessWidget {
  const TelaTwitter({super.key});
  @override
  Widget build(BuildContext context) => const TelaEmConstrucao(
        titulo: 'Twitter',
        subtitulo: 'Acompanhe o MedTrack no Twitter',
        icone: Icons.close_rounded,
        cor: CoresApp.primaryDark,
      );
}
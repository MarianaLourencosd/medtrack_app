import 'package:flutter/material.dart';

import 'cores.dart';

class AppTextStyles {
  static const String fontMontserrat = 'Montserrat';
  static const String fontKarla = 'Karla';
  static const String fontSpectral = 'Spectral';

  static const TextStyle tituloTelaGigante = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    letterSpacing: -0.6,
    height: 1.15,
  );
  static const TextStyle tituloTelaGrande = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    letterSpacing: -0.5,
    height: 1.2,
  );
  static const TextStyle tituloTela = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    letterSpacing: -0.4,
    height: 1.25,
  );
  static const TextStyle subtituloTela = TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w500,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.5,
  );
  static const TextStyle saudacao = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w800,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    letterSpacing: -0.5,
    height: 1.2,
  );
  static const TextStyle subtituloSaudacao = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.4,
  );
  static const TextStyle nomeUsuario = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
  );
  static const TextStyle tituloSecao = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    letterSpacing: -0.3,
    height: 1.25,
  );
  static const TextStyle subtituloSecao = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.4,
  );
  static const TextStyle acaoSecao = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: CoresApp.primary,
    fontFamily: fontMontserrat,
    letterSpacing: 0.1,
  );
  static const TextStyle tituloCardEscuro = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    height: 1.2,
    letterSpacing: -0.2,
  );
  static const TextStyle subtituloCardEscuro = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    height: 1.35,
  );
  static const TextStyle kpiCardEscuro = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: -0.5,
  );
  static const TextStyle tituloCardClaro = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    height: 1.2,
    letterSpacing: -0.2,
  );
  static const TextStyle subtituloCardClaro = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.4,
  );
  static const TextStyle descricaoCardClaro = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.45,
  );
  static const TextStyle kpiCardClaro = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: CoresApp.primary,
    fontFamily: fontMontserrat,
    letterSpacing: -0.5,
  );
  static const TextStyle tituloResumo = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: -0.2,
  );
  static const TextStyle textoResumo = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    height: 1.4,
  );
  static const TextStyle labelCategoria = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    height: 1.3,
  );
  static const TextStyle labelCategoriaAtiva = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    color: CoresApp.primary,
    fontFamily: fontMontserrat,
    height: 1.3,
  );
  static const TextStyle textoCorpo = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    height: 1.5,
  );
  static const TextStyle textoCorpoForte = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    height: 1.45,
  );
  static const TextStyle textoCorpoSecundario = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.5,
  );
  static const TextStyle textoDestaque = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CoresApp.primary,
    fontFamily: fontMontserrat,
    height: 1.4,
  );
  static const TextStyle inputTexto = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    height: 1.3,
  );
  static const TextStyle inputHint = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: CoresApp.textMuted,
    fontFamily: fontMontserrat,
  );
  static const TextStyle labelInput = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CoresApp.textPrimary,
    fontFamily: fontMontserrat,
    letterSpacing: 0.1,
  );
  static const TextStyle botao = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: 0.3,
  );
  static const TextStyle botaoGrande = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: 0.4,
  );
  static const TextStyle botaoPequeno = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: 0.2,
  );
  static const TextStyle botaoTexto = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: CoresApp.primary,
    fontFamily: fontMontserrat,
    letterSpacing: 0.1,
  );
  static const TextStyle chip = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: CoresApp.primary,
    fontFamily: fontMontserrat,
    letterSpacing: 0.1,
  );
  static const TextStyle chipEscuro = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: 0.1,
  );
  static const TextStyle badge = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w800,
    color: CoresApp.white,
    fontFamily: fontMontserrat,
    letterSpacing: 0.2,
  );
  static const TextStyle legenda = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.4,
  );
  static const TextStyle micro = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: CoresApp.textSecondary,
    fontFamily: fontMontserrat,
    height: 1.35,
  );
  static const TextStyle microEscuro = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: CoresApp.textMuted,
    fontFamily: fontMontserrat,
    height: 1.35,
  );
  static const TextStyle erro = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CoresApp.error,
    fontFamily: fontMontserrat,
  );
  static const TextStyle sucesso = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CoresApp.success,
    fontFamily: fontMontserrat,
  );
  static const TextStyle titleHeader = TextStyle(
    fontSize: 51,
    fontWeight: FontWeight.w700,
    color: CoresApp.textPrimary,
    fontFamily: fontSpectral,
  );
  static const TextStyle titleHeaderSpan = TextStyle(
    fontSize: 51,
    fontWeight: FontWeight.w700,
    color: CoresApp.primary,
    fontFamily: fontSpectral,
  );
  static const TextStyle textHeader = TextStyle(
    fontSize: 16,
    color: CoresApp.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );
  static const TextStyle headerNumber = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    color: CoresApp.textPrimary,
    fontFamily: fontKarla,
  );
  static const TextStyle headerInfoText = TextStyle(
    fontSize: 15,
    color: CoresApp.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );
  static const TextStyle titleCardInfo = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: CoresApp.textPrimary,
    fontFamily: fontSpectral,
  );
  static const TextStyle titleInfoDestaque = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CoresApp.textPrimary,
    fontFamily: fontKarla,
  );
  static const TextStyle textInfoDestaque = TextStyle(
    fontSize: 16,
    color: CoresApp.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );
  static const TextStyle titleCardTestimonial = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: CoresApp.textPrimary,
    fontFamily: fontSpectral,
  );
  static const TextStyle cardNameTestimonial = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CoresApp.textPrimary,
    fontFamily: fontKarla,
  );
  static const TextStyle cardTextTestimonial = TextStyle(
    fontSize: 16,
    color: CoresApp.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );
  static const TextStyle footerLink = TextStyle(
    fontSize: 16,
    color: CoresApp.white,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );
  static const TextStyle copyright = TextStyle(
    fontSize: 16,
    color: CoresApp.white,
    fontFamily: fontKarla,
  );
  static const TextStyle navbarItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CoresApp.black,
    fontFamily: fontMontserrat,
  );
  static const TextStyle logotipo = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    color: CoresApp.black,
    fontFamily: fontKarla,
  );
}

class Espacamentos {
  static const double micro = 4;
  static const double pequeno = 8;
  static const double medio = 12;
  static const double normal = 16;
  static const double grande = 20;
  static const double extraGrande = 24;
  static const double enorme = 32;
  static const double gigante = 40;
  static const double bordaMicro = 6;
  static const double bordaPequena = 10;
  static const double bordaMedia = 14;
  static const double bordaNormal = 18;
  static const double bordaGrande = 22;
  static const double bordaExtraGrande = 26;
  static const double bordaEnorme = 30;
  static const double bordaGigante = 36;
  static const double bordaRedonda = 100;
  static const double alturaBotao = 58;
  static const double alturaBotaoGrande = 62;
  static const double alturaInput = 58;
  static const double alturaAppBar = 62;
  static const double alturaCardHorizontal = 175;
  static const double larguraCardHorizontal = 200;
  static const double alturaImagemTopo = 190;
  static const double paddingTela = 20;
  static const double paddingCard = 18;
  static const double paddingCardPequeno = 14;
}

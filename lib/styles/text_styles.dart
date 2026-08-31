import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTextStyles {
  static const String fontMontserrat = 'Montserrat';
  static const String fontKarla = 'Karla';
  static const String fontSpectral = 'Spectral';

  static const TextStyle titleHeader = TextStyle(
    fontSize: 51,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: fontSpectral,
  );

  static const TextStyle titleHeaderSpan = TextStyle(
    fontSize: 51,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    fontFamily: fontSpectral,
  );

  static const TextStyle textHeader = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );

  static const TextStyle headerNumber = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontKarla,
  );

  static const TextStyle headerInfoText = TextStyle(
    fontSize: 15,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );

  static const TextStyle titleCardInfo = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: fontSpectral,
  );

  static const TextStyle titleInfoDestaque = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontKarla,
  );

  static const TextStyle textInfoDestaque = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );

  static const TextStyle titleCardTestimonial = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: fontSpectral,
  );

  static const TextStyle cardNameTestimonial = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontKarla,
  );

  static const TextStyle cardTextTestimonial = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );

  static const TextStyle footerLink = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    fontWeight: FontWeight.w400,
    fontFamily: fontMontserrat,
  );

  static const TextStyle copyright = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    fontFamily: fontKarla,
  );

  static const TextStyle navbarItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontMontserrat,
  );

  static const TextStyle logotipo = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontKarla,
  );
}
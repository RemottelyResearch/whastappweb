import 'package:flutter/material.dart';

class AppColors {
  static const Color corPrimaria = Color(0xff075E54);
  static const Color corDestaque = Color(0xff25D366);
  static const Color corFundo = Color(0xffD9DBD5);
  static const Color corFundoBarra = Color(0xffededed);
  static const Color corFundoBarraClaro = Color(0xfff6f6f6);
}

final ThemeData temaPadrao = ThemeData(
    primaryColor: AppColors.corPrimaria,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.corDestaque));

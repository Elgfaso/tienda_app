import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';


class AppTextStyle {
  AppTextStyle._();
  static TextStyle label({double fontSize = 14, Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.nunito(
      color: color ?? AppColors.textColor,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }
  static TextStyle get  titleAppBar{
    return GoogleFonts.nunito(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: Colors.white,

    textTheme: GoogleFonts.titilliumWebTextTheme().copyWith(
      bodyMedium: AppTextStyle.label(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      surfaceTintColor: AppColors.secondColor,
      iconTheme: IconThemeData(color: AppColors.backgroundColor),
      centerTitle: true,
      titleTextStyle: AppTextStyle.titleAppBar,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      secondary: AppColors.secondColor,
      onSecondary: Colors.white,
      error: AppColors.errorColor,
      onError: Colors.white,

      surface: AppColors.backgroundColor,
      onSurface: AppColors.textColor,
    ),
    useMaterial3: true,
  );
}

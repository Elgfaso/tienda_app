
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_style.dart';
import '../utils/dimens.dart';

class LocalButton extends StatelessWidget {
  const LocalButton(
    this.text, {
    super.key,
    this.onTap,
    this.padding,
    this.width,
    this.style,
    this.borderRadius,
    this.height,
    this.backgroundColor,
    this.icon,
    this.bordered = false,
  });
  final bool bordered;
  final String text;
  final double? width;
  final double? height;
  final TextStyle? style;
  final Color? backgroundColor;
  //final double? textSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final void Function()? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          side: bordered ? BorderSide(color: AppColors.primaryColor) : null,
          //animationDuration: const Duration(milliseconds: 500),
          shadowColor: Colors.transparent,
          overlayColor: backgroundColor != null
              ? AppColors.primaryColor
              : bordered
              ? AppColors.secondColor
              : AppColors.backgroundColor,
          elevation: 0,
          backgroundColor: bordered ? Colors.transparent : backgroundColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          padding:
              padding ??
              EdgeInsets.symmetric(
                vertical: hSpaceSmall,
              ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style:
                  style ??
                  AppTextStyle.label(
                    fontSize: padding != null ? 22 : 20,
                    color: bordered ? AppColors.primaryColor : Colors.white,
                  ),
            ),
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  icon,
                  color: AppColors.backgroundColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

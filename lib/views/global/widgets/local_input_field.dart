import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_style.dart';

class LocalTextInputField extends StatelessWidget {
  const LocalTextInputField({
    super.key,
    this.controller,
    this.inputType = TextInputType.text,
    this.focusNode,
    this.onEditingComplete,
    this.icon,
    this.label,
    this.textInputAction = TextInputAction.next,
    this.hint,
    this.validator,
    this.onChanged,
  });
  final TextEditingController? controller;
  final TextInputType inputType;
  final FocusNode? focusNode;
  final Widget? icon;
  final String? label;
  final String? hint;
  final TextInputAction textInputAction;

  final void Function()? onEditingComplete;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTextStyle.label(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        TextFormField(
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          controller: controller,
          style: AppTextStyle.label(fontSize: 20),
          keyboardType: inputType,
          focusNode: focusNode,
          validator: validator,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            prefixIcon: icon,
            prefixIconConstraints: const BoxConstraints(
              minHeight: 32,
              maxWidth: 32,
            ),
            prefixIconColor: AppColors.hintTextColor,
            isDense: true,
            fillColor: Colors.white,
            //HINT
            hintText: label ?? hint,
            hintStyle: AppTextStyle.label(
              color: AppColors.hintTextColor,
              fontSize: 18,
            ),
            //BORDES
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

InputDecoration getAuthenticationInputDecoration(String label, BuildContext context) {
  final themeMode = AdaptiveTheme.of(context).mode;

  Color borderColor;

  if (themeMode == AdaptiveThemeMode.light) {
    borderColor = Colors.black87;
  } else {
    borderColor = Colors.white54;
  }
  return InputDecoration(
    hintText: label,
    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: BorderSide(color: borderColor, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    )
  );
  
}
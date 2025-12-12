import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppText {
  // Headings used on home screen
  static TextStyle heading = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Body text for descriptions
  static TextStyle body = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  // Button text
  static TextStyle button = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Small grey text (subtitle)
  static TextStyle smallGrey = const TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );
}

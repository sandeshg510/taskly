import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Main Palette
  static const Color primaryColor = Color(
    0xFF6A1B9A,
  ); // Deep Purple - a vibrant, rich primary
  static const Color accentColor = Color(
    0xFFFFC107,
  ); // Amber - bright, energetic accent
  static const Color secondaryColor = Color(
    0xFF00BCD4,
  ); // Cyan - cool, refreshing secondary
  static const Color successColor = Color(0xFF4CAF50); // Green for success
  static const Color warningColor = Color(0xFFFF9800); // Orange for warning
  static const Color errorColor = Color(0xFFEF5350); // Red for errors

  // Neutral Colors (still important for balance)
  static const Color blackColor = Color(0xFF212121);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static Color greyColor = Color(0xFF9E9E9E);
  static const Color lightGreyColor = Color(0xFFF5F5F5);

  // Backgrounds
  static const Color backgroundColor = Color(0xFFFFFFFF);

  static const Color cardColor = Color(0xFFFFFFFF); // White cards for contrast

  // Priority Colors (can be distinct or derived from the main palette)
  static const Color highPriorityColor = Color(0xFFE53935); // Strong Red
  static const Color mediumPriorityColor = Color(0xFFFFB300); // Vivid Orange
  static const Color lowPriorityColor = Color(0xFF43A047); // Bright Green
  static const Color beigeColor = Color(0xFFfebd93);
  static const Color lightBlueColor = Color(0xFF91e0fe);
  static const Color purpleColor = Color(0xFF6373f7);
  static const Color lightYellowColor = Color(0xFFFFD700);

  static const orangeColor = Color(0xFFFF9100);
  static const turquoiseColor = Color(0xFF00E5FF);
  static const magentaColor = Color(0xFFFF4081);

  // Gradient
  static const LinearGradient welcomeScreenGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.beigeColor,
      AppColors.lightBlueColor,
      Colors.lightBlue,
      AppColors.purpleColor,
    ],
    stops: [0.165, 0.4, 0.7, 2.5],
  );
}

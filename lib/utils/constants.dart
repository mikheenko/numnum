import 'package:flutter/material.dart';

// App Colors - DEPRECATED - use ColorManager instead
class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color secondary = Color(0xFFFF9800);
  static const Color accent = Color(0xFF2196F3);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFF3E5AB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Светлая тема (по умолчанию) - DEPRECATED
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceVariant = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color tertiary = Color(0xFFEEEEEE);
  
  // Player colors for duel mode
  static const Color player1 = Color(0xFF4CAF50);
  static const Color player2 = Color(0xFFE53935);
}

// Typography - цвета теперь устанавливаются динамически
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle keyboard = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle equation = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle equationOperator = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
}

// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// Border Radius
class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static BorderRadius get extraSmall => BorderRadius.circular(xs);
  static BorderRadius get small => BorderRadius.circular(sm);
  static BorderRadius get medium => BorderRadius.circular(md);
  static BorderRadius get large => BorderRadius.circular(lg);
  static BorderRadius get extraLarge => BorderRadius.circular(xl);
}

// Button Dimensions
class AppButtonDimensions {
  static const double heightLarge = 56.0;
  static const double heightMedium = 48.0;
  static const double heightSmall = 40.0;
  static const double keyboardButton = 40.0;
}

// App Constants
class AppConstants {
  static const int totalQuestions = 10;
  static const int maxInputLength = 3;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration keyboardAnimationDuration = Duration(milliseconds: 80);
  static const Duration shakeAnimationDuration = Duration(milliseconds: 500);
  static const Duration errorDisplayDuration = Duration(milliseconds: 500);
  static const Duration successDisplayDuration = Duration(seconds: 2);
  static const Duration waveInterval = Duration(seconds: 15);
} 
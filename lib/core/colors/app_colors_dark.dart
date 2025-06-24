import 'package:flutter/material.dart';
import 'app_color_tokens.dart';

/// Dark theme color implementation
class AppColorsDark implements AppColorTokens {
  // Primary colors
  @override
  Color get primary => const Color(0xFF66BB6A);
  
  @override
  Color get primaryDark => const Color(0xFF388E3C);
  
  @override
  Color get primaryLight => const Color(0xFF81C784);
  
  // Secondary colors
  @override
  Color get secondary => const Color(0xFF42A5F5);
  
  @override
  Color get secondaryDark => const Color(0xFF1976D2);
  
  @override
  Color get secondaryLight => const Color(0xFF64B5F6);
  
  // Background colors
  @override
  Color get background => const Color(0xFF121212);
  
  @override
  Color get surface => const Color(0xFF1E1E1E);
  
  @override
  Color get surfaceVariant => const Color(0xFF2C2C2C);
  
  // Text colors
  @override
  Color get onBackground => const Color(0xFFE0E0E0);
  
  @override
  Color get onSurface => const Color(0xFFE0E0E0);
  
  @override
  Color get onSurfaceVariant => const Color(0xFFB0B0B0);
  
  @override
  Color get onPrimary => const Color(0xFF000000);
  
  @override
  Color get onSecondary => const Color(0xFF000000);
  
  // State colors
  @override
  Color get success => const Color(0xFF66BB6A);
  
  @override
  Color get successLight => const Color(0xFF1B3B1B);
  
  @override
  Color get warning => const Color(0xFFFFB74D);
  
  @override
  Color get warningLight => const Color(0xFF3E2B1F);
  
  @override
  Color get error => const Color(0xFFEF5350);
  
  @override
  Color get errorLight => const Color(0xFF3B1F1F);
  
  // Border and divider colors
  @override
  Color get border => const Color(0xFF404040);
  
  @override
  Color get borderLight => const Color(0xFF2C2C2C);
  
  @override
  Color get divider => const Color(0xFF505050);
  
  // Special colors
  @override
  Color get tertiary => const Color(0xFF2C2C2C);
  
  @override
  Color get player1 => const Color(0xFF66BB6A);
  
  @override
  Color get player2 => const Color(0xFFEF5350);
  
  @override
  Color get disabled => const Color(0xFF505050);
  
  // Table colors
  @override
  Color get tableEmpty => const Color(0xFF383838); // Темно-серый для незаполненных ячеек
  
  // UI Element colors
  @override
  Color get cardBackground => const Color(0xFF1E1E1E); // Темный фон карточек
  
  @override
  Color get screenBackground => const Color(0xFF121212); // Черный фон экранов
  
  @override
  Color get tabBackground => const Color(0xFF1E1E1E); // Темный фон активных табов
  
  @override
  Color get tabBackgroundInactive => Colors.transparent; // Прозрачный фон неактивных табов
  
  @override
  Color get tabContainerBackground => const Color(0xFF383838); // Темно-серый фон контейнера табов
  
  @override
  Color get controlBackground => const Color(0xFF383838); // Темно-серый фон элементов управления
  
  @override
  Color get dividerColor => const Color(0xFF404040); // Темно-серый цвет разделителей
  
  @override
  Color get disabledColor => const Color(0xFF505050); // Темно-серый для отключенных элементов
  
  @override
  Color get iconColor => const Color(0xFFB0B0B0); // Светло-серый цвет иконок
  
  @override
  Color get textPrimary => const Color(0xFFE0E0E0); // Светлый основной текст
  
  @override
  Color get textSecondary => const Color(0xFFB0B0B0); // Серый вторичный текст
} 
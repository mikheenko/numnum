import 'package:flutter/material.dart';
import 'app_color_tokens.dart';

/// Light theme color implementation
class AppColorsLight implements AppColorTokens {
  // Primary colors
  @override
  Color get primary => const Color(0xFF4CAF50);
  
  @override
  Color get primaryDark => const Color(0xFF388E3C);
  
  @override
  Color get primaryLight => const Color(0xFF81C784);
  
  // Secondary colors
  @override
  Color get secondary => const Color(0xFF2196F3);
  
  @override
  Color get secondaryDark => const Color(0xFF1976D2);
  
  @override
  Color get secondaryLight => const Color(0xFF64B5F6);
  
  // Background colors
  @override
  Color get background => const Color(0xFFF5F5F5);
  
  @override
  Color get surface => const Color(0xFFFFFFFF);
  
  @override
  Color get surfaceVariant => const Color(0xFFF8F9FA);
  
  // Text colors
  @override
  Color get onBackground => const Color(0xFF212121);
  
  @override
  Color get onSurface => const Color(0xFF212121);
  
  @override
  Color get onSurfaceVariant => const Color(0xFF757575);
  
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  
  // State colors
  @override
  Color get success => const Color(0xFF4CAF50);
  
  @override
  Color get successLight => const Color(0xFFE8F5E8);
  
  @override
  Color get warning => const Color(0xFFFF9800);
  
  @override
  Color get warningLight => const Color(0xFFFFF3E0);
  
  @override
  Color get error => const Color(0xFFF44336);
  
  @override
  Color get errorLight => const Color(0xFFFFEBEE);
  
  // Border and divider colors
  @override
  Color get border => const Color(0xFFE0E0E0);
  
  @override
  Color get borderLight => const Color(0xFFEEEEEE);
  
  @override
  Color get divider => const Color(0xFFBDBDBD);
  
  // Special colors
  @override
  Color get tertiary => const Color(0xFFF5F5F5);
  
  @override
  Color get player1 => const Color(0xFF4CAF50);
  
  @override
  Color get player2 => const Color(0xFFF44336);
  
  @override
  Color get disabled => const Color(0xFFBDBDBD);
  
  // Table colors
  @override
  Color get tableEmpty => const Color(0xFFEDEDED); // Светло-серый для незаполненных ячеек
  
  // UI Element colors
  @override
  Color get cardBackground => const Color(0xFFFFFFFF); // Белый фон карточек
  
  @override
  Color get screenBackground => const Color(0xFFF5F5F5); // Светло-серый фон экранов
  
  @override
  Color get tabBackground => cardBackground; // Фон активных табов как карточки
  
  @override
  Color get tabBackgroundInactive => Colors.transparent; // Прозрачный фон неактивных табов
  
  @override
  Color get tabContainerBackground => const Color(0xFFEAEAEA); // Светло-серый фон контейнера табов
  
  @override
  Color get controlBackground => const Color(0xFFE8E8E8); // Светло-серый фон элементов управления
  
  @override
  Color get dividerColor => const Color(0xFFE4E4E4); // Светло-серый цвет разделителей
  
  @override
  Color get disabledColor => const Color(0xFFBDBDBD); // Серый цвет отключенных элементов
  
  @override
  Color get iconColor => const Color(0xFF424242); // Темно-серый цвет иконок
  
  @override
  Color get textPrimary => const Color(0xFF212121); // Темный основной текст
  
  @override
  Color get textSecondary => const Color(0xFF757575); // Серый вторичный текст
} 
import 'package:flutter/material.dart';

/// Base class defining color tokens for the app
/// All themes must implement these tokens
abstract class AppColorTokens {
  // Primary colors
  Color get primary;
  Color get primaryDark;
  Color get primaryLight;
  
  // Secondary colors  
  Color get secondary;
  Color get secondaryDark;
  Color get secondaryLight;
  
  // Background colors
  Color get background;
  Color get surface;
  Color get surfaceVariant;
  
  // Text colors
  Color get onBackground;
  Color get onSurface;
  Color get onSurfaceVariant;
  Color get onPrimary;
  Color get onSecondary;
  
  // State colors
  Color get success;
  Color get successLight;
  Color get warning;
  Color get warningLight;
  Color get error;
  Color get errorLight;
  
  // Border and divider colors
  Color get border;
  Color get borderLight;
  Color get divider;
  
  // Special colors
  Color get tertiary;
  Color get player1;
  Color get player2;
  Color get disabled;
  
  // Table colors
  Color get tableEmpty; // Цвет фона незаполненной ячейки таблицы
  
  // UI Element colors
  Color get cardBackground; // Фон карточек (замена Theme.cardColor)
  Color get screenBackground; // Фон экранов (замена Theme.scaffoldBackgroundColor)
  Color get tabBackground; // Фон активных табов
  Color get tabBackgroundInactive; // Фон неактивных табов (замена Colors.transparent)
  Color get tabContainerBackground; // Фон контейнера табов
  Color get controlBackground; // Фон элементов управления (кнопки, переключатели)
  Color get dividerColor; // Цвет разделителей
  Color get disabledColor; // Цвет отключенных элементов
  Color get iconColor; // Цвет иконок
  Color get textPrimary; // Основной цвет текста
  Color get textSecondary; // Вторичный цвет текста
} 
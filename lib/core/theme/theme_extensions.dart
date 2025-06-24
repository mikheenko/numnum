import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../colors/app_color_tokens.dart';
import 'theme_provider.dart';

/// Extension для удобного доступа к цветам темы
extension ThemeExtension on BuildContext {
  /// Получить текущие цвета темы
  AppColorTokens get colors => Provider.of<ThemeProvider>(this, listen: false).colors;
  
  /// Получить провайдер темы (для прослушивания изменений)
  ThemeProvider get themeProvider => Provider.of<ThemeProvider>(this);
  
  /// Получить провайдер темы без прослушивания
  ThemeProvider get themeProviderRead => Provider.of<ThemeProvider>(this, listen: false);
} 
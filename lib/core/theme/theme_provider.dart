import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/app_color_tokens.dart';
import '../colors/app_colors_light.dart';
import '../colors/app_colors_dark.dart';

/// Единый провайдер для управления темой приложения
/// Следует современным практикам Flutter state management
class ThemeProvider extends ChangeNotifier {
  // Приватные поля
  ThemeMode _themeMode = ThemeMode.system;
  AppColorTokens _colors = AppColorsLight();
  bool _isInitialized = false;

  // Публичные геттеры
  ThemeMode get themeMode => _themeMode;
  AppColorTokens get colors => _colors;
  bool get isDark => _colors is AppColorsDark;
  bool get isInitialized => _isInitialized;

  // Статический ключ для SharedPreferences
  static const String _themeKey = 'selected_theme';

  /// Инициализация провайдера
  /// Загружает сохраненные настройки и применяет системную тему
  Future<void> initialize() async {
    try {
      // 1. Загружаем сохраненную тему
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey) ?? 'light';
      
      // 2. Устанавливаем режим темы
      switch (savedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
          _themeMode = ThemeMode.system;
          break;
        default:
          _themeMode = ThemeMode.light; // По умолчанию светлая тема
          break;
      }

      // 3. Применяем цвета (будут обновлены после получения контекста)
      _updateColors();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing ThemeProvider: $e');
      // Fallback to light theme
      _themeMode = ThemeMode.light;
      _colors = AppColorsLight();
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Обновление темы на основе системной яркости
  /// Вызывается когда получен MediaQuery context
  void updateSystemBrightness(Brightness systemBrightness) {
    if (_themeMode == ThemeMode.system) {
      _updateColors(systemBrightness: systemBrightness);
      notifyListeners();
    }
  }

  /// Установка новой темы
  Future<void> setTheme(String theme, {Brightness? systemBrightness}) async {
    try {
      // 1. Обновляем режим темы
      switch (theme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }

      // 2. Обновляем цвета
      _updateColors(systemBrightness: systemBrightness);

      // 3. Сохраняем в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme);

      // 4. Уведомляем все виджеты
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting theme: $e');
    }
  }

  /// Приватный метод для обновления цветов
  void _updateColors({Brightness? systemBrightness}) {
    switch (_themeMode) {
      case ThemeMode.light:
        _colors = AppColorsLight();
        break;
      case ThemeMode.dark:
        _colors = AppColorsDark();
        break;
      case ThemeMode.system:
        // Используем переданную яркость или светлую по умолчанию
        final brightness = systemBrightness ?? Brightness.light;
        _colors = brightness == Brightness.dark 
            ? AppColorsDark() 
            : AppColorsLight();
        break;
    }
  }

  /// Получение строкового представления темы
  String get themeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Получение ThemeData для MaterialApp
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardColor: const Color(0xFFFFFFFF),
    dividerColor: const Color(0xFFBDBDBD),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF212121)),
      bodyMedium: TextStyle(color: Color(0xFF757575)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF212121)),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: const Color(0xFF505050),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
  );

  /// Сброс темы к дефолтным настройкам (светлая тема)
  Future<void> resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeKey); // Удаляем сохраненную тему
      
      _themeMode = ThemeMode.light;
      _colors = AppColorsLight();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting theme: $e');
    }
  }
} 
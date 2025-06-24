import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'app_color_tokens.dart';
import 'app_colors_light.dart';
import 'app_colors_dark.dart';
import '../theme/theme_provider.dart';

/// Global color manager
/// Provides access to current theme colors
class ColorManager extends ChangeNotifier {
  static ColorManager? _instance;
  
  factory ColorManager() {
    _instance ??= ColorManager._internal();
    return _instance!;
  }
  
  ColorManager._internal() {
    // Всегда инициализируем с дефолтными значениями
    _currentColors = AppColorsLight();
    _themeMode = ThemeMode.system;
    _isInitialized = false;
    _loadSavedTheme();
  }

  // Все поля инициализируются сразу, без late
  ThemeMode _themeMode = ThemeMode.system;
  AppColorTokens _currentColors = AppColorsLight();
  bool _isInitialized = false;

  // Get current colors - всегда доступны
  AppColorTokens get colors => _currentColors;

  // Get current theme mode
  ThemeMode get themeMode => _themeMode;

  // Check if current theme is dark
  bool get isDark => _currentColors is AppColorsDark;

  // Get initialization status
  bool get isInitialized => _isInitialized;

  // Force reset for hot restart
  static void reset() {
    _instance = null;
  }

  // Initialize with context (for system brightness)
  void initialize(BuildContext context) {
    if (_isInitialized) return;
    
    final brightness = MediaQuery.of(context).platformBrightness;
    
    // Применяем правильные цвета в зависимости от загруженного режима темы
    switch (_themeMode) {
      case ThemeMode.light:
        _updateColors(Brightness.light);
        break;
      case ThemeMode.dark:
        _updateColors(Brightness.dark);
        break;
      case ThemeMode.system:
        _updateColors(brightness);
        break;
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  // Load saved theme asynchronously
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('selectedTheme') ?? 'system';
      
      // Устанавливаем только режим темы, цвета обновятся после инициализации с контекстом
      switch (savedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          _currentColors = AppColorsLight();
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          _currentColors = AppColorsDark();
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          // Для системной темы оставляем светлую тему по умолчанию
          _currentColors = AppColorsLight();
          break;
      }
    } catch (e) {
      print('Error loading saved theme: $e');
      // Fallback to system theme
      _themeMode = ThemeMode.system;
      _currentColors = AppColorsLight();
    }
  }

  // Set theme mode
  void setThemeMode(ThemeMode mode, {Brightness? systemBrightness}) {
    _themeMode = mode;
    
    Brightness brightness;
    switch (mode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      case ThemeMode.system:
        // Если системная яркость не передана, получаем её из текущего контекста
        brightness = systemBrightness ?? Brightness.light;
        break;
    }
    
    _updateColors(brightness);
    notifyListeners();
  }

  // Update colors based on brightness
  void _updateColors(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        _currentColors = AppColorsLight();
        break;
      case Brightness.dark:
        _currentColors = AppColorsDark();
        break;
    }
  }

  // Convenience method to set theme from string
  void setThemeFromString(String theme, {BuildContext? context}) {
    switch (theme) {
      case 'light':
        setThemeMode(ThemeMode.light);
        break;
      case 'dark':
        setThemeMode(ThemeMode.dark);
        break;
      case 'system':
      default:
        // Для системной темы пытаемся получить яркость из контекста
        Brightness? systemBrightness;
        if (context != null) {
          systemBrightness = MediaQuery.of(context).platformBrightness;
        }
        setThemeMode(ThemeMode.system, systemBrightness: systemBrightness);
        break;
    }
    
    // Принудительно уведомляем всех слушателей об изменении
    notifyListeners();
  }

  // Save theme to preferences
  Future<void> saveTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedTheme', theme);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  // Get theme string for storage
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
}

// Extension for easy access to colors
extension ColorExtension on BuildContext {
  AppColorTokens get colors {
    try {
      // Пытаемся получить цвета из ThemeProvider
      final themeProvider = Provider.of<ThemeProvider>(this, listen: false);
      return themeProvider.colors;
    } catch (e) {
      // Если Provider недоступен, используем ColorManager как fallback
      return ColorManager().colors;
    }
  }
} 
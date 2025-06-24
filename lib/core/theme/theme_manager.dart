import 'package:flutter/material.dart';
import '../colors/color_manager.dart';

class ThemeManager extends ChangeNotifier {
  static ThemeManager? _instance;
  factory ThemeManager() {
    _instance ??= ThemeManager._internal();
    return _instance!;
  }
  ThemeManager._internal();

  final ColorManager _colorManager = ColorManager();

  // Force reset for hot restart
  static void reset() {
    ColorManager.reset();
    _instance = null;
  }

  // Delegate to ColorManager
  ThemeMode get themeMode => _colorManager.themeMode;
  bool get isDark => _colorManager.isDark;
  String get themeString => _colorManager.themeString;
  bool get isInitialized => _colorManager.isInitialized;

  // Initialize
  Future<void> initialize(BuildContext context) async {
    _colorManager.initialize(context);
    _colorManager.addListener(() => notifyListeners());
    notifyListeners();
  }

  // Set theme and save to preferences
  Future<void> setTheme(String theme, {BuildContext? context}) async {
    _colorManager.setThemeFromString(theme, context: context);
    await _colorManager.saveTheme(theme);
    notifyListeners();
  }

  // Update theme based on system brightness changes
  void updateSystemBrightness(Brightness brightness) {
    if (themeMode == ThemeMode.system) {
      _colorManager.setThemeMode(ThemeMode.system, systemBrightness: brightness);
      notifyListeners();
    }
  }

  // Get theme data for MaterialApp
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
} 
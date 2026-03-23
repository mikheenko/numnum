import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global language manager
/// Provides language change notifications to all widgets
class LanguageManager extends ChangeNotifier {
  static LanguageManager? _instance;
  factory LanguageManager() {
    _instance ??= LanguageManager._internal();
    return _instance!;
  }
  LanguageManager._internal();

  String _currentLanguage = 'ru';

  /// Get current language
  String get currentLanguage => _currentLanguage;

  /// Initialize language from storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selectedLanguage');
      if (savedLanguage != null) {
        _currentLanguage = savedLanguage;
      } else {
        // First launch: use system language if supported, otherwise English
        final systemLang = PlatformDispatcher.instance.locale.languageCode;
        if (systemLang == 'ru' || systemLang == 'de') {
          _currentLanguage = systemLang;
        } else {
          _currentLanguage = 'en';
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error loading language: $e');
      _currentLanguage = 'en';
    }
  }

  /// Set language and save to storage
  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      
      // Save to storage
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedLanguage', languageCode);
      } catch (e) {
        print('Error saving language: $e');
      }
      
      // Notify all listening widgets
      notifyListeners();
    }
  }

  /// Available languages
  static const List<Map<String, String>> availableLanguages = [
    {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
  ];

  /// Force reset for hot restart
  static void reset() {
    _instance = null;
  }
} 
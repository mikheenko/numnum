import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

import '../core/localization/app_localizations.dart';
import '../core/theme/theme_provider.dart';
import '../core/theme/theme_extensions.dart';
import '../core/localization/language_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Set<int> _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  String _selectedLanguage = 'ru';
  String _selectedTheme = 'system';

  @override
  void initState() {
    super.initState();
    _loadMultiplierSettings();
    // Инициализируем выбранный язык и тему из провайдеров
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final themeProvider = context.read<ThemeProvider>();
        final languageManager = context.read<LanguageManager>();
        
        if (mounted) {
          setState(() {
            _selectedLanguage = languageManager.currentLanguage;
            _selectedTheme = themeProvider.themeString;
          });
        }
      }
    });
  }

  Future<void> _loadMultiplierSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMultipliers = prefs.getStringList('selected_multipliers');
    if (savedMultipliers != null) {
      setState(() {
        _selectedMultipliers = savedMultipliers.map(int.parse).toSet();
      });
    }
  }

  Future<void> _saveMultiplierSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'selected_multipliers',
      _selectedMultipliers.map((e) => e.toString()).toList(),
    );
  }

  void _toggleMultiplier(int multiplier) {
    setState(() {
      if (_selectedMultipliers.contains(multiplier)) {
        // Не позволяем убрать последний выбранный элемент
        if (_selectedMultipliers.length > 1) {
          _selectedMultipliers.remove(multiplier);
        }
      } else {
        _selectedMultipliers.add(multiplier);
      }
    });
    // Автосохранение
    _saveMultiplierSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageManager>(
      builder: (context, themeProvider, languageManager, child) {
        return Scaffold(
          backgroundColor: context.colors.screenBackground,
          appBar: AppBar(
            backgroundColor: context.colors.screenBackground,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back, 
                color: context.colors.textPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              AppLocalizations.get('settings'),
              style: AppTextStyles.h2.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Секция таблицы умножения
                  _buildMultiplicationSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Секция языка
                  _buildLanguageSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Секция темы
                  _buildThemeSection(),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMultiplicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.get('multiplication_tables'),
          style: AppTextStyles.h3.copyWith(color: context.colors.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate optimal dimensions based on screen width
            const int crossAxisCount = 5;
            const double spacing = AppSpacing.sm;
            final double availableWidth = constraints.maxWidth;
            final double itemWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
            final double itemHeight = itemWidth * 0.75; // Make items slightly rectangular
            final double gridHeight = (itemHeight * 2) + spacing; // 2 rows + spacing
            
            return SizedBox(
              height: gridHeight,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: itemWidth / itemHeight,
                ),
            itemCount: 10,
            itemBuilder: (context, index) {
              final multiplier = index + 1;
              final isSelected = _selectedMultipliers.contains(multiplier);
              
              return GestureDetector(
                onTap: () => _toggleMultiplier(multiplier),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? context.colors.primary : context.colors.tertiary,
                    borderRadius: AppBorderRadius.medium,
                    border: Border.all(
                      color: isSelected ? context.colors.primaryDark : context.colors.border,
                      width: 2,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: Text(
                      multiplier.toString(),
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? context.colors.onPrimary : context.colors.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.get('language'),
          style: AppTextStyles.h3.copyWith(color: context.colors.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppBorderRadius.large,
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < LanguageManager.availableLanguages.length; i++) ...[
                if (i > 0) _buildDivider(),
                _buildLanguageOption(
                  LanguageManager.availableLanguages[i]['code']!,
                  LanguageManager.availableLanguages[i]['name']!,
                  LanguageManager.availableLanguages[i]['flag']!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.get('theme'),
          style: AppTextStyles.h3.copyWith(color: context.colors.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppBorderRadius.large,
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            children: [
              _buildThemeOption('light', AppLocalizations.get('theme_light'), Icons.light_mode),
              _buildDivider(),
              _buildThemeOption('dark', AppLocalizations.get('theme_dark'), Icons.dark_mode),
              _buildDivider(),
              _buildThemeOption('system', AppLocalizations.get('theme_system'), Icons.settings_brightness),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(String value, String title, String flag) {
    final isSelected = _selectedLanguage == value;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedLanguage = value;
        });
        // Используем LanguageManager через Provider для изменения языка
        await context.read<LanguageManager>().setLanguage(value);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: context.colors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String value, String title, IconData icon) {
    final isSelected = _selectedTheme == value;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedTheme = value;
        });
        
        // Используем ThemeProvider через Provider для изменения темы
        final brightness = MediaQuery.of(context).platformBrightness;
        await context.read<ThemeProvider>().setTheme(value, systemBrightness: brightness);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                borderRadius: AppBorderRadius.small,
              ),
              child: Icon(
                icon,
                color: context.colors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: context.colors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: context.colors.border,
      indent: AppSpacing.md,
      endIndent: AppSpacing.md,
    );
  }
} 
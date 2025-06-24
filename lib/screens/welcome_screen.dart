import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/secondary_button.dart';
import '../components/cards/stats_card.dart';
import '../utils/constants.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/theme_extensions.dart';
import 'lesson_screen.dart';
import 'duel_screen.dart';
import 'pythagoras_table_screen.dart';
import 'settings_screen.dart';
import '../core/theme/theme_provider.dart';
import '../core/localization/language_manager.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Set<int> _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

  // Статистика
  int _solvedToday = 0;
  int _totalSolved = 0;
  int _streak = 0;
  double _accuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadMultiplierSettings();
  }

  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      setState(() {
        _solvedToday = prefs.getInt('solved_$today') ?? 0;

        _totalSolved = prefs.getInt('total_solved') ?? 0;
        _streak = prefs.getInt('streak') ?? 0;
        _accuracy = prefs.getDouble('accuracy') ?? 0.0;
      });
    } catch (e) {
      print('Error loading stats: $e');
      setState(() {
        _solvedToday = 0;

        _totalSolved = 0;
        _streak = 0;
        _accuracy = 0.0;
      });
    }
  }

  Future<void> _loadMultiplierSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final multipliers = prefs.getStringList('selected_multipliers') ?? [];
      if (multipliers.isNotEmpty) {
        setState(() {
          _selectedMultipliers = multipliers.map((e) => int.parse(e)).toSet();
        });
      }
      if (_selectedMultipliers.isEmpty) {
        setState(() {
          _selectedMultipliers = {1};
        });
      }
    } catch (e) {
      print('Error loading multiplier settings: $e');
      setState(() {
        _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
      });
    }
  }



  void _startLesson() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LessonScreen(),
      ),
    );
  }

  void _startDuel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DuelScreen(),
      ),
    );
  }

  void _openTable() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PythagorasTableScreen(),
      ),
    );
  }

  void _showMultiplierSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    ).then((_) {
      // Перезагружаем настройки когда возвращаемся
      _loadMultiplierSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageManager>(
      builder: (context, themeProvider, languageManager, child) {
        return Scaffold(
          backgroundColor: context.colors.screenBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - AppSpacing.md * 2 - kToolbarHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      
                      // Заголовок приложения
                      Text(
                        AppLocalizations.get('app_title'),
                        style: AppTextStyles.h2.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLocalizations.get('app_subtitle'),
                        style: AppTextStyles.body2.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      
                      // Статистические карточки
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              title: AppLocalizations.get('solved_today'),
                              value: _solvedToday.toString(),
                              icon: Icons.check_circle,
                              iconColor: context.colors.success,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: StatsCard(
                              title: AppLocalizations.get('accuracy'),
                              value: '${_accuracy.toStringAsFixed(0)}%',
                              icon: Icons.track_changes,
                              iconColor: context.colors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              title: AppLocalizations.get('win_streak'),
                              value: _streak.toString(),
                              icon: Icons.local_fire_department,
                              iconColor: context.colors.warning,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: StatsCard(
                              title: AppLocalizations.get('total_solved'),
                              value: _totalSolved.toString(),
                              icon: Icons.emoji_events,
                              iconColor: context.colors.secondary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        text: AppLocalizations.get('start_training'),
                        onPressed: _startLesson,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      PrimaryButton(
                        text: AppLocalizations.get('duel'),
                        onPressed: _startDuel,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SecondaryButton(
                        text: AppLocalizations.get('pythagoras_table'),
                        onPressed: _openTable,
                        height: AppButtonDimensions.heightLarge,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SecondaryButton(
                        text: AppLocalizations.get('settings'),
                        onPressed: _showMultiplierSettings,
                        height: AppButtonDimensions.heightLarge
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 
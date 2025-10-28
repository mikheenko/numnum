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

  // Parent-facing metrics
  int _daysStreak = 0; // Consecutive training days
  int _trainingsToday = 0; // Trainings done today
  int _trainingsTotal = 0; // Total trainings

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
        _daysStreak = prefs.getInt('days_streak') ?? 0;
        _trainingsToday = prefs.getInt('trainings_$today') ?? 0;
        _trainingsTotal = prefs.getInt('trainings_total') ?? 0;
      });
    } catch (e) {
      print('Error loading stats: $e');
      setState(() {
        _daysStreak = 0;
        _trainingsToday = 0;
        _trainingsTotal = 0;
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
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
                          
                          // Parent-facing stats: two on top, one full width below
                          Row(
                            children: [
                              Expanded(
                                child: StatsCard(
                                  title: AppLocalizations.get('parent_days_streak'),
                                  value: _daysStreak.toString(),
                                  icon: Icons.local_fire_department,
                                  iconColor: context.colors.warning,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: StatsCard(
                                  title: AppLocalizations.get('parent_trainings_today'),
                                  value: _trainingsToday.toString(),
                                  icon: Icons.today,
                                  iconColor: context.colors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SizedBox(
                            width: double.infinity,
                            child: StatsCard(
                              title: AppLocalizations.get('parent_trainings_total'),
                              value: _trainingsTotal.toString(),
                              icon: Icons.emoji_events,
                              iconColor: context.colors.secondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                  
                  // Кнопки внизу экрана
                  PrimaryButton(
                    text: AppLocalizations.get('start_training'),
                    onPressed: _startLesson,
                    width: double.infinity,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    text: AppLocalizations.get('duel'),
                    onPressed: _startDuel,
                    height: AppButtonDimensions.heightLarge,
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
                    height: AppButtonDimensions.heightLarge,
                    width: double.infinity,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 
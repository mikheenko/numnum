import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


import '../utils/constants.dart';
import '../core/theme/theme_provider.dart';
import '../models/question_result.dart';
import '../models/hint_system.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/secondary_button.dart';
import '../components/keyboard/custom_keyboard.dart';
import '../components/common/responsive_wrapper.dart';
import '../components/common/adaptive_button_row.dart';
import '../components/hint/hint_popup.dart';

import 'package:provider/provider.dart';
import '../core/theme/theme_extensions.dart';
import '../core/localization/language_manager.dart';
import '../core/localization/app_localizations.dart';
import 'result_screen.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with TickerProviderStateMixin {
  List<List<int>> _questions = [[1, 1]];
  int _current = 0;
  int _correct = 0;
  String _input = '';
  bool _showError = false;
  bool _answered = false;

  // Settings
  Set<int> _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

  // Rive
  late RiveAnimationController _idleController;
  late RiveAnimationController _blinkController;
  SMITrigger? _successTrigger;
  SMITrigger? _thinkTrigger;
  SMITrigger? _waveTrigger;
  Timer? _waveTimer;
  Timer? _autoNextTimer;
  Timer? _errorTimer;
  String? _lastWrongAnswer;

  // Store results for each question
  final List<QuestionResult> _results = [];
  final List<String> _currentAttempts = [];

  // Hint system
  bool _hintUsedForCurrentQuestion = false;
  int _totalHintsUsed = 0;

  // Carousel animation
  late AnimationController _carouselController;
  late Animation<Offset> _oldOffsetAnim;
  late Animation<Offset> _newOffsetAnim;
  List<int>? _prevQuestion;
  bool _isAnimating = false;
  
  // Shake animation
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _loadMultiplierSettings();
    _idleController = SimpleAnimation('Idle');
    _blinkController = SimpleAnimation('Blink');
    
    _carouselController = AnimationController(
      vsync: this, 
      duration: AppConstants.animationDuration,
    );
    _oldOffsetAnim = Tween<Offset>(
      begin: Offset.zero, 
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _carouselController, 
      curve: Curves.easeInOut,
    ));
    _newOffsetAnim = Tween<Offset>(
      begin: const Offset(1, 0), 
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _carouselController, 
      curve: Curves.easeInOut,
    ));
    
    _shakeController = AnimationController(
      vsync: this, 
      duration: AppConstants.shakeAnimationDuration,
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero, 
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController, 
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _waveTimer?.cancel();
    _autoNextTimer?.cancel();
    _errorTimer?.cancel();
    _carouselController.dispose();
    _shakeController.dispose();
    super.dispose();
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
      setState(() {
        _questions = _generateQuestions(AppConstants.totalQuestions);
      });
    } catch (e) {
      print('Error loading multiplier settings: $e');
      setState(() {
        _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        _questions = _generateQuestions(AppConstants.totalQuestions);
      });
    }
  }



  void _onRiveInit(Artboard artboard) {
    try {
      final controller = StateMachineController.fromArtboard(artboard, 'Default');
      if (controller != null) {
        artboard.addController(controller);
        _successTrigger = controller.findInput<bool>('Success') as SMITrigger?;
        _thinkTrigger = controller.findInput<bool>('Think') as SMITrigger?;
        _waveTrigger = controller.findInput<bool>('Wave') as SMITrigger?;
        _startWaveTimer();
      }
    } catch (e) {
      print('Error initializing Rive: $e');
    }
  }

  void _startWaveTimer() {
    _waveTimer?.cancel();
    _waveTimer = Timer.periodic(AppConstants.waveInterval, (_) {
      if (!_answered) _waveTrigger?.fire();
    });
  }

  // Helper method to play negative haptic feedback (3 short vibrations)
  void _playNegativeHapticFeedback() async {
    // First vibration - immediate, stronger for error indication
    HapticFeedback.mediumImpact();
    
    // Second vibration - after short delay
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) HapticFeedback.lightImpact();
    
    // Third vibration - after another short delay
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) HapticFeedback.lightImpact();
  }

  List<List<int>> _generateQuestions(int count) {
    final allCombinations = <List<int>>[];
    for (int i in _selectedMultipliers) {
      for (int j = 1; j <= 10; j++) {
        allCombinations.add([i, j]);
      }
    }
    
    if (allCombinations.isEmpty) {
      return List.generate(count, (index) => [1, (index % 10) + 1]);
    }
    
    allCombinations.shuffle();
    return allCombinations.take(count).toList();
  }

  void _onKeyboardTap(String value) {
    if (_answered) return;
    
    setState(() {
      if (value == '<') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        if (_input.length < AppConstants.maxInputLength) {
          _input += value;
        }
      }
      // Reset error state when user starts typing a new answer
      if (value != '<' && _showError) {
        _showError = false;
        _lastWrongAnswer = null;
      }
    });
    
    if (_input.isNotEmpty && !_answered) {
      final answer = _questions[_current][0] * _questions[_current][1];
      final correctAnswerLength = answer.toString().length;
      
      if (_input.length >= correctAnswerLength) {
        if (_input == answer.toString()) {
          _checkAnswer();
        } else if (correctAnswerLength == 1 || _input.length >= correctAnswerLength) {
          _showWrongAnswerFeedback();
        }
      }
    }
  }

  void _checkAnswer() {
    final answer = _questions[_current][0] * _questions[_current][1];
    _currentAttempts.add(_input);
    
    if (_input == answer.toString()) {
      // Positive haptic feedback for correct answer
      HapticFeedback.lightImpact();
      
      setState(() {
        _correct++;
        _answered = true;
        _showError = false;
        _lastWrongAnswer = null;
      });
      _successTrigger?.fire();
      _waveTimer?.cancel();
      _autoNextTimer?.cancel();
      _autoNextTimer = Timer(AppConstants.successDisplayDuration, () {
        if (mounted && _answered) {
          _startCarouselAnimation();
        }
      });
    } else {
      _showWrongAnswerFeedback();
    }
  }

  void _showWrongAnswerFeedback() {
    // Negative haptic feedback: three short vibrations for wrong answer
    _playNegativeHapticFeedback();
    
    setState(() {
      _lastWrongAnswer = _input;
      _showError = true;
    });
    _currentAttempts.add(_lastWrongAnswer!);
    _thinkTrigger?.fire();
    
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    _errorTimer?.cancel();
    _errorTimer = Timer(AppConstants.errorDisplayDuration, () {
      if (mounted) {
        setState(() {
          _input = '';
        });
      }
    });
  }

  void _startCarouselAnimation() async {
    setState(() {
      _isAnimating = true;
      _prevQuestion = _questions[_current];
    });
    
    final oldQ = _questions[_current];
    final oldAnswer = oldQ[0] * oldQ[1];
    _results.add(QuestionResult(
      a: oldQ[0],
      b: oldQ[1],
      correctAnswer: oldAnswer,
      userAnswers: List<String>.from(_currentAttempts),
      correctFromFirstTry: _currentAttempts.isNotEmpty && 
          _currentAttempts.first == oldAnswer.toString(),
      hintUsed: _hintUsedForCurrentQuestion,
    ));
    _currentAttempts.clear();
    
    // Reset hint usage for next question
    _hintUsedForCurrentQuestion = false;
    
    if (_current < AppConstants.totalQuestions - 1) {
      setState(() {
        _current++;
        _input = '';
        _answered = false;
        _showError = false;
        _hintUsedForCurrentQuestion = false;
      });
      _startWaveTimer();
    } else {
      _saveStats();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correct: _correct,
            total: AppConstants.totalQuestions,
            results: _results,
          ),
        ),
      );
      return;
    }
    
    await _carouselController.forward(from: 0);
    _carouselController.reset();
    
    setState(() {
      _isAnimating = false;
      _prevQuestion = null;
    });
  }

  Future<void> _saveStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final solved = prefs.getInt('solved_$today') ?? 0;
      final mistakes = prefs.getInt('mistakes_$today') ?? 0;
      final newSolved = solved + AppConstants.totalQuestions;
      final newMistakes = mistakes + _results.where((r) => !r.correctFromFirstTry).length;
      await prefs.setInt('solved_$today', newSolved);
      await prefs.setInt('mistakes_$today', newMistakes);
      
      // Save hints usage statistics
      final totalHints = prefs.getInt('total_hints_used') ?? 0;
      await prefs.setInt('total_hints_used', totalHints + _totalHintsUsed);
    } catch (e) {
      print('Error saving stats: $e');
    }
  }

  void _showHint() {
    final currentQuestion = _questions[_current];
    final hint = HintSystem.getHint(currentQuestion[0], currentQuestion[1]);
    
    if (hint != null) {
      if (!_hintUsedForCurrentQuestion) {
        setState(() {
          _hintUsedForCurrentQuestion = true;
          _totalHintsUsed++;
        });
      }
      
      final languageManager = context.read<LanguageManager>();
      
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => HintPopup(
          hint: hint,
          currentLanguage: languageManager.currentLanguage,
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  void _exitLesson() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.all(16),
          child: Dialog(
            backgroundColor: context.colors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.extraLarge,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.get('exit_lesson_title', context),
                    style: AppTextStyles.h3.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppLocalizations.get('exit_lesson_message', context),
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AdaptiveButtonRow(
                    children: [
                      SecondaryButton(
                        text: AppLocalizations.get('cancel', context),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      PrimaryButton(
                        text: AppLocalizations.get('exit', context),
                        height: AppButtonDimensions.heightMedium,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageManager>(
      builder: (context, themeProvider, languageManager, child) {
        return Scaffold(
          backgroundColor: context.colors.screenBackground,
          body: SafeArea(
            child: Column(
              children: [
                // Основной контент с отступами (верхняя панель, уравнения, персонаж)
                Expanded(
                  child: ResponsiveWrapper(
                    child: Column(
                      children: [
                        // Верхняя панель с прогрессом
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0, 0, 0, 0,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: context.colors.textPrimary,
                                ),
                                onPressed: _exitLesson,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 0, 
                                    right: 0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: AppBorderRadius.small,
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0, 
                                        end: _current / AppConstants.totalQuestions,
                                      ),
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeIn,
                                      builder: (context, value, child) => LinearProgressIndicator(
                                        value: value,
                                        minHeight: 8,
                                        backgroundColor: context.colors.tabContainerBackground,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          context.colors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Основной контент
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (_isAnimating && _prevQuestion != null)
                                          SlideTransition(
                                            position: _oldOffsetAnim,
                                            child: _buildEquationRow(
                                              _prevQuestion!, 
                                              true, 
                                              '', 
                                              _prevQuestion![0] * _prevQuestion![1], 
                                              true, 
                                              false,
                                            ),
                                          ),
                                        SlideTransition(
                                          position: _isAnimating && _prevQuestion != null 
                                              ? _newOffsetAnim 
                                              : const AlwaysStoppedAnimation(Offset.zero),
                                          child: AnimatedBuilder(
                                            animation: _shakeAnimation,
                                            builder: (context, child) {
                                              return Transform.translate(
                                                offset: _showError ? _shakeAnimation.value * 20 : Offset.zero,
                                                child: _buildEquationRow(
                                                  _questions[_current], 
                                                  _answered, 
                                                  _input, 
                                                  _questions[_current][0] * _questions[_current][1], 
                                                  false, 
                                                  _showError,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      width: 160,
                                      height: double.infinity,
                                      child: RiveAnimation.asset(
                                        'assets/gemmy.riv',
                                        artboard: 'Character',
                                        controllers: [_idleController, _blinkController],
                                        onInit: _onRiveInit,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Область для отображения ошибок/правильных ответов
                        SizedBox(
                          height: AppButtonDimensions.heightLarge + AppSpacing.lg,
                          child: Center(
                            child: _showError
                                ? Container(
                                    width: double.infinity,
                                    height: AppButtonDimensions.heightLarge,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${_lastWrongAnswer ?? ''} ${AppLocalizations.get('incorrect', context)}',
                                      style: AppTextStyles.body1.copyWith(
                                        color: context.colors.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : _answered
                                    ? Container(
                                        width: double.infinity,
                                        height: AppButtonDimensions.heightLarge,
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.get('correct', context),
                                          style: AppTextStyles.h3.copyWith(
                                            color: context.colors.success,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        width: double.infinity,
                                        height: AppButtonDimensions.heightLarge,
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Клавиатура без отступов (вплотную к краям)
                SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                                              AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: CustomKeyboard(
                            key: const ValueKey('keyboard'),
                            onTap: _onKeyboardTap,
                            enabled: true,
                            onHintTap: _showHint,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEquationRow(
    List<int> q, 
    bool answered, 
    String input, 
    int answer, 
    bool isPrev, 
    bool showError,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          q[0].toString(), 
          style: AppTextStyles.equation.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '×', 
          style: AppTextStyles.equationOperator.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          q[1].toString(), 
          style: AppTextStyles.equation.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '=', 
          style: AppTextStyles.equationOperator.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          width: 80,
          height: 48,
          decoration: BoxDecoration(
                        color: answered 
                ? context.colors.successLight
                : showError 
                    ? context.colors.errorLight
                    : context.colors.warningLight,
            border: Border.all(
              color: answered 
                  ? context.colors.success
                  : showError 
                      ? context.colors.error
                      : context.colors.warning,
              width: 2,
            ),
            borderRadius: AppBorderRadius.medium,
          ),
          alignment: Alignment.center,
          child: Text(
            answered && !isPrev 
                ? answer.toString() 
                : (input.isEmpty ? ' ' : input),
            style: AppTextStyles.h2.copyWith(
              color: answered && !isPrev 
                  ? context.colors.primaryDark
                  : showError 
                      ? context.colors.error 
                      : context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
} 
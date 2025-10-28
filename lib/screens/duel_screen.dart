import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../core/theme/theme_provider.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/secondary_button.dart';
import '../components/keyboard/custom_keyboard.dart';
import '../components/common/adaptive_button_row.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_extensions.dart';
import '../core/localization/language_manager.dart';
import '../core/localization/app_localizations.dart';

class DuelScreen extends StatefulWidget {
  const DuelScreen({super.key});

  @override
  State<DuelScreen> createState() => _DuelScreenState();
}

class _DuelScreenState extends State<DuelScreen> with TickerProviderStateMixin {
  // Game state
  late List<List<int>> _questions = [];
  int _player1Current = 0;
  int _player2Current = 0;
  int _player1Correct = 0;
  int _player2Correct = 0;
  String _player1Input = '';
  String _player2Input = '';

  // Game states
  bool _showStartDialog = true;
  bool _gameStarted = false;
  bool _gameEnded = false;
  bool _isPaused = false;
  int? _winner;
  final int _countdownTimer = 0;
  Timer? _countdownTimerInstance;

  // Rive animations
  late RiveAnimationController _player1IdleController;
  late RiveAnimationController _player1BlinkController;
  late RiveAnimationController _player2IdleController;
  late RiveAnimationController _player2BlinkController;
  SMITrigger? _player1SuccessTrigger;
  SMITrigger? _player1ThinkTrigger;
  SMITrigger? _player2SuccessTrigger;
  SMITrigger? _player2ThinkTrigger;
  SMIInput<double>? _player1ColorInput;
  SMIInput<double>? _player2ColorInput;

  // Carousel animations
  late AnimationController _player1CarouselController;
  late AnimationController _player2CarouselController;
  late Animation<Offset> _player1OldOffset;
  late Animation<Offset> _player1NewOffset;
  late Animation<Offset> _player2OldOffset;
  late Animation<Offset> _player2NewOffset;

  // Shake animations
  late AnimationController _player1ShakeController;
  late AnimationController _player2ShakeController;
  late Animation<Offset> _player1ShakeAnimation;
  late Animation<Offset> _player2ShakeAnimation;

  // Previous questions for animation
  List<int>? _player1PrevQuestion;
  List<int>? _player2PrevQuestion;
  bool _player1Animating = false;
  bool _player2Animating = false;

  // Error timers
  Timer? _player1ErrorTimer;
  Timer? _player2ErrorTimer;
  bool _player1ShowError = false;
  bool _player2ShowError = false;

  // Track if players answered correctly for current question
  bool _player1AnsweredCorrectly = false;
  bool _player2AnsweredCorrectly = false;


  // Settings
  Set<int> _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

  @override
  void initState() {
    super.initState();

    // Load multiplier settings
    _loadMultiplierSettings();

    // Initialize Rive controllers
    _player1IdleController = SimpleAnimation('Idle');
    _player1BlinkController = SimpleAnimation('Blink');
    _player2IdleController = SimpleAnimation('Idle');
    _player2BlinkController = SimpleAnimation('Blink');

    // Initialize carousel controllers
    _player1CarouselController = AnimationController(
      vsync: this,
      duration: AppConstants.animationDuration,
    );
    _player2CarouselController = AnimationController(
      vsync: this,
      duration: AppConstants.animationDuration,
    );

    _player1OldOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _player1CarouselController,
      curve: Curves.easeInOut,
    ));

    _player1NewOffset = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _player1CarouselController,
      curve: Curves.easeInOut,
    ));

    _player2OldOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _player2CarouselController,
      curve: Curves.easeInOut,
    ));

    _player2NewOffset = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _player2CarouselController,
      curve: Curves.easeInOut,
    ));

    // Initialize shake controllers
    _player1ShakeController = AnimationController(
      vsync: this,
      duration: AppConstants.shakeAnimationDuration,
    );
    _player2ShakeController = AnimationController(
      vsync: this,
      duration: AppConstants.shakeAnimationDuration,
    );

    _player1ShakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _player1ShakeController,
      curve: Curves.elasticIn,
    ));

    _player2ShakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _player2ShakeController,
      curve: Curves.elasticIn,
    ));

    // Auto-show start dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartDialogIfNeeded();
    });
  }

  @override
  void dispose() {
    _player1CarouselController.dispose();
    _player2CarouselController.dispose();
    _player1ShakeController.dispose();
    _player2ShakeController.dispose();
    _player1ErrorTimer?.cancel();
    _player2ErrorTimer?.cancel();
    _countdownTimerInstance?.cancel();
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
    } catch (e) {
      print('Error loading multiplier settings: $e');
      setState(() {
        _selectedMultipliers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
      });
    }
    
    // Generate questions after loading settings
    setState(() {
      _questions = _generateQuestions(AppConstants.totalQuestions);
    });
  }

  List<List<int>> _generateQuestions(int count) {
    // Build all possible combinations for selected multipliers (a × b, b in 1..10)
    final allCombinations = <List<int>>[];
    for (int a in _selectedMultipliers) {
      for (int b = 1; b <= 10; b++) {
        allCombinations.add([a, b]);
      }
    }
    
    if (allCombinations.isEmpty) {
      // Fallback to ensure at least some questions exist
      return List.generate(count, (index) => [1, (index % 10) + 1]);
    }
    
    // Shuffle to randomize order, then take the first N unique entries
    allCombinations.shuffle();
    final take = count.clamp(0, allCombinations.length);
    return allCombinations.take(take).toList();
  }

  Future<void> _showStartDialogIfNeeded() async {
    if (_showStartDialog) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _DuelStartDialog(
          onStart: () {},
          onExit: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          countdownTimer: _countdownTimer,
          onCountdownFinished: () {
            // Пустой callback - состояние обновляется после закрытия диалога
          },
        ),
      );
      setState(() {
        _showStartDialog = false;
        _gameStarted = true;
      });
    }
  }

  void _showPauseDialog() {
    setState(() {
      _isPaused = true;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DuelPauseDialog(
        onResume: () {
          Navigator.of(context).pop();
          setState(() {
            _isPaused = false;
          });
        },
        onExit: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }



  void _onRiveInit(Artboard artboard, int player) {
    try {
      final controller =
          StateMachineController.fromArtboard(artboard, 'Default');
      if (controller != null) {
        artboard.addController(controller);

        if (player == 1) {
          _player1SuccessTrigger =
              controller.findInput<bool>('Success') as SMITrigger?;
          _player1ThinkTrigger =
              controller.findInput<bool>('Think') as SMITrigger?;
          _player1ColorInput =
              controller.findInput<double>('Color');
          _player1ColorInput?.value = 0; // Green for player 1
        } else {
          _player2SuccessTrigger =
              controller.findInput<bool>('Success') as SMITrigger?;
          _player2ThinkTrigger =
              controller.findInput<bool>('Think') as SMITrigger?;
          _player2ColorInput =
              controller.findInput<double>('Color');
          _player2ColorInput?.value = 1; // Red for player 2
        }
      }
    } catch (e) {
      print('Error initializing Rive for player $player: $e');
    }
  }

  void _onKeyboardTap(String value, int player) {
    if (_gameEnded || !_gameStarted || _isPaused) return;

    if (player == 1) {
      if (_player1Current >= AppConstants.totalQuestions || _player1AnsweredCorrectly) return;

      setState(() {
        if (value == '<') {
          if (_player1Input.isNotEmpty) {
            _player1Input =
                _player1Input.substring(0, _player1Input.length - 1);
          }
        } else {
          if (_player1Input.length < AppConstants.maxInputLength) {
            _player1Input += value;
          }
        }
        _player1ShowError = false;
      });

      if (_player1Input.isNotEmpty) {
        final answer =
            _questions[_player1Current][0] * _questions[_player1Current][1];
        final correctAnswerLength = answer.toString().length;

        if (_player1Input.length >= correctAnswerLength) {
          if (_player1Input == answer.toString()) {
            _handleCorrectAnswer(1);
          } else {
            _showWrongAnswerFeedback(1);
          }
        }
      }
    } else {
      if (_player2Current >= AppConstants.totalQuestions || _player2AnsweredCorrectly) return;

      setState(() {
        if (value == '<') {
          if (_player2Input.isNotEmpty) {
            _player2Input =
                _player2Input.substring(0, _player2Input.length - 1);
          }
        } else {
          if (_player2Input.length < AppConstants.maxInputLength) {
            _player2Input += value;
          }
        }
        _player2ShowError = false;
      });

      if (_player2Input.isNotEmpty) {
        final answer =
            _questions[_player2Current][0] * _questions[_player2Current][1];
        final correctAnswerLength = answer.toString().length;

        if (_player2Input.length >= correctAnswerLength) {
          if (_player2Input == answer.toString()) {
            _handleCorrectAnswer(2);
          } else {
            _showWrongAnswerFeedback(2);
          }
        }
      }
    }
  }

  void _handleCorrectAnswer(int player) {
    if (player == 1) {
      setState(() {
        _player1Correct++;
        _player1ShowError = false;
        _player1AnsweredCorrectly = true;
      });
      _player1SuccessTrigger?.fire();

      Timer(const Duration(seconds: 1), () {
        if (mounted) _startCarouselAnimation(1);
      });
    } else {
      setState(() {
        _player2Correct++;
        _player2ShowError = false;
        _player2AnsweredCorrectly = true;
      });
      _player2SuccessTrigger?.fire();

      Timer(const Duration(seconds: 1), () {
        if (mounted) _startCarouselAnimation(2);
      });
    }
  }

  void _showWrongAnswerFeedback(int player) {
    if (player == 1) {
      setState(() {
  
        _player1ShowError = true;
      });
      _player1ThinkTrigger?.fire();

      _player1ShakeController.forward().then((_) {
        _player1ShakeController.reverse();
      });

      _player1ErrorTimer?.cancel();
      _player1ErrorTimer = Timer(AppConstants.errorDisplayDuration, () {
        if (mounted) {
          setState(() {
            _player1Input = '';
            _player1ShowError = false;
          });
        }
      });
    } else {
      setState(() {

        _player2ShowError = true;
      });
      _player2ThinkTrigger?.fire();

      _player2ShakeController.forward().then((_) {
        _player2ShakeController.reverse();
      });

      _player2ErrorTimer?.cancel();
      _player2ErrorTimer = Timer(AppConstants.errorDisplayDuration, () {
        if (mounted) {
          setState(() {
            _player2Input = '';
            _player2ShowError = false;
          });
        }
      });
    }
  }

  void _startCarouselAnimation(int player) async {
    if (player == 1) {
      setState(() {
        _player1Animating = true;
        _player1PrevQuestion = _questions[_player1Current];
      });

      if (_player1Current < AppConstants.totalQuestions - 1) {
        setState(() {
          _player1Current++;
          _player1Input = '';
          _player1AnsweredCorrectly = false;
        });
      }

      await _player1CarouselController.forward(from: 0);
      _player1CarouselController.reset();

      setState(() {
        _player1Animating = false;
        _player1PrevQuestion = null;
      });
    } else {
      setState(() {
        _player2Animating = true;
        _player2PrevQuestion = _questions[_player2Current];
      });

      if (_player2Current < AppConstants.totalQuestions - 1) {
        setState(() {
          _player2Current++;
          _player2Input = '';
          _player2AnsweredCorrectly = false;
        });
      }

      await _player2CarouselController.forward(from: 0);
      _player2CarouselController.reset();

      setState(() {
        _player2Animating = false;
        _player2PrevQuestion = null;
      });
    }

    _checkGameEnd();
  }

  void _checkGameEnd() {
    // Game ends when either player reaches 10 correct answers OR all questions are answered
    if ((_player1Correct >= AppConstants.totalQuestions ||
            _player2Correct >= AppConstants.totalQuestions ||
            (_player1Current >= AppConstants.totalQuestions &&
                _player2Current >= AppConstants.totalQuestions)) &&
        !_gameEnded) {
      // Prevent race condition by setting game ended immediately
      _gameEnded = true;
      
      setState(() {
        if (_player1Correct > _player2Correct) {
          _winner = 1;
        } else if (_player2Correct > _player1Correct) {
          _winner = 2;
        } else {
          _winner = null; // Draw
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _showGameEndDialog();
        }
      });
    }
  }

  void _showGameEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.all(16),
          child: Dialog(
            backgroundColor: context.colors.surface,
            shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _winner == null 
                        ? AppLocalizations.get('tie', context)
                        : '${AppLocalizations.get('player_wins', context)} $_winner!',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${AppLocalizations.get('player_1', context)}: $_player1Correct/${AppConstants.totalQuestions}\n'
                    '${AppLocalizations.get('player_2', context)}: $_player2Correct/${AppConstants.totalQuestions}',
                    style: AppTextStyles.body2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AdaptiveButtonRow(
                    children: [
                      SecondaryButton(
                        text: AppLocalizations.get('exit', context),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                      PrimaryButton(
                        text: AppLocalizations.get('play_again', context),
                        height: AppButtonDimensions.heightMedium,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _restartGame();
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

  void _restartGame() {
    setState(() {
      _player1Current = 0;
      _player2Current = 0;
      _player1Correct = 0;
      _player2Correct = 0;
      _player1Input = '';
      _player2Input = '';
      _player1AnsweredCorrectly = false;
      _player2AnsweredCorrectly = false;
      _gameEnded = false;
      _gameStarted = false;
      _winner = null;
      _questions = _generateQuestions(AppConstants.totalQuestions);
      _showStartDialog = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartDialogIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: context.colors.screenBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer2<ThemeProvider, LanguageManager>(
      builder: (context, themeProvider, languageManager, child) {
        return Scaffold(
          backgroundColor: context.colors.screenBackground,
          body: SafeArea(
            child: Column(
              children: [
                // Player 2 area (rotated)
                _buildPlayerArea(2),
                // Center area with characters, controls and progress bars
                _buildCenterArea(),
                // Player 1 area
                _buildPlayerArea(1),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerArea(int player) {
    final current = player == 1 ? _player1Current : _player2Current;
    final input = player == 1 ? _player1Input : _player2Input;
    final showError = player == 1 ? _player1ShowError : _player2ShowError;
    final animating = player == 1 ? _player1Animating : _player2Animating;
    final prevQuestion =
        player == 1 ? _player1PrevQuestion : _player2PrevQuestion;
    final oldOffset = player == 1 ? _player1OldOffset : _player2OldOffset;
    final newOffset = player == 1 ? _player1NewOffset : _player2NewOffset;
    final shakeAnimation =
        player == 1 ? _player1ShakeAnimation : _player2ShakeAnimation;

    if (current >= AppConstants.totalQuestions) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
          ),
          child: Center(
            child: Text(
              AppLocalizations.get('done', context),
              style: AppTextStyles.h2.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }

    final q = _questions[current];
    final answer = q[0] * q[1];
    final isCorrect = input.isNotEmpty && input == answer.toString();

    Widget playerContent = Column(
      children: [
        // Question area - flexible height
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Center(
              child: Stack(
                children: [
                  if (animating && prevQuestion != null)
                    SlideTransition(
                      position: oldOffset,
                      child: _buildEquationRow(
                        prevQuestion,
                        true,
                        '',
                        prevQuestion[0] * prevQuestion[1],
                        true,
                        false,
                        false,
                        player,
                      ),
                    ),
                  SlideTransition(
                    position: animating && prevQuestion != null
                        ? newOffset
                        : const AlwaysStoppedAnimation(Offset.zero),
                    child: AnimatedBuilder(
                      animation: shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset:
                              showError ? shakeAnimation.value * 20 : Offset.zero,
                          child: _buildEquationRow(
                            q,
                            false,
                            input,
                            answer,
                            false,
                            showError,
                            isCorrect,
                            player,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Keyboard area with safe area padding
        SafeArea(
          top: false,
          child: SizedBox(
            height: 220,
            child: CustomKeyboard(
              onTap: (value) => _onKeyboardTap(value, player),
              enabled: current < AppConstants.totalQuestions && !_gameEnded && _gameStarted,
            ),
          ),
        ),
      ],
    );

    if (player == 2) {
      playerContent = Transform.rotate(
        angle: 3.14159, // 180 degrees for player 2
        child: playerContent,
      );
    }

    return Expanded(child: playerContent);
  }

  Widget _buildEquationRow(
    List<int> q,
    bool answered,
    String input,
    int answer,
    bool isPrev,
    bool showError,
    bool isCorrect,
    int player,
  ) {
    // Use consistent sizes with lesson screen
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
            color: answered || isCorrect
                ? context.colors.successLight
                : showError
                    ? context.colors.errorLight
                    : context.colors.warningLight,
            border: Border.all(
              color: answered || isCorrect
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
                  : (answered || isCorrect)
                      ? context.colors.primaryDark
                      : showError
                          ? context.colors.error
                          : context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCenterArea() {
    return Container(
      color: context.colors.screenBackground,
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar for Player 2
            _buildProgressBar(2),
            const SizedBox(height: 8),
            // Center content with players info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Row(
                children: [
                  // Player 1 area
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: AppSpacing.lg),
                        // Player 1 character and info
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.get('player_1', context),
                                style: AppTextStyles.body2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              Text(
                                '$_player1Correct / ${AppConstants.totalQuestions}',
                                style: AppTextStyles.body2.copyWith(
                                  fontSize: 12,
                                  color: context.colors.player1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: RiveAnimation.asset(
                            'assets/gemmy.riv',
                            artboard: 'Character',
                            controllers: [
                              _player1IdleController,
                              _player1BlinkController
                            ],
                            onInit: (artboard) => _onRiveInit(artboard, 1),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pause button in center
                  IconButton(
                    onPressed: _gameStarted && !_gameEnded ? _showPauseDialog : null,
                    icon: Icon(
                      Icons.pause, 
                      size: 18,
                      color: _gameStarted && !_gameEnded 
                          ? context.colors.iconColor 
                          : context.colors.iconColor.withValues(alpha: 0.5),
                    ),
                  ),
                  // Player 2 area (rotated)
                  Expanded(
                    child: Transform.rotate(
                      angle: 3.14159, // 180 degrees for player 2
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: RiveAnimation.asset(
                              'assets/gemmy.riv',
                              artboard: 'Character',
                              controllers: [
                                _player2IdleController,
                                _player2BlinkController
                              ],
                              onInit: (artboard) => _onRiveInit(artboard, 2),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.get('player_2', context),
                                  style: AppTextStyles.body2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '$_player2Correct / ${AppConstants.totalQuestions}',
                                  style: AppTextStyles.body2.copyWith(
                                    fontSize: 12,
                                    color: context.colors.player2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Progress bar for Player 1
            _buildProgressBar(1),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int player) {
    final current = player == 1 ? _player1Current : _player2Current;
    final color = player == 1 ? context.colors.player1 : context.colors.player2;

    Widget progressBar = SizedBox(
      height: 8,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween:
            Tween<double>(begin: 0, end: current / AppConstants.totalQuestions),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
        builder: (context, value, child) => LinearProgressIndicator(
          value: value,
          backgroundColor: context.colors.tabContainerBackground,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );

    // Invert direction for player 2 to match their rotated layout
    if (player == 2) {
      progressBar = Transform.scale(
        scaleX: -1,
        child: progressBar,
      );
    }

    return progressBar;
  }
}

class _DuelStartDialog extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onExit;
  final int countdownTimer;
  final VoidCallback? onCountdownFinished;

  const _DuelStartDialog({
    required this.onStart,
    required this.onExit,
    required this.countdownTimer,
    this.onCountdownFinished,
  });

  @override
  State<_DuelStartDialog> createState() => _DuelStartDialogState();
}

class _DuelStartDialogState extends State<_DuelStartDialog> {
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _countdown = widget.countdownTimer;
    if (_countdown > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 0) {
          _timer?.cancel();
          if (widget.onCountdownFinished != null) {
            widget.onCountdownFinished!();
          }
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 420),
        margin: const EdgeInsets.all(16),
        child: Dialog(
          backgroundColor: context.colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.get('duel_title', context),
                    style: AppTextStyles.h2.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Animated content switching with smooth size transitions
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: _countdown > 0
                        ? Column(
                            key: const ValueKey('countdown'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.get('duel_countdown', context),
                                style: AppTextStyles.body1.copyWith(
                                  color: context.colors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 500),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: 0.8 + (0.2 * value),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: context.colors.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: context.colors.primary.withValues(alpha: 0.3),
                                            blurRadius: 8 * value,
                                            spreadRadius: 2 * value,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 200),
                                          style: AppTextStyles.h1.copyWith(
                                            color: Colors.white,
                                            fontSize: 32,
                                          ),
                                          child: Text(_countdown.toString()),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                          )
                        : Column(
                            key: const ValueKey('buttons'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.get('duel_ready', context),
                                style: AppTextStyles.body1.copyWith(
                                  color: context.colors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PrimaryButton(
                                    text: AppLocalizations.get('start', context),
                                    height: AppButtonDimensions.heightMedium,
                                    onPressed: () {
                                      setState(() {
                                        _countdown = 3;
                                      });
                                      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                                        if (_countdown <= 1) {
                                          _timer?.cancel();
                                          // Close dialog immediately when countdown reaches 0
                                          Navigator.of(context).pop();
                                          // Call callback after dialog is closed
                                          if (widget.onCountdownFinished != null) {
                                            widget.onCountdownFinished!();
                                          }
                                        } else {
                                          setState(() {
                                            _countdown--;
                                          });
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  SecondaryButton(
                                    text: AppLocalizations.get('exit', context),
                                    onPressed: widget.onExit,
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DuelPauseDialog extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onExit;

  const _DuelPauseDialog({
    required this.onResume,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 420),
        margin: const EdgeInsets.all(16),
        child: Dialog(
          backgroundColor: context.colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pause_circle_outline,
                  size: 64,
                  color: context.colors.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppLocalizations.get('pause_title', context),
                  style: AppTextStyles.h2.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppLocalizations.get('pause_message', context),
                  style: AppTextStyles.body1.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      text: AppLocalizations.get('resume', context),
                      height: AppButtonDimensions.heightMedium,
                      width: double.infinity,
                      onPressed: onResume,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SecondaryButton(
                      text: AppLocalizations.get('exit_duel', context),
                      width: double.infinity,
                      onPressed: onExit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

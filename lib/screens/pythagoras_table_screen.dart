import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../core/theme/theme_provider.dart';
import '../core/localization/app_localizations.dart';
import '../components/keyboard/custom_keyboard.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/secondary_button.dart';
import '../components/common/adaptive_button_row.dart';
import '../models/hint_system.dart';
import '../components/hint/hint_popup.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_extensions.dart';
import '../core/localization/language_manager.dart';

class PythagorasTableScreen extends StatelessWidget {
  const PythagorasTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageManager>(
      builder: (context, themeProvider, languageManager, child) {
        return Scaffold(
          backgroundColor: context.colors.screenBackground,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: context.colors.iconColor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppLocalizations.get('pythagoras_table'),
                        style: AppTextStyles.h3.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _PythagorasTableWithModes(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PythagorasTableWithModes extends StatefulWidget {
  @override
  State<_PythagorasTableWithModes> createState() => _PythagorasTableWithModesState();
}

enum TableMode { study, practice }

class _PythagorasTableWithModesState extends State<_PythagorasTableWithModes> 
    with TickerProviderStateMixin {
  TableMode _currentMode = TableMode.practice;
  
  // Single selected cell for both modes
  int? _selectedI;
  int? _selectedJ;
  String _practiceInput = '';
  final Set<String> _solvedCells = {}; // "i_j" format
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  int _currentFactIndex = 0;
  
  // Math facts for study mode
  List<String> get _mathFacts {
    return [
      AppLocalizations.get('math_fact_1'),
      AppLocalizations.get('math_fact_2'),
      AppLocalizations.get('math_fact_3'),
      AppLocalizations.get('math_fact_4'),
      AppLocalizations.get('math_fact_5'),
      AppLocalizations.get('math_fact_6'),
      AppLocalizations.get('math_fact_7'),
      AppLocalizations.get('math_fact_8'),
      AppLocalizations.get('math_fact_9'),
      AppLocalizations.get('math_fact_10'),
    ];
  }
  
  @override
  void initState() {
    super.initState();
    _loadLanguageSettings();
    _shakeController = AnimationController(
      duration: AppConstants.shakeAnimationDuration,
      vsync: this,
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    _loadSolvedCells();
    _generateRandomFact();
  }

  Future<void> _loadLanguageSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('selectedLanguage') ?? 'ru';
    AppLocalizations.setLanguage(language);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _generateRandomFact() {
    setState(() {
      _currentFactIndex = DateTime.now().millisecondsSinceEpoch % _mathFacts.length;
    });
  }

  void _nextFact() {
    setState(() {
      _currentFactIndex = (_currentFactIndex + 1) % _mathFacts.length;
    });
  }

  Future<void> _loadSolvedCells() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final solvedList = prefs.getStringList('pythagoras_solved') ?? [];
      setState(() {
        _solvedCells.clear();
        _solvedCells.addAll(solvedList);
      });
      _generateNewQuestion();
    } catch (e) {
      print('Error loading solved cells: $e');
      _generateNewQuestion();
    }
  }

  Future<void> _saveSolvedCells() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('pythagoras_solved', _solvedCells.toList());
    } catch (e) {
      print('Error saving solved cells: $e');
    }
  }

  void _resetProgress() {
    setState(() {
      _solvedCells.clear();
    });
    _saveSolvedCells();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    final unsolvedCells = <List<int>>[];
    for (int i = 1; i <= 10; i++) {
      for (int j = 1; j <= 10; j++) {
        if (!_solvedCells.contains('${i}_$j')) {
          unsolvedCells.add([i, j]);
        }
      }
    }
    
    // If table is empty (all 100 cells unsolved), always select 5x5
    if (unsolvedCells.length == 100) {
      setState(() {
        _selectedI = 5;
        _selectedJ = 5;
        _practiceInput = '';
      });
    } else if (unsolvedCells.isNotEmpty) {
      final random = unsolvedCells[DateTime.now().millisecondsSinceEpoch % unsolvedCells.length];
      setState(() {
        _selectedI = random[0];
        _selectedJ = random[1];
        _practiceInput = '';
      });
    } else {
      // If all cells are solved, default to 5x5
      setState(() {
        _selectedI = 5;
        _selectedJ = 5;
        _practiceInput = '';
      });
    }
  }

  void _onPracticeKeyboardTap(String value) {
    if (_selectedI == null || _selectedJ == null) return;
    if (_solvedCells.contains('${_selectedI}_$_selectedJ')) return;
    
    setState(() {
      if (value == '<') {
        if (_practiceInput.isNotEmpty) {
          _practiceInput = _practiceInput.substring(0, _practiceInput.length - 1);
        }
      } else {
        if (_practiceInput.length < AppConstants.maxInputLength) {
          _practiceInput += value;
          _checkPracticeAnswer();
        }
      }
    });
  }

  void _checkPracticeAnswer() {
    if (_selectedI == null || _selectedJ == null || _practiceInput.isEmpty) return;
    
    final correctAnswer = _selectedI! * _selectedJ!;
    if (_practiceInput == correctAnswer.toString()) {
      setState(() {
        _solvedCells.add('${_selectedI}_$_selectedJ');
      });
      _saveSolvedCells();
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _generateNewQuestion();
        }
      });
    } else if (_practiceInput.length >= correctAnswer.toString().length) {
      _shakeController.forward().then((_) {
        _shakeController.reverse();
        setState(() {
          _practiceInput = '';
        });
      });
    }
  }

  // Universal method for cell selection (works for both modes)
  void _onCellTap(int i, int j) {
    setState(() {
      _selectedI = i;
      _selectedJ = j;
      _practiceInput = '';
    });
  }

  void _showHint() {
    if (_selectedI == null || _selectedJ == null) return;
    
    final hint = HintSystem.getHint(_selectedI!, _selectedJ!);
    
    if (hint != null) {
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

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Center(
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
                  Text(
                    AppLocalizations.get('reset_progress_title', context),
                    style: AppTextStyles.h3.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppLocalizations.get('reset_progress_message', context),
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AdaptiveButtonRow(
                    children: [
                      SecondaryButton(
                        text: AppLocalizations.get('cancel', context),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      PrimaryButton(
                        text: AppLocalizations.get('reset_action', context),
                        height: AppButtonDimensions.heightMedium,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetProgress();
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
    if (_currentMode == TableMode.study) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.md,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            _buildSegmentControl(),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cellHeight = constraints.maxHeight / 11;
                        return _PythagorasStudyTable(
                          cellHeight: cellHeight,
                          selectedI: _selectedI,
                          selectedJ: _selectedJ,
                          solvedCells: _solvedCells,
                          onCellTap: _onCellTap,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Math facts area with hint button - fixed height to match keyboard
                  SizedBox(
                    height: (AppButtonDimensions.keyboardButton * 4) + 
                            (AppSpacing.sm * 3) + 
                            (AppSpacing.md * 2) + 
                            1, // Exact keyboard height: 217px
                    child: Column(
                      children: [
                        Expanded(child: _MathFactsArea()),
                        // Show hint button only if cell is selected
                        if (_selectedI != null && _selectedJ != null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: SizedBox(
                              width: double.infinity,
                              height: AppButtonDimensions.keyboardButton,
                              child: ElevatedButton(
                                onPressed: _showHint,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colors.cardBackground,
                                  foregroundColor: context.colors.textPrimary,
                                  elevation: 2,
                                  shadowColor: context.colors.dividerColor.withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppBorderRadius.medium,
                                  ),
                                  side: BorderSide(
                                    color: context.colors.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          // Основной контент с отступами
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, 0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    _buildSegmentControl(),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cellHeight = constraints.maxHeight / 11;
                          return Stack(
                            children: [
                              _PythagorasPracticeTable(
                                cellHeight: cellHeight,
                                solvedCells: _solvedCells,
                                selectedI: _selectedI,
                                selectedJ: _selectedJ,
                                currentInput: _practiceInput,
                                shakeAnimation: _shakeAnimation,
                                onReset: _showResetConfirmation,
                                onCellTap: _onCellTap,
                              ),
                              // Show tooltip for empty table when 5x5 is selected
                              if (_solvedCells.isEmpty && _selectedI == 5 && _selectedJ == 5)
                                _buildTooltip(cellHeight),
                            ],
                          );
                        },
                      ),
                    ),
                    // Дополнительное пространство перед клавиатурой
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
          // Клавиатура без отступов от краев
          SafeArea(
            top: false,
            child: CustomKeyboard(
              onTap: _onPracticeKeyboardTap,
              enabled: true,
              onHintTap: _showHint,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSegmentControl() {
    return Container(
      height: AppButtonDimensions.heightMedium,
      decoration: BoxDecoration(
        color: context.colors.tabContainerBackground,
        borderRadius: AppBorderRadius.medium,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentMode = TableMode.practice;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: _currentMode == TableMode.practice ? context.colors.cardBackground : context.colors.tabBackgroundInactive,
                  borderRadius: AppBorderRadius.small,
                  boxShadow: _currentMode == TableMode.practice ? [
                    BoxShadow(
                      color: context.colors.dividerColor,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ] : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.get('practice'),
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _currentMode == TableMode.practice 
                        ? context.colors.textPrimary
                        : context.colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentMode = TableMode.study;
                  _generateRandomFact();
                });
              },
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: _currentMode == TableMode.study ? context.colors.cardBackground : context.colors.tabBackgroundInactive,
                  borderRadius: AppBorderRadius.small,
                  boxShadow: _currentMode == TableMode.study ? [
                    BoxShadow(
                      color: context.colors.dividerColor,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ] : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.get('theory'),
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _currentMode == TableMode.study 
                        ? context.colors.textPrimary
                        : context.colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _MathFactsArea() {
    return GestureDetector(
      onTap: _nextFact,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        margin: const EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: AppBorderRadius.large,
          border: Border.all(color: context.colors.dividerColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.get('interesting_facts'),
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _mathFacts[_currentFactIndex],
                  style: AppTextStyles.body2.copyWith(
                    height: 1.5,
                    color: context.colors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltip(double cellHeight) {
    // Calculate position for 5x5 cell more accurately
    final screenWidth = MediaQuery.of(context).size.width;
    final tableWidth = screenWidth - (AppSpacing.md * 2); // Account for screen padding
    final cellWidth = tableWidth / 11; // 11 columns (1 header + 10 data)
    
    // 5x5 cell position: header(1) + 4 columns = column 5, header(1) + 4 rows = row 5
    final leftPosition = cellWidth * 5.5; // Center of column 5 (0-indexed)
    final topPosition = cellHeight * 5.5; // Center of row 5 (0-indexed)
    
    return Positioned(
      top: topPosition + cellHeight + 4, // Below the cell
      left: leftPosition - 40, // Center tooltip on cell
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          elevation: 10, // Higher elevation for visibility
          child: CustomPaint(
            painter: _TooltipPainter(
              pointsUp: true,
              backgroundColor: context.colors.textPrimary,
            ),
            child: Container(
              constraints: const BoxConstraints(minWidth: 80, minHeight: 40),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Center(
                child: Text(
                  AppLocalizations.get('enter_answer'),
                  style: TextStyle(
                    color: context.colors.cardBackground,
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PythagorasStudyTable extends StatelessWidget {
  final double cellHeight;
  final int? selectedI;
  final int? selectedJ;
  final Set<String> solvedCells;
  final Function(int, int) onCellTap;

  const _PythagorasStudyTable({
    required this.cellHeight,
    required this.selectedI,
    required this.selectedJ,
    required this.solvedCells,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    const int size = 10;
    return Table(
      defaultColumnWidth: const FlexColumnWidth(),
      border: const TableBorder(),
      children: [
        TableRow(
          children: [
            const SizedBox(),
            for (int j = 1; j <= size; j++)
              Container(
                margin: const EdgeInsets.all(1),
                height: cellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedJ == j ? context.colors.warning : context.colors.cardBackground,
                  borderRadius: AppBorderRadius.extraSmall,
                ),
                child: Text(
                  j.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedJ == j ? context.colors.cardBackground : context.colors.warning,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        for (int i = 1; i <= size; i++)
          TableRow(
            children: [
              Container(
                margin: const EdgeInsets.all(1),
                height: cellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedI == i ? context.colors.warning : context.colors.cardBackground,
                  borderRadius: AppBorderRadius.extraSmall,
                ),
                child: Text(
                  i.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedI == i ? context.colors.cardBackground : context.colors.warning,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              for (int j = 1; j <= size; j++)
                GestureDetector(
                  onTap: () => onCellTap(i, j),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                                        color: (selectedI == i && selectedJ == j) 
                  ? context.colors.success
                  : context.colors.tableEmpty,
                          borderRadius: AppBorderRadius.extraSmall,
                        ),
                        alignment: Alignment.center,
                        height: cellHeight,
                        child: Text(
                          (i * j).toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: (selectedI == i && selectedJ == j) 
                                ? context.colors.cardBackground
                                : context.colors.textPrimary,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _PythagorasPracticeTable extends StatelessWidget {
  final double cellHeight;
  final Set<String> solvedCells;
  final int? selectedI;
  final int? selectedJ;
  final String currentInput;
  final Animation<Offset> shakeAnimation;
  final VoidCallback onReset;
  final Function(int, int) onCellTap;

  const _PythagorasPracticeTable({
    required this.cellHeight,
    required this.solvedCells,
    required this.selectedI,
    required this.selectedJ,
    required this.currentInput,
    required this.shakeAnimation,
    required this.onReset,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    const int size = 10;
    return Table(
      defaultColumnWidth: const FlexColumnWidth(),
      border: const TableBorder(),
      children: [
        TableRow(
          children: [
            GestureDetector(
              onTap: onReset,
              child: Container(
                margin: const EdgeInsets.all(1),
                height: cellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.controlBackground,
                  borderRadius: AppBorderRadius.extraSmall,
                  border: Border.all(color: context.colors.dividerColor, width: 1),
                ),
                child: Icon(
                  Icons.refresh,
                  color: context.colors.textSecondary,
                  size: 16,
                ),
              ),
            ),
            for (int j = 1; j <= size; j++)
              Container(
                margin: const EdgeInsets.all(1),
                height: cellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedJ == j ? context.colors.warning : context.colors.cardBackground,
                  borderRadius: AppBorderRadius.extraSmall,
                ),
                child: Text(
                  j.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedJ == j ? context.colors.cardBackground : context.colors.warning,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        for (int i = 1; i <= size; i++)
          TableRow(
            children: [
              Container(
                margin: const EdgeInsets.all(1),
                height: cellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedI == i ? context.colors.warning : context.colors.cardBackground,
                  borderRadius: AppBorderRadius.extraSmall,
                ),
                child: Text(
                  i.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedI == i ? context.colors.cardBackground : context.colors.warning,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              for (int j = 1; j <= size; j++)
                _buildPracticeCell(context, i, j),
            ],
          ),
      ],
    );
  }

  Widget _buildPracticeCell(BuildContext context, int i, int j) {
    final isSolved = solvedCells.contains('${i}_$j');
    final isCurrent = selectedI == i && selectedJ == j;

    Widget cell = GestureDetector(
      onTap: () => onCellTap(i, j),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: isSolved
                  ? context.colors.primary
                  : isCurrent
                      ? context.colors.warningLight
                      : context.colors.tableEmpty,
              border: isCurrent
                  ? Border.all(
                      color: isSolved ? context.colors.success : context.colors.warning, 
                      width: 2,
                    )
                  : null,
              borderRadius: AppBorderRadius.extraSmall,
            ),
            alignment: Alignment.center,
            height: cellHeight,
            child: Text(
              isSolved
                  ? (i * j).toString()
                  : isCurrent && currentInput.isNotEmpty
                      ? currentInput
                      : '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSolved ? context.colors.cardBackground : context.colors.textPrimary,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    if (isCurrent && !isSolved) {
      return AnimatedBuilder(
        animation: shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: shakeAnimation.value * 20,
            child: Container(
              decoration: shakeAnimation.value != Offset.zero
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                  : null,
              child: cell,
            ),
          );
        },
      );
    }

    return cell;
  }
}

// Custom painter for tooltip with triangle
class _TooltipPainter extends CustomPainter {
  final bool pointsUp;
  final Color backgroundColor;

  _TooltipPainter({
    required this.pointsUp,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();
    const radius = 8.0;
    const triangleSize = 6.0;

    if (pointsUp) {
      // Triangle pointing up
      path.moveTo(size.width / 2 - triangleSize, triangleSize);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width / 2 + triangleSize, triangleSize);
      
      // Rounded rectangle below triangle
      path.addRRect(RRect.fromLTRBR(
        0, 
        triangleSize, 
        size.width, 
        size.height, 
        const Radius.circular(radius),
      ));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 
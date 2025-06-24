import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../models/question_result.dart';
import '../components/buttons/primary_button.dart';
import '../components/common/responsive_wrapper.dart';

import '../core/theme/theme_extensions.dart';
import 'welcome_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  final List<QuestionResult> results;

  const ResultScreen({
    required this.correct,
    required this.total,
    required this.results,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final correctFirstTry = results.where((r) => r.correctFromFirstTry).length;
    final mistakes = results.where((r) => !r.correctFromFirstTry).toList();
    final hintsUsed = results.where((r) => r.hintUsed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат'),
        automaticallyImplyLeading: false,
        backgroundColor: context.colors.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: context.colors.onBackground,
        ),
      ),
      backgroundColor: context.colors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Без ошибок: $correctFirstTry из $total',
              style: AppTextStyles.h2.copyWith(
                color: context.colors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            
            if (hintsUsed > 0)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.warning.withOpacity(0.1),
                  borderRadius: AppBorderRadius.medium,
                  border: Border.all(
                    color: context.colors.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: context.colors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Подсказок использовано: $hintsUsed',
                      style: AppTextStyles.body1.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: AppSpacing.lg),
            
            if (mistakes.isNotEmpty) ...[
              Text(
                'Ошибки:',
                style: AppTextStyles.h3.copyWith(color: context.colors.error),
              ),
              const SizedBox(height: AppSpacing.sm),
              
              ...mistakes.map((r) => Card(
                color: context.colors.warningLight,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.a} × ${r.b} = ${r.correctAnswer}',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Ваши ответы: ${r.userAnswers.join(", ")}',
                        style: AppTextStyles.body2.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Правильный ответ: ${r.correctAnswer}',
                        style: AppTextStyles.body2.copyWith(
                          color: context.colors.success,
                        ),
                      ),
                      if (r.hintUsed)
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: context.colors.warning,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Использована подсказка',
                              style: AppTextStyles.body2.copyWith(
                                color: context.colors.warning,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: AppSpacing.lg),
            ],
            
            PrimaryButton(
              text: 'Завершить тренировку',
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ResponsiveWrapper(
                    child: WelcomeScreen(),
                  ),
                ),
                (route) => false,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
} 
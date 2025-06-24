class QuestionResult {
  final int a;
  final int b;
  final int correctAnswer;
  final List<String> userAnswers;
  final bool correctFromFirstTry;
  final bool hintUsed;

  QuestionResult({
    required this.a,
    required this.b,
    required this.correctAnswer,
    required this.userAnswers,
    required this.correctFromFirstTry,
    this.hintUsed = false,
  });
} 
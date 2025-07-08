class MultiplicationHint {
  final int a;
  final int b;
  final Map<String, String> title;
  final Map<String, String> description;
  final Map<String, String> technique;
  final Map<String, String> visualization;

  MultiplicationHint({
    required this.a,
    required this.b,
    required this.title,
    required this.description,
    required this.technique,
    required this.visualization,
  });
}

class HintSystem {
  static final Map<String, MultiplicationHint> _hints = {
    // Multiply by 1
    '1_x': MultiplicationHint(
      a: 1, b: 0,
      title: {
        'ru': 'Умножение на 1 🎯',
        'en': 'Multiply by 1 🎯',
        'de': 'Mit 1 multiplizieren 🎯',
      },
      description: {
        'ru': 'Любое число, умноженное на 1, остается таким же!',
        'en': 'Any number multiplied by 1 stays the same!',
        'de': 'Jede Zahl multipliziert mit 1 bleibt gleich!',
      },
      technique: {
        'ru': '🔹 Помни: 1 × любое число = это же число\n🔹 Представь, что у тебя 1 коробка с конфетами - сколько всего конфет?',
        'en': '🔹 Remember: 1 × any number = that same number\n🔹 Imagine you have 1 box of candies - how many candies total?',
        'de': '🔹 Merke: 1 × beliebige Zahl = diese Zahl\n🔹 Stell dir vor, du hast 1 Schachtel Bonbons - wie viele sind es insgesamt?',
      },
      visualization: {
        'ru': '✨ Магическая единица! Она никогда не меняет числа!',
        'en': '✨ Magic one! It never changes numbers!',
        'de': '✨ Magische Eins! Sie verändert Zahlen nie!',
      },
    ),

    // Multiply by 2
    '2_x': MultiplicationHint(
      a: 2, b: 0,
      title: {
        'ru': 'Умножение на 2 - Удваиваем! 🐰',
        'en': 'Multiply by 2 - Double it! 🐰',
        'de': 'Mit 2 multiplizieren - Verdoppeln! 🐰',
      },
      description: {
        'ru': 'Умножить на 2 = просто сложить число с самим собой!',
        'en': 'Multiply by 2 = just add the number to itself!',
        'de': 'Mit 2 multiplizieren = die Zahl zu sich selbst addieren!',
      },
      technique: {
        'ru': '🔹 2 × 7 = 7 + 7 = 14\n🔹 Представь двух одинаковых кроликов - сколько всего ушек? 🐰🐰\n🔹 Считай парами: 2, 4, 6, 8, 10...',
        'en': '🔹 2 × 7 = 7 + 7 = 14\n🔹 Imagine two identical rabbits - how many ears total? 🐰🐰\n🔹 Count by twos: 2, 4, 6, 8, 10...',
        'de': '🔹 2 × 7 = 7 + 7 = 14\n🔹 Stell dir zwei gleiche Hasen vor - wie viele Ohren insgesamt? 🐰🐰\n🔹 Zähle in Zweierschritten: 2, 4, 6, 8, 10...',
      },
      visualization: {
        'ru': '👥 Всё удваивается! Как близнецы - всегда по двое!',
        'en': '👥 Everything doubles! Like twins - always in pairs!',
        'de': '👥 Alles verdoppelt sich! Wie Zwillinge - immer zu zweit!',
      },
    ),

    // Multiply by 3
    '3_x': MultiplicationHint(
      a: 3, b: 0,
      title: {
        'ru': 'Умножение на 3 - Троица! 🍀',
        'en': 'Multiply by 3 - Trinity! 🍀',
        'de': 'Mit 3 multiplizieren - Dreifach! 🍀',
      },
      description: {
        'ru': 'Тройка - магическое число! Считай по три!',
        'en': 'Three is a magic number! Count by threes!',
        'de': 'Drei ist eine magische Zahl! Zähle in Dreierschritten!',
      },
      technique: {
        'ru': '🔹 3 × 4 = 4 + 4 + 4 = 12\n🔹 Представь треугольники: 3 угла у каждого! △△△\n🔹 Считай: 3, 6, 9, 12, 15, 18...\n🔹 Трюк: сумма цифр результата кратна 3!',
        'en': '🔹 3 × 4 = 4 + 4 + 4 = 12\n🔹 Imagine triangles: 3 corners each! △△△\n🔹 Count: 3, 6, 9, 12, 15, 18...\n🔹 Trick: sum of result digits is divisible by 3!',
        'de': '🔹 3 × 4 = 4 + 4 + 4 = 12\n🔹 Stell dir Dreiecke vor: 3 Ecken jedes! △△△\n🔹 Zähle: 3, 6, 9, 12, 15, 18...\n🔹 Trick: Quersumme des Ergebnisses ist durch 3 teilbar!',
      },
      visualization: {
        'ru': '🍀 Счастливая тройка! Как трёхлистный клевер!',
        'en': '🍀 Lucky three! Like a three-leaf clover!',
        'de': '🍀 Glückliche Drei! Wie ein dreiblättriger Klee!',
      },
    ),

    // Multiply by 4  
    '4_x': MultiplicationHint(
      a: 4, b: 0,
      title: {
        'ru': 'Умножение на 4 - Квадраты! ⬜',
        'en': 'Multiply by 4 - Squares! ⬜',
        'de': 'Mit 4 multiplizieren - Quadrate! ⬜',
      },
      description: {
        'ru': 'Четверка - это удвоенная двойка! 4 = 2 × 2',
        'en': 'Four is double two! 4 = 2 × 2',
        'de': 'Vier ist doppelte Zwei! 4 = 2 × 2',
      },
      technique: {
        'ru': '🔹 4 × 6 = (2 × 6) × 2 = 12 × 2 = 24\n🔹 Или: 4 × 6 = 6 + 6 + 6 + 6\n🔹 Представь квадраты: 4 стороны! ⬜⬜⬜\n🔹 Считай: 4, 8, 12, 16, 20, 24...',
        'en': '🔹 4 × 6 = (2 × 6) × 2 = 12 × 2 = 24\n🔹 Or: 4 × 6 = 6 + 6 + 6 + 6\n🔹 Imagine squares: 4 sides! ⬜⬜⬜\n🔹 Count: 4, 8, 12, 16, 20, 24...',
        'de': '🔹 4 × 6 = (2 × 6) × 2 = 12 × 2 = 24\n🔹 Oder: 4 × 6 = 6 + 6 + 6 + 6\n🔹 Stell dir Quadrate vor: 4 Seiten! ⬜⬜⬜\n🔹 Zähle: 4, 8, 12, 16, 20, 24...',
      },
      visualization: {
        'ru': '🎲 Четверка как игральный кубик - всегда четные числа!',
        'en': '🎲 Four like a dice - always even numbers!',
        'de': '🎲 Vier wie ein Würfel - immer gerade Zahlen!',
      },
    ),

    // Multiply by 5
    '5_x': MultiplicationHint(
      a: 5, b: 0,
      title: {
        'ru': 'Умножение на 5 - Пятерочка! ✋',
        'en': 'Multiply by 5 - High Five! ✋',
        'de': 'Mit 5 multiplizieren - Fünf! ✋',
      },
      description: {
        'ru': 'Самое легкое! Результат всегда кончается на 0 или 5!',
        'en': 'The easiest! Result always ends in 0 or 5!',
        'de': 'Am einfachsten! Ergebnis endet immer auf 0 oder 5!',
      },
      technique: {
        'ru': '🔹 Четное число × 5 = кончается на 0\n🔹 Нечетное число × 5 = кончается на 5\n🔹 5 × 6 = 30, 5 × 7 = 35\n🔹 Трюк: 5 × число = (число × 10) ÷ 2\n🔹 Считай пятерками: 5, 10, 15, 20, 25...',
        'en': '🔹 Even number × 5 = ends in 0\n🔹 Odd number × 5 = ends in 5\n🔹 5 × 6 = 30, 5 × 7 = 35\n🔹 Trick: 5 × number = (number × 10) ÷ 2\n🔹 Count by fives: 5, 10, 15, 20, 25...',
        'de': '🔹 Gerade Zahl × 5 = endet auf 0\n🔹 Ungerade Zahl × 5 = endet auf 5\n🔹 5 × 6 = 30, 5 × 7 = 35\n🔹 Trick: 5 × Zahl = (Zahl × 10) ÷ 2\n🔹 Zähle in Fünferschritten: 5, 10, 15, 20, 25...',
      },
      visualization: {
        'ru': '✋ Как пальцы на руке! Очень просто запомнить!',
        'en': '✋ Like fingers on a hand! Very easy to remember!',
        'de': '✋ Wie Finger an der Hand! Sehr leicht zu merken!',
      },
    ),

    // Multiply by 6
    '6_x': MultiplicationHint(
      a: 6, b: 0,
      title: {
        'ru': 'Умножение на 6 - Шестерочка! 🎲',
        'en': 'Multiply by 6 - Sixer! 🎲',
        'de': 'Mit 6 multiplizieren - Sechs! 🎲',
      },
      description: {
        'ru': 'Шестерка = 2 × 3! Используй это!',
        'en': 'Six = 2 × 3! Use this!',
        'de': 'Sechs = 2 × 3! Nutze das!',
      },
      technique: {
        'ru': '🔹 6 × 8 = (2 × 8) × 3 = 16 × 3 = 48\n🔹 Или: 6 × 8 = (3 × 8) × 2 = 24 × 2 = 48\n🔹 Считай шестерками: 6, 12, 18, 24, 30...\n🔹 Все результаты четные!',
        'en': '🔹 6 × 8 = (2 × 8) × 3 = 16 × 3 = 48\n🔹 Or: 6 × 8 = (3 × 8) × 2 = 24 × 2 = 48\n🔹 Count by sixes: 6, 12, 18, 24, 30...\n🔹 All results are even!',
        'de': '🔹 6 × 8 = (2 × 8) × 3 = 16 × 3 = 48\n🔹 Oder: 6 × 8 = (3 × 8) × 2 = 24 × 2 = 48\n🔹 Zähle in Sechserschritten: 6, 12, 18, 24, 30...\n🔹 Alle Ergebnisse sind gerade!',
      },
      visualization: {
        'ru': '🎲 Как кубик на кости - всегда четные числа!',
        'en': '🎲 Like a die - always even numbers!',
        'de': '🎲 Wie ein Würfel - immer gerade Zahlen!',
      },
    ),

    // Multiply by 7
    '7_x': MultiplicationHint(
      a: 7, b: 0,
      title: {
        'ru': 'Умножение на 7 - Счастливая семерка! 🍀',
        'en': 'Multiply by 7 - Lucky Seven! 🍀',
        'de': 'Mit 7 multiplizieren - Glücksieben! 🍀',
      },
      description: {
        'ru': 'Семерка - особенная! Нужно запомнить рифмы!',
        'en': 'Seven is special! Need to remember rhymes!',
        'de': 'Sieben ist besonders! Reime merken!',
      },
      technique: {
        'ru': '🔹 7 × 7 = 49 (семь на семь - сорок девять!)\n🔹 7 × 8 = 56 (семь на восемь - пятьдесят шесть!)\n🔹 7 × 6 = 42 (помни: 6 × 7 = 42)\n🔹 Считай семерками: 7, 14, 21, 28, 35, 42...',
        'en': '🔹 7 × 7 = 49 (seven times seven - forty-nine!)\n🔹 7 × 8 = 56 (seven times eight - fifty-six!)\n🔹 7 × 6 = 42 (remember: 6 × 7 = 42)\n🔹 Count by sevens: 7, 14, 21, 28, 35, 42...',
        'de': '🔹 7 × 7 = 49 (sieben mal sieben - neunundvierzig!)\n🔹 7 × 8 = 56 (sieben mal acht - sechsundfünfzig!)\n🔹 7 × 6 = 42 (merke: 6 × 7 = 42)\n🔹 Zähle in Siebenerschritten: 7, 14, 21, 28, 35, 42...',
      },
      visualization: {
        'ru': '🌟 Счастливая семерка! Как семь цветов радуги!',
        'en': '🌟 Lucky seven! Like seven colors of rainbow!',
        'de': '🌟 Glücksieben! Wie sieben Regenbogenfarben!',
      },
    ),

    // Multiply by 8
    '8_x': MultiplicationHint(
      a: 8, b: 0,
      title: {
        'ru': 'Умножение на 8 - Восьмерка! ♾️',
        'en': 'Multiply by 8 - Figure Eight! ♾️',
        'de': 'Mit 8 multiplizieren - Acht! ♾️',
      },
      description: {
        'ru': 'Восьмерка = 2 × 2 × 2! Удваивай трижды!',
        'en': 'Eight = 2 × 2 × 2! Double three times!',
        'de': 'Acht = 2 × 2 × 2! Drei Mal verdoppeln!',
      },
      technique: {
        'ru': '🔹 8 × 7 = (4 × 7) × 2 = 28 × 2 = 56\n🔹 Или: 8 × 7 = (2 × 7) × 4 = 14 × 4 = 56\n🔹 Считай восьмерками: 8, 16, 24, 32, 40, 48...\n🔹 Все результаты четные!',
        'en': '🔹 8 × 7 = (4 × 7) × 2 = 28 × 2 = 56\n🔹 Or: 8 × 7 = (2 × 7) × 4 = 14 × 4 = 56\n🔹 Count by eights: 8, 16, 24, 32, 40, 48...\n🔹 All results are even!',
        'de': '🔹 8 × 7 = (4 × 7) × 2 = 28 × 2 = 56\n🔹 Oder: 8 × 7 = (2 × 7) × 4 = 14 × 4 = 56\n🔹 Zähle in Achterschritten: 8, 16, 24, 32, 40, 48...\n🔹 Alle Ergebnisse sind gerade!',
      },
      visualization: {
        'ru': '♾️ Восьмерка как знак бесконечности! Мощное число!',
        'en': '♾️ Eight like infinity sign! Powerful number!',
        'de': '♾️ Acht wie das Unendlichkeitszeichen! Mächtige Zahl!',
      },
    ),

    // Multiply by 9
    '9_x': MultiplicationHint(
      a: 9, b: 0,
      title: {
        'ru': 'Умножение на 9 - Магическая девятка! ✨',
        'en': 'Multiply by 9 - Magic Nine! ✨',
        'de': 'Mit 9 multiplizieren - Magische Neun! ✨',
      },
      description: {
        'ru': 'У девятки есть волшебные секреты!',
        'en': 'Nine has magical secrets!',
        'de': 'Neun hat magische Geheimnisse!',
      },
      technique: {
        'ru': '🔹 Трюк с пальцами: загни палец № умножаемого числа\n🔹 9 × 4: загни 4-й палец, останется 3|6 = 36\n🔹 Сумма цифр результата всегда = 9!\n🔹 9 × 6 = 54 (5+4=9), 9 × 8 = 72 (7+2=9)\n🔹 Считай девятками: 9, 18, 27, 36, 45...',
        'en': '🔹 Finger trick: bend the finger of the multiplied number\n🔹 9 × 4: bend 4th finger, left 3|6 = 36\n🔹 Sum of result digits always = 9!\n🔹 9 × 6 = 54 (5+4=9), 9 × 8 = 72 (7+2=9)\n🔹 Count by nines: 9, 18, 27, 36, 45...',
        'de': '🔹 Fingertrick: beuge den Finger der zu multiplizierenden Zahl\n🔹 9 × 4: beuge 4. Finger, bleibt 3|6 = 36\n🔹 Quersumme des Ergebnisses immer = 9!\n🔹 9 × 6 = 54 (5+4=9), 9 × 8 = 72 (7+2=9)\n🔹 Zähle in Neunerschritten: 9, 18, 27, 36, 45...',
      },
      visualization: {
        'ru': '✨ Волшебная девятка! Самые крутые трюки!',
        'en': '✨ Magical nine! The coolest tricks!',
        'de': '✨ Magische Neun! Die coolsten Tricks!',
      },
    ),

    // Multiply by 10
    '10_x': MultiplicationHint(
      a: 10, b: 0,
      title: {
        'ru': 'Умножение на 10 - Проще простого! 🔟',
        'en': 'Multiply by 10 - Super Easy! 🔟',
        'de': 'Mit 10 multiplizieren - Kinderleicht! 🔟',
      },
      description: {
        'ru': 'Самое легкое в мире! Просто добавь ноль!',
        'en': 'Easiest in the world! Just add a zero!',
        'de': 'Einfachstes der Welt! Einfach eine Null anhängen!',
      },
      technique: {
        'ru': '🔹 10 × любое число = то же число + 0\n🔹 10 × 7 = 70, 10 × 25 = 250\n🔹 Представь: 10 коробок по 3 конфеты = 30 конфет\n🔹 Считай десятками: 10, 20, 30, 40, 50...',
        'en': '🔹 10 × any number = same number + 0\n🔹 10 × 7 = 70, 10 × 25 = 250\n🔹 Imagine: 10 boxes of 3 candies = 30 candies\n🔹 Count by tens: 10, 20, 30, 40, 50...',
        'de': '🔹 10 × beliebige Zahl = gleiche Zahl + 0\n🔹 10 × 7 = 70, 10 × 25 = 250\n🔹 Stell dir vor: 10 Schachteln mit 3 Bonbons = 30 Bonbons\n🔹 Zähle in Zehnerschritten: 10, 20, 30, 40, 50...',
      },
      visualization: {
        'ru': '🔟 Десятка - королева чисел! Всегда с нулем на конце!',
        'en': '🔟 Ten - queen of numbers! Always with zero at the end!',
        'de': '🔟 Zehn - Königin der Zahlen! Immer mit Null am Ende!',
      },
    ),
  };

  static MultiplicationHint? getHint(int a, int b) {
    // Try direct match first
    String key = '${a}_$b';
    if (_hints.containsKey(key)) {
      return _hints[key];
    }
    
    // Try reversed match  
    key = '${b}_$a';
    if (_hints.containsKey(key)) {
      return _hints[key];
    }
    
    // Try pattern match for any number with specific multiplier
    key = '${a}_x';
    if (_hints.containsKey(key)) {
      final hint = _hints[key];
      if (hint != null) {
        return MultiplicationHint(
          a: a,
          b: b,
          title: hint.title,
          description: hint.description,
          technique: hint.technique,
          visualization: hint.visualization,
        );
      }
    }
    
    key = '${b}_x';
    if (_hints.containsKey(key)) {
      final hint = _hints[key];
      if (hint != null) {
        return MultiplicationHint(
          a: b,
          b: a,
          title: hint.title,
          description: hint.description,
          technique: hint.technique,
          visualization: hint.visualization,
        );
      }
    }
    
    return null;
  }
} 
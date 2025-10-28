import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_manager.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      'app_title': 'НумНум',
      'app_subtitle': 'Изучай таблицу умножения',
      'settings': 'Настройки',
      'start_training': 'Начать тренировку',
      'duel': 'Дуэль',
      'pythagoras_table': 'Таблица Пифагора',
      'solved_today': 'Решено сегодня',
      'accuracy': 'Точность',
      'win_streak': 'Серия побед',
      'total_solved': 'Всего решено',
      'multiplication_table': 'Таблица умножения',
      'multiplication_tables': 'Таблица умножения',
      'multiplication_tables_description': 'Выберите числа, которые хотите тренировать',
      'language': 'Язык',
      'theme': 'Тема',
      'select_numbers': 'Выберите, какие числа будут использоваться в тренировках и дуэлях. Должно быть выбрано минимум одно число.',
      'select_all': 'Выбрать все',
      'reset': 'Сбросить',
      'select_numbers_title': 'Выберите числа для изучения',
      'theme_light': 'Светлая',
      'theme_dark': 'Темная',
      'theme_system': 'Системная',
      'russian': 'Русский',
      'english': 'English',
      'german': 'Deutsch',
      'min': 'мин',
      'practice': 'Практика',
      'theory': 'Теория',
      'interesting_facts': 'Интересные факты',
      'enter_answer': 'Введите\n5×5=?',
      'math_fact_1': 'Таблица умножения была изобретена более 4000 лет назад в Древнем Вавилоне! 🏛️',
      'math_fact_2': 'Знаешь ли ты, что умножение на 9 даёт особый узор? Сумма цифр результата всегда равна 9! 🔢',
      'math_fact_3': 'В Китае дети учат таблицу умножения до 19×19, а не только до 10×10! 🇨🇳',
      'math_fact_4': 'Если умножить любое число на 11, то результат можно получить очень быстро: просто "раздвинь" цифры и сложи соседние! ✨',
      'math_fact_5': 'Таблица Пифагора названа в честь древнегреческого математика, но он её не изобретал! 🏺',
      'math_fact_6': 'Самый быстрый способ умножения на 5: умножь на 10 и раздели пополам! ⚡',
      'math_fact_7': 'В природе много примеров умножения: лепестки цветов, листья растений часто растут по определённым математическим законам! 🌸',
      'math_fact_8': 'Знаешь ли ты, что 12×12=144, а 21×21=441? Это не случайность! 🔄',
      'math_fact_9': 'Арабские цифры, которыми мы пользуемся, пришли к нам из Индии через арабские страны! 🌍',
      'math_fact_10': 'Умножение на 10 - самое простое: просто добавь ноль в конце! 🔟',
      
      // Modal dialogs
      'exit_lesson_title': 'Выйти из урока?',
      'exit_lesson_message': 'Прогресс будет потерян.',
      'cancel': 'Отмена',
      'exit': 'Выйти',
      'duel_title': 'Дуэль',
      'duel_countdown': 'Дуэль начнется через',
      'duel_ready': 'Готовы к математической дуэли?',
      'start': 'Начать',
      'tie': 'Ничья!',
      'player_wins': 'Победил игрок',
      'player_1': 'Игрок 1',
      'player_2': 'Игрок 2',
      'play_again': 'Еще раз',
      'reset_progress_title': 'Сбросить прогресс?',
      'reset_progress_message': 'Все решения в таблице будут очищены.',
      'reset_action': 'Сбросить',
      'hint_button': '💡 Подсказка',
      'done': 'Готово!',
      'correct': 'Верно!',
      'incorrect': 'не подходит :(',
      'pause_title': 'Пауза',
      'pause_message': 'Дуэль приостановлена',
      'resume': 'Продолжить',
      'exit_duel': 'Выйти из дуэли',
      // Parent metrics
      'parent_days_streak': 'Дней подряд',
      'parent_trainings_today': 'Тренировок сегодня',
      'parent_trainings_total': 'Всего тренировок',
    },
    'en': {
      'app_title': 'NumNum',
      'app_subtitle': 'Learn multiplication table',
      'settings': 'Settings',
      'start_training': 'Start Training',
      'duel': 'Duel',
      'pythagoras_table': 'Pythagoras Table',
      'solved_today': 'Solved Today',
      'accuracy': 'Accuracy',
      'win_streak': 'Win Streak',
      'total_solved': 'Total Solved',
      'multiplication_table': 'Multiplication Table',
      'multiplication_tables': 'Multiplication Tables',
      'multiplication_tables_description': 'Select the numbers you want to practice',
      'language': 'Language',
      'theme': 'Theme',
      'select_numbers': 'Select which numbers will be used in training and duels. At least one number must be selected.',
      'select_all': 'Select All',
      'reset': 'Reset',
      'select_numbers_title': 'Select numbers to study',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'russian': 'Русский',
      'english': 'English',
      'german': 'Deutsch',
      'min': 'min',
      'practice': 'Practice',
      'theory': 'Theory',
      'interesting_facts': 'Interesting Facts',
      'enter_answer': 'Enter\n5×5=?',
      'math_fact_1': 'The multiplication table was invented over 4000 years ago in ancient Babylon! 🏛️',
      'math_fact_2': 'Did you know that multiplying by 9 creates a special pattern? The sum of digits always equals 9! 🔢',
      'math_fact_3': 'In China, children learn multiplication tables up to 19×19, not just 10×10! 🇨🇳',
      'math_fact_4': 'To multiply any number by 11 quickly: just "spread" the digits and add adjacent ones! ✨',
      'math_fact_5': 'The Pythagoras table is named after the ancient Greek mathematician, but he didn\'t invent it! 🏺',
      'math_fact_6': 'The fastest way to multiply by 5: multiply by 10 and divide by half! ⚡',
      'math_fact_7': 'Nature has many examples of multiplication: flower petals and plant leaves often grow according to mathematical laws! 🌸',
      'math_fact_8': 'Did you know that 12×12=144 and 21×21=441? This is not a coincidence! 🔄',
      'math_fact_9': 'The Arabic numerals we use came to us from India through Arab countries! 🌍',
      'math_fact_10': 'Multiplying by 10 is the simplest: just add a zero at the end! 🔟',
      
      // Modal dialogs
      'exit_lesson_title': 'Exit lesson?',
      'exit_lesson_message': 'Progress will be lost.',
      'cancel': 'Cancel',
      'exit': 'Exit',
      'duel_title': 'Duel',
      'duel_countdown': 'Duel will start in',
      'duel_ready': 'Ready for a math duel?',
      'start': 'Start',
      'tie': 'Tie!',
      'player_wins': 'Player wins',
      'player_1': 'Player 1',
      'player_2': 'Player 2',
      'play_again': 'Play Again',
      'reset_progress_title': 'Reset progress?',
      'reset_progress_message': 'All solutions in the table will be cleared.',
      'reset_action': 'Reset',
      'hint_button': '💡 Hint',
      'done': 'Done!',
      'correct': 'Correct!',
      'incorrect': 'doesn\'t fit :(',
      'pause_title': 'Pause',
      'pause_message': 'Duel paused',
      'resume': 'Resume',
      'exit_duel': 'Exit duel',
      // Parent metrics
      'parent_days_streak': 'Days in a row',
      'parent_trainings_today': 'Trainings today',
      'parent_trainings_total': 'Total trainings',
    },
    'de': {
      'app_title': 'NumNum',
      'app_subtitle': 'Lerne das Einmaleins',
      'settings': 'Einstellungen',
      'start_training': 'Training starten',
      'duel': 'Duell',
      'pythagoras_table': 'Pythagoras-Tabelle',
      'solved_today': 'Heute gelöst',
      'accuracy': 'Genauigkeit',
      'win_streak': 'Siegesserie',
      'total_solved': 'Gesamt gelöst',
      'multiplication_table': 'Einmaleins',
      'multiplication_tables': 'Einmaleins',
      'multiplication_tables_description': 'Wähle die Zahlen zum Üben aus',
      'language': 'Sprache',
      'theme': 'Design',
      'select_numbers': 'Wählen Sie aus, welche Zahlen in Training und Duellen verwendet werden. Mindestens eine Zahl muss ausgewählt werden.',
      'select_all': 'Alle auswählen',
      'reset': 'Zurücksetzen',
      'select_numbers_title': 'Zahlen zum Lernen auswählen',
      'theme_light': 'Hell',
      'theme_dark': 'Dunkel',
      'theme_system': 'System',
      'russian': 'Русский',
      'english': 'English',
      'german': 'Deutsch',
      'min': 'min',
      'practice': 'Praxis',
      'theory': 'Theorie',
      'interesting_facts': 'Interessante Fakten',
      'enter_answer': 'Eingeben\n5×5=?',
      'math_fact_1': 'Das Einmaleins wurde vor über 4000 Jahren im alten Babylon erfunden! 🏛️',
      'math_fact_2': 'Wusstest du, dass die Multiplikation mit 9 ein besonderes Muster ergibt? Die Quersumme ist immer 9! 🔢',
      'math_fact_3': 'In China lernen Kinder das Einmaleins bis 19×19, nicht nur bis 10×10! 🇨🇳',
      'math_fact_4': 'Um schnell mit 11 zu multiplizieren: einfach die Ziffern "spreizen" und benachbarte addieren! ✨',
      'math_fact_5': 'Die Pythagoras-Tabelle ist nach dem griechischen Mathematiker benannt, aber er hat sie nicht erfunden! 🏺',
      'math_fact_6': 'Der schnellste Weg, mit 5 zu multiplizieren: mit 10 multiplizieren und halbieren! ⚡',
      'math_fact_7': 'Die Natur hat viele Beispiele für Multiplikation: Blütenblätter und Pflanzenblätter wachsen oft nach mathematischen Gesetzen! 🌸',
      'math_fact_8': 'Wusstest du, dass 12×12=144 und 21×21=441? Das ist kein Zufall! 🔄',
      'math_fact_9': 'Die arabischen Ziffern, die wir verwenden, kamen über arabische Länder aus Indien zu uns! 🌍',
      'math_fact_10': 'Die Multiplikation mit 10 ist am einfachsten: einfach eine Null anhängen! 🔟',
      
      // Modal dialogs
      'exit_lesson_title': 'Lektion verlassen?',
      'exit_lesson_message': 'Der Fortschritt geht verloren.',
      'cancel': 'Abbrechen',
      'exit': 'Verlassen',
      'duel_title': 'Duell',
      'duel_countdown': 'Das Duell beginnt in',
      'duel_ready': 'Bereit für ein Mathe-Duell?',
      'start': 'Starten',
      'tie': 'Unentschieden!',
      'player_wins': 'Spieler gewinnt',
      'player_1': 'Spieler 1',
      'player_2': 'Spieler 2',
      'play_again': 'Nochmal',
      'reset_progress_title': 'Fortschritt zurücksetzen?',
      'reset_progress_message': 'Alle Lösungen in der Tabelle werden gelöscht.',
      'reset_action': 'Zurücksetzen',
      'hint_button': '💡 Hinweis',
      'done': 'Fertig!',
      'correct': 'Richtig!',
      'incorrect': 'passt nicht :(',
      'pause_title': 'Pause',
      'pause_message': 'Duell pausiert',
      'resume': 'Fortsetzen',
      'exit_duel': 'Duell verlassen',
      // Parent metrics
      'parent_days_streak': 'Tage in Folge',
      'parent_trainings_today': 'Trainings heute',
      'parent_trainings_total': 'Trainings insgesamt',
    },
  };

  /// Get localized string for current language
  /// For use within widget build context  
  static String get(String key, [BuildContext? context]) {
    String currentLanguage = 'ru'; // fallback
    
    if (context != null) {
      try {
        // Try to get language from Provider
        final languageManager = Provider.of<LanguageManager>(context, listen: false);
        currentLanguage = languageManager.currentLanguage;
      } catch (e) {
        // Fallback to singleton if Provider is not available
        currentLanguage = LanguageManager().currentLanguage;
      }
    } else {
      // No context provided, use singleton
      currentLanguage = LanguageManager().currentLanguage;
    }
    
    return _localizedValues[currentLanguage]?[key] ?? 
           _localizedValues['ru']?[key] ?? 
           key;
  }

  /// Get current language code
  static String get currentLanguage => LanguageManager().currentLanguage;

  /// Set language (delegates to LanguageManager)
  static Future<void> setLanguage(String languageCode) async {
    await LanguageManager().setLanguage(languageCode);
  }
} 
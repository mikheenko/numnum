# Widgetbook - Визуальное тестирование UI компонентов

## Запуск Widgetbook

Для запуска widgetbook используйте команду:
```bash
flutter run lib/widgetbook.dart
```

Это откроет приложение с каталогом всех ваших UI компонентов.

## Структура

- `lib/widgetbook.dart` - точка входа для widgetbook
- Компоненты организованы по категориям в дереве навигации
- Каждый компонент может иметь несколько вариантов использования (use cases)

## Добавление нового компонента

### 1. Создайте новый компонент или используйте существующий

Например, для кнопки `PrimaryButton` из `lib/components/buttons/primary_button.dart`:

### 2. Добавьте импорт в widgetbook.dart

```dart
import 'components/buttons/primary_button.dart';
```

### 3. Добавьте компонент в directories

```dart
WidgetbookComponent(
  name: 'PrimaryButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Scaffold(
        body: Center(
          child: PrimaryButton(
            text: 'Нажми меня',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Кнопка нажата!')),
              );
            },
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Disabled',
      builder: (context) => Scaffold(
        body: Center(
          child: PrimaryButton(
            text: 'Неактивная кнопка',
            onPressed: null,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Loading',
      builder: (context) => Scaffold(
        body: Center(
          child: PrimaryButton(
            text: 'Загрузка...',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    ),
  ],
),
```

### 4. Организация по категориям

Создайте новую категорию, если нужно:

```dart
WidgetbookCategory(
  name: 'Input Fields',
  children: [
    WidgetbookComponent(
      name: 'TextInput',
      useCases: [
        // ваши use cases здесь
      ],
    ),
  ],
),
```

## Возможности widgetbook

### Addons (дополнения)

Текущие настроенные addons:

1. **DeviceFrameAddon** - тестирование на разных устройствах
2. **ThemeAddon** - переключение между светлой и темной темами

### Добавление новых addons

Например, для тестирования локализации:

```dart
LocalizationAddon(
  locales: [
    const Locale('en'),
    const Locale('ru'),
  ],
  localizationsDelegates: [
    // ваши delegates
  ],
),
```

## Рекомендации

### Use Cases (варианты использования)

Для каждого компонента создавайте разные use cases:

- **Default** - обычное состояние
- **Disabled** - неактивное состояние  
- **Loading** - состояние загрузки
- **Error** - состояние ошибки
- **With different content** - с разным контентом

### Обертывание в Scaffold

Все use cases оборачивайте в `Scaffold` для корректного отображения:

```dart
builder: (context) => Scaffold(
  body: Center(
    child: YourWidget(),
  ),
),
```

### Интерактивность

Добавляйте интерактивность с помощью SnackBar для демонстрации:

```dart
onPressed: () {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Действие выполнено!')),
  );
},
```

## Структура файла widgetbook.dart

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

// Импорты ваших компонентов
import 'components/buttons/keyboard_button.dart';
// import 'components/buttons/primary_button.dart';
// import 'components/input/text_field.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      directories: [
        WidgetbookCategory(
          name: 'Buttons',
          children: [
            // Ваши компоненты здесь
          ],
        ),
        // Другие категории
      ],
      addons: [
        // Ваши addons здесь
      ],
    );
  }
}
```

## Полезные ссылки

- [Документация Widgetbook](https://docs.widgetbook.io/)
- [Примеры на GitHub](https://github.com/widgetbook/widgetbook) 
# Color System Documentation

## Overview
Новая система цветов основана на токенах, которые обеспечивают семантическое именование и автоматическое переключение между светлой и темной темами.

## Architecture

### Files Structure
```
lib/core/colors/
├── app_color_tokens.dart    # Абстрактный базовый класс с определением всех токенов
├── app_colors_light.dart    # Реализация для светлой темы
├── app_colors_dark.dart     # Реализация для темной темы
├── color_manager.dart       # Менеджер цветов и расширение для BuildContext
└── README.md               # Эта документация
```

### Color Tokens

#### Primary Colors
- `primary` - Основной цвет приложения
- `primaryDark` - Темный вариант основного цвета
- `primaryLight` - Светлый вариант основного цвета

#### Secondary Colors
- `secondary` - Вторичный цвет
- `secondaryDark` - Темный вариант вторичного цвета
- `secondaryLight` - Светлый вариант вторичного цвета

#### Background Colors
- `background` - Основной фон приложения
- `surface` - Цвет поверхностей (карточки, панели)
- `surfaceVariant` - Вариант цвета поверхности

#### Text Colors
- `onBackground` - Текст на основном фоне
- `onSurface` - Текст на поверхностях
- `onSurfaceVariant` - Вторичный текст на поверхностях
- `onPrimary` - Текст на основном цвете
- `onSecondary` - Текст на вторичном цвете

#### State Colors
- `success` / `successLight` - Цвета успеха
- `warning` / `warningLight` - Цвета предупреждения
- `error` / `errorLight` - Цвета ошибки

#### Border Colors
- `border` - Основные границы
- `borderLight` - Светлые границы
- `divider` - Разделители

#### Special Colors
- `tertiary` - Третичный цвет
- `player1` / `player2` - Цвета игроков в дуэльном режиме
- `disabled` - Цвет отключенных элементов

## Usage

### Basic Usage
```dart
import '../core/colors/color_manager.dart';

// В любом виджете с BuildContext:
Container(
  color: context.colors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: context.colors.onPrimary),
  ),
)
```

### Theme-aware Components
```dart
// Цвета автоматически адаптируются к текущей теме
Container(
  decoration: BoxDecoration(
    color: context.colors.surface,
    border: Border.all(color: context.colors.border),
  ),
  child: Text(
    'Content',
    style: TextStyle(color: context.colors.onSurface),
  ),
)
```

## Benefits

1. **Семантическое именование** - `context.colors.primary` вместо `Color(0xFF4CAF50)`
2. **Автоматическое переключение тем** - одинаковые имена токенов, разные значения
3. **Типобезопасность** - абстрактный класс гарантирует полную реализацию
4. **Простота использования** - `context.colors.tokenName`
5. **Централизованное управление** - все цвета в одном месте
6. **Расширяемость** - легко добавлять новые токены

## Migration from AppColors

Старая система:
```dart
AppColors.primary        → context.colors.primary
AppColors.textPrimary    → context.colors.onSurface
AppColors.surface        → context.colors.surface
AppColors.border         → context.colors.border
```

## Adding New Colors

1. Добавить токен в `app_color_tokens.dart`
2. Реализовать в `app_colors_light.dart`
3. Реализовать в `app_colors_dark.dart`
4. Использовать через `context.colors.newToken` 
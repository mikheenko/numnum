import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:provider/provider.dart';

// Import your components
import 'components/buttons/keyboard_button.dart';
import 'components/buttons/primary_button.dart';
import 'components/buttons/secondary_button.dart';
import 'components/common/adaptive_button_row.dart';
import 'components/common/responsive_wrapper.dart';
import 'components/keyboard/custom_keyboard.dart';

// Import providers and theme
import 'core/theme/theme_provider.dart';
import 'core/localization/language_manager.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageManager()),
      ],
      child: Consumer2<ThemeProvider, LanguageManager>(
        builder: (context, themeProvider, languageManager, child) {
          return Widgetbook(
            appBuilder: (context, child) => MaterialApp(
              home: child,
              debugShowCheckedModeBanner: false,
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
            ),
            directories: [
              WidgetbookCategory(
                name: 'Buttons',
                children: [
                  WidgetbookComponent(
                    name: 'KeyboardButton',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Enabled',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: SizedBox(
                              width: 80,
                              height: 60,
                              child: KeyboardButton(
                                enabled: true,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Button tapped!')),
                                  );
                                },
                                child: const Text('7'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Disabled',
                        builder: (context) => const Scaffold(
                          body: Center(
                            child: SizedBox(
                              width: 80,
                              height: 60,
                              child: KeyboardButton(
                                enabled: false,
                                child: Text('7'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'With Icon',
                        builder: (context) => const Scaffold(
                          body: Center(
                            child: SizedBox(
                              width: 80,
                              height: 60,
                              child: KeyboardButton(
                                enabled: true,
                                child: Icon(Icons.backspace_outlined),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'PrimaryButton',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PrimaryButton(
                                text: 'Нажми меня',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Primary button tapped!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Disabled',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PrimaryButton(
                                text: 'Неактивная кнопка',
                                isEnabled: false,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'With Icon',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PrimaryButton(
                                text: 'Играть',
                                icon: Icons.play_arrow,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Play button tapped!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Custom Width',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PrimaryButton(
                                text: 'Узкая кнопка',
                                width: 200,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Narrow button tapped!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'SecondaryButton',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SecondaryButton(
                                text: 'Отмена',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Secondary button tapped!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Disabled',
                        builder: (context) => const Scaffold(
                          body: Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SecondaryButton(
                                text: 'Неактивная кнопка',
                                enabled: false,
                                onPressed: null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'With Icon',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SecondaryButton(
                                text: 'Настройки',
                                icon: Icons.settings,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Settings button tapped!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'Layout Components',
                children: [
                  WidgetbookComponent(
                    name: 'AdaptiveButtonRow',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Two Buttons',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AdaptiveButtonRow(
                                children: [
                                  PrimaryButton(
                                    text: 'Продолжить',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Continue tapped!')),
                                      );
                                    },
                                  ),
                                  SecondaryButton(
                                    text: 'Отмена',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Cancel tapped!')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Three Buttons',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AdaptiveButtonRow(
                                children: [
                                  SecondaryButton(
                                    text: 'Назад',
                                    onPressed: () {},
                                  ),
                                  PrimaryButton(
                                    text: 'Играть',
                                    onPressed: () {},
                                  ),
                                  SecondaryButton(
                                    text: 'Настройки',
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Narrow Screen (Column)',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: SizedBox(
                              width: 200, // Узкий экран
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: AdaptiveButtonRow(
                                  children: [
                                    PrimaryButton(
                                      text: 'Продолжить',
                                      onPressed: () {},
                                    ),
                                    SecondaryButton(
                                      text: 'Отмена',
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  WidgetbookComponent(
                    name: 'ResponsiveWrapper',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'With Content',
                        builder: (context) => ResponsiveWrapper(
                          child: Scaffold(
                            appBar: AppBar(
                              title: const Text('Пример ResponsiveWrapper'),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            body: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Этот контент адаптируется',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'На планшетах контент ограничен по ширине (744px), '
                                    'а на телефонах занимает всю ширину экрана.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WidgetbookCategory(
                name: 'Input Components',
                children: [
                  WidgetbookComponent(
                    name: 'CustomKeyboard',
                    useCases: [
                      WidgetbookUseCase(
                        name: 'Enabled',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Введенное значение: ',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomKeyboard(
                                    enabled: true,
                                    onTap: (value) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Нажата: $value')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      WidgetbookUseCase(
                        name: 'Disabled',
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Клавиатура отключена',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomKeyboard(
                                    enabled: false,
                                    onTap: (value) {
                                      // Не должно срабатывать
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            addons: [
              DeviceFrameAddon(
                devices: [
                  Devices.ios.iPhoneSE,
                  Devices.ios.iPhone12,
                  Devices.android.samsungGalaxyS20,
                ],
              ),
              ThemeAddon(
                themes: [
                  WidgetbookTheme(
                    name: 'Light',
                    data: ThemeData.light(),
                  ),
                  WidgetbookTheme(
                    name: 'Dark',
                    data: ThemeData.dark(),
                  ),
                ],
                themeBuilder: (context, theme, child) => Theme(
                  data: theme,
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 
import 'package:developmiracle/delegates/arvessian_delegate.dart';
import 'package:developmiracle/pages/arvessian_page.dart';
import 'package:developmiracle/pages/home_page.dart';
import 'package:developmiracle/pages/linguea_page.dart';
import 'package:developmiracle/pages/tracker_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  final savedLocale = settingsController.localeMode;

  runApp(
    MyApp(
      settingsController: settingsController,
      locale: savedLocale,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.locale,
  });

  final Locale locale;
  // Определяем основные цвета для тёмной темы
  static const Color backgroundColor = Color(0xFF121212);
  static const Color accentColor = Colors.tealAccent;
  static const Color textColor = Colors.white;

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  final List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('ru'),
    // Locale('av'),
  ];

  @override
  void initState() {
    setState(() {
      _locale = widget.locale;
    });
    super.initState();
  }

  void changeLanguage() {
    // Получаем текущий индекс локали
    int currentIndex =
        supportedLocales.indexOf(widget.settingsController.localeMode);

    int nextIndex = 0;

    if (currentIndex == -1) {
      nextIndex = (currentIndex + 1) % supportedLocales.length;
    }

    nextIndex = (currentIndex + 1) % supportedLocales.length;

    // Обновляем локаль через контроллер
    widget.settingsController.updateLocaleMode(supportedLocales[nextIndex]);

    setState(() {
      _locale = supportedLocales[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miracle Development',
      localizationsDelegates: [
        AppLocalizations.delegate,
        ArvessianDelegate(),
        ArvessianCupertinoDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: MyApp.backgroundColor,
        primaryColor: MyApp.accentColor,
        textTheme: ThemeData.dark()
            .textTheme
            .apply(bodyColor: MyApp.textColor, displayColor: MyApp.textColor),
      ),
      home: HomePage(
        settingsController: widget.settingsController,
        changeLanguage: changeLanguage,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => HomePage(
                  settingsController: widget.settingsController,
                  changeLanguage: changeLanguage,
                );
            break;
          case '/tracker':
            // ignore: prefer_const_constructors
            builder = (BuildContext _) => TrackerPage(
                  settingsController: widget.settingsController,
                  changeLanguage: changeLanguage,
                );
            break;
          case '/linguea':
            builder = (BuildContext _) => LingueaPage(
                  settingsController: widget.settingsController,
                  changeLanguage: changeLanguage,
                );
            break;
          case '/arvessian':
            builder = (BuildContext _) => ArvessianPage(
                  settingsController: widget.settingsController,
                  changeLanguage: changeLanguage,
                );
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

// Редактируемая страница для всех разделов, кроме 'contacts_page'
class DefaultPageContent extends StatefulWidget {
  final String title;

  const DefaultPageContent({super.key, required this.title});

  @override
  State<DefaultPageContent> createState() => _DefaultPageContentState();
}

class _DefaultPageContentState extends State<DefaultPageContent> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: 'Editable content for ${widget.title} page.');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 60,
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          maxLines: null,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white70),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter content here...',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!mobile) const Footer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          '© ${DateTime.now().year} Miracle Development. All rights reserved.',
          style: const TextStyle(color: Colors.white60),
        ),
      ),
    );
  }
}

// Проверка ширины экрана для адаптивности
bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 700; //600;
}

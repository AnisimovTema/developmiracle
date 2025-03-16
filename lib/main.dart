import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Определяем основные цвета для тёмной темы
  static const Color backgroundColor = Color(0xFF121212);
  static const Color accentColor = Colors.tealAccent;
  static const Color textColor = Colors.white;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miracle Development',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: accentColor,
        textTheme: ThemeData.dark()
            .textTheme
            .apply(bodyColor: textColor, displayColor: textColor),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Список разделов с заголовками, идентификаторами контента, иконками и флагом disabled
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'About us',
      'contentId': 'about_us_page',
      'icon': Icons.edit, // Иконка пера / редактирования
      'disabled': true,
    },
    {
      'title': 'Projects',
      'contentId': 'projects_page',
      'icon': Icons.work, // Иконка кейса / работы
      'disabled': true,
    },
    {
      'title': 'Info',
      'contentId': 'info_page',
      'icon': Icons.info_outline, // Иконка "i"
      'disabled': true,
    },
    {
      'title': 'Contacts',
      'contentId': 'contacts_page',
      'icon': Icons.alternate_email, // Иконка @
      'disabled': false,
    },
  ];

  // Индекс текущей отображаемой страницы (раздела), вычисляется в initState,
  // при этом выбирается первый раздел, для которого disabled == false.
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex =
        sections.indexWhere((section) => !(section['disabled'] ?? false));
    if (_currentIndex == -1) {
      _currentIndex = 0;
    }
  }

  // Функция возвращает виджет страницы, основанный на contentId раздела.
  Widget buildPageContent(Map<String, dynamic> section) {
    String contentId = section['contentId'];
    switch (contentId) {
      case 'contacts_page':
        return const ContentPage();
      default:
        return DefaultPageContent(title: section['title']);
    }
  }

  // Построение навигационных элементов для Drawer и AppBar
  List<Widget> buildNavItems(bool mobile) {
    return sections.asMap().entries.map((entry) {
      int idx = entry.key;
      String label = entry.value['title'];
      IconData iconData = entry.value['icon'];
      bool disabled = entry.value['disabled'] ?? false;
      return mobile
          ? ListTile(
              leading:
                  Icon(iconData, color: disabled ? Colors.grey : Colors.white),
              title: Text(
                label,
                style: TextStyle(color: disabled ? Colors.grey : Colors.white),
              ),
              onTap: disabled
                  ? null
                  : () {
                      setState(() {
                        _currentIndex = idx;
                      });
                      Navigator.pop(context); // закрыть Drawer
                    },
            )
          : TextButton.icon(
              onPressed: disabled
                  ? null
                  : () {
                      setState(() {
                        _currentIndex = idx;
                      });
                    },
              icon: Icon(
                iconData,
                color: _currentIndex == idx
                    ? MyApp.accentColor
                    : (disabled ? Colors.grey : Colors.white),
              ),
              label: Text(
                label,
                style: TextStyle(
                  color: _currentIndex == idx
                      ? MyApp.accentColor
                      : (disabled ? Colors.grey : Colors.white),
                ),
              ),
            );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Miracle Development'),
        backgroundColor: MyApp.backgroundColor,
        elevation: 0,
        actions: mobile ? null : buildNavItems(false),
      ),
      drawer: mobile
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: MyApp.backgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        'Navigation',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  ...buildNavItems(true),
                ],
              ),
            )
          : null,
      // Используем IndexedStack для переключения между страницами
      body: IndexedStack(
        index: _currentIndex,
        children: sections.map((section) {
          return buildPageContent(section);
        }).toList(),
      ),
      // Нижняя навигационная панель для мобильных устройств
      bottomNavigationBar: mobile
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed, // всегда показывать подписи
              currentIndex: _currentIndex,
              backgroundColor: MyApp.backgroundColor,
              selectedItemColor: MyApp.accentColor,
              unselectedItemColor: Colors.white,
              onTap: (index) {
                bool disabled = sections[index]['disabled'] ?? false;
                if (!disabled) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              items: sections.map((section) {
                bool disabled = section['disabled'] ?? false;
                return BottomNavigationBarItem(
                  icon: Icon(
                    section['icon'],
                    color: disabled ? Colors.grey : null,
                  ),
                  label: section['title'],
                );
              }).toList(),
            )
          : null,
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
                        vertical: 60, horizontal: 20),
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

// Виджет для страницы 'contacts_page'
class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);

    // Функция для открытия ссылки
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Можно добавить обработку ошибки
        throw 'Could not launch $url';
      }
    }

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
                        vertical: 60, horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contacts',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white70),
                            children: [
                              const TextSpan(
                                  text: 'You can write to us via telegram '),
                              TextSpan(
                                text: 'https://t.me/creativicy',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Открытие ссылки на telegram
                                    _launchUrl('https://t.me/creativicy');
                                  },
                              ),
                              const TextSpan(
                                  text: ' or just send an email to '),
                              TextSpan(
                                text: 'support@developmiracle.com',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Открытие почтовой ссылки
                                    _launchUrl(
                                        'mailto:support@developmiracle.com');
                                  },
                              ),
                            ],
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
      child: const Center(
        child: Text(
          '© 2025 Мой сайт. Все права защищены.',
          style: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }
}

// Проверка ширины экрана для адаптивности
bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

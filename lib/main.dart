import 'package:flutter/material.dart';

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
      title: 'Мой сайт',
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
  // Индекс текущей отображаемой страницы (раздела)
  int _currentIndex = 0;

  // Список разделов с заголовками, текстовыми подсказками и иконками
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Обо мне',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Здесь можно разместить информацию о себе, своем опыте и интересах.',
      'icon': Icons.edit, // Иконка пера / редактирования
    },
    {
      'title': 'Мои проекты',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. В этом разделе можно описать выполненные проекты, рассказать о технологиях и подходах, используемых в работе.',
      'icon': Icons.work, // Иконка кейса / работы
    },
    {
      'title': 'Доп. информация',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Здесь можно добавить дополнительные сведения, такие как сертификаты, публикации или рекомендации.',
      'icon': Icons.info_outline, // Иконка "i"
    },
    {
      'title': 'Контакты',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. В этом разделе можно указать контактные данные, email, ссылки на соцсети и другие способы связи.',
      'icon': Icons.alternate_email, // Иконка @
    },
  ];

  // Построение навигационных элементов для Drawer и AppBar
  List<Widget> buildNavItems(bool mobile) {
    return sections.asMap().entries.map((entry) {
      int idx = entry.key;
      String label = entry.value['title'];
      IconData iconData = entry.value['icon'];
      return mobile
          ? ListTile(
              leading: Icon(iconData, color: Colors.white),
              title: Text(label),
              onTap: () {
                setState(() {
                  _currentIndex = idx;
                });
                Navigator.pop(context); // закрыть Drawer
              },
            )
          : TextButton.icon(
              onPressed: () {
                setState(() {
                  _currentIndex = idx;
                });
              },
              icon: Icon(iconData,
                  color:
                      _currentIndex == idx ? MyApp.accentColor : Colors.white),
              label: Text(
                label,
                style: TextStyle(
                  color:
                      _currentIndex == idx ? MyApp.accentColor : Colors.white,
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
        title: const Text('Мой сайт'),
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
                        'Навигация',
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
          return PageContent(
            title: section['title'],
            content: section['content'],
          );
        }).toList(),
      ),
      // Нижняя навигационная панель для мобильных устройств
      bottomNavigationBar: mobile
          ? BottomNavigationBar(
              type:
                  BottomNavigationBarType.shifting, // всегда показывать подписи
              currentIndex: _currentIndex,
              backgroundColor: MyApp.backgroundColor,
              selectedItemColor: MyApp.accentColor,
              unselectedItemColor: Colors.white,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: sections.map((section) {
                return BottomNavigationBarItem(
                  icon: Icon(section['icon']),
                  label: section['title'],
                );
              }).toList(),
            )
          : null,
    );
  }
}

// Обновлённый виджет для содержимого страницы с разделом и постоянным футером
class PageContent extends StatelessWidget {
  final String title;
  final String content;

  const PageContent({super.key, required this.title, required this.content});

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
                  Section(title: title, content: content),
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

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
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

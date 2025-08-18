import 'package:developmiracle/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:developmiracle/main.dart';
import 'package:developmiracle/pages/contacts_page.dart';
import 'package:developmiracle/pages/projects_page.dart';
import 'package:developmiracle/src/settings/settings_controller.dart';
import 'package:developmiracle/widgets/miracle_appbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.settingsController,
    required this.changeLanguage,
  });

  final SettingsController settingsController;

  final VoidCallback changeLanguage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Список разделов с заголовками, идентификаторами контента, иконками и флагом disabled
  final List<Map<String, dynamic>> sections = [
    {
      'contentId': 'about_us_page',
      'icon': Icons.edit, // Иконка пера / редактирования
      'disabled': true,
    },
    {
      'contentId': 'projects_page',
      'icon': Icons.work, // Иконка кейса / работы
      'disabled': false,
    },
    // {
    //   'title': 'Info',
    //   'contentId': 'info_page',
    //   'icon': Icons.info_outline, // Иконка "i"
    //   'disabled': true,
    // },
    {
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

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final messages = AppLocalizations.of(context)!;

    // Функция возвращает label, основанный на contentId раздела.
    String _getLabel(Map<String, dynamic> section) {
      final contentId = section['contentId'];
      switch (contentId) {
        case 'contacts_page':
          return messages.contacts;
        case 'projects_page':
          return messages.projects;
        case 'about_us_page':
          return messages.aboutUs;
        default:
          return ''; // или messages.defaultTitle, если добавить в ARB
      }
    }

    // Функция возвращает виджет страницы, основанный на contentId раздела.
    Widget buildPageContent(Map<String, dynamic> section) {
      String contentId = section['contentId'];
      switch (contentId) {
        case 'contacts_page':
          return const ContactsPage();
        case 'projects_page':
          return const ProjectsPage();
        default:
          return DefaultPageContent(
            title: _getLabel(section),
          );
      }
    }

    // Построение навигационных элементов для Drawer и AppBar
    List<Widget> buildNavItems(bool mobile) {
      return sections.asMap().entries.map((entry) {
        int idx = entry.key;
        final section = entry.value;
        String label = _getLabel(section);
        IconData iconData = entry.value['icon'];
        bool disabled = entry.value['disabled'] ?? false;
        return mobile
            ? ListTile(
                leading: Icon(
                  iconData,
                  color: disabled ? Colors.grey : Colors.white,
                ),
                title: Text(
                  label,
                  style: TextStyle(
                    color: disabled ? Colors.grey : Colors.white,
                  ),
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
            : Padding(
                padding: EdgeInsets.only(
                  right: idx == (sections.length - 1) ? 8.0 : 0.0,
                ),
                child: TextButton.icon(
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
                        ? MiracleDevelopmentApp.accentColor
                        : (disabled ? Colors.grey : Colors.white),
                  ),
                  label: Text(
                    label,
                    style: TextStyle(
                      color: _currentIndex == idx
                          ? MiracleDevelopmentApp.accentColor
                          : (disabled ? Colors.grey : Colors.white),
                    ),
                  ),
                ),
              );
      }).toList();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(80, 80),
        child: MiracleAppbar(
          settingsController: widget.settingsController,
          changeLanguage: widget.changeLanguage,
          navItems: buildNavItems(false),
        ),
      ),
      drawer: mobile
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: MiracleDevelopmentApp.backgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        messages.navigation,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
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
              backgroundColor: MiracleDevelopmentApp.backgroundColor,
              selectedItemColor: MiracleDevelopmentApp.accentColor,
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
                  label: _getLabel(section),
                );
              }).toList(),
            )
          : null,
    );
  }
}

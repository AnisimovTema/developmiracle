import 'package:developmiracle/main.dart';
import 'package:developmiracle/models/project.dart';
import 'package:developmiracle/src/settings/settings_controller.dart';
import 'package:developmiracle/widgets/miracle_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WavePage extends StatelessWidget {
  const WavePage({
    super.key,
    required this.settingsController,
    required this.changeLanguage,
    this.project,
  });

  final SettingsController settingsController;
  final VoidCallback changeLanguage;
  final Project? project;

  // Пример данных — замените на реальные
  static final Project sampleProject = Project(
    title: 'Wave — P2P Chat & Calls',
    subtitle: 'Общение без посредников',
    description:
        'Wave — приложение для p2p-соединений. Оно показывает реальное использование WebRTC/peer-to-peer технологий и надежную работу на разных платформах.\n\nВключены: сессии и отображение статуса соединения, чат, звонки, отключение и повторное подключение к голосовому каналу. Интерфейс анимирован.',
    screenshots: [
      'https://picsum.photos/800/600?image=1067',
      'https://picsum.photos/800/600?image=1068',
      'https://picsum.photos/800/600?image=1069',
    ],
    techUsage: {
      'Flutter': 'UI, кросс-платформенный движок',
      'WebRTC': 'P2P медиа + data channels',
      'Firebase': 'Аутентификация и signalling (опционально)',
      'Dart Streams': 'Реактивное обновление состояния',
    },
  );

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final Project p = project ?? sampleProject;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: MiracleAppbar(
          settingsController: settingsController,
          changeLanguage: changeLanguage,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Desktop / wide layout
            if (!mobile && constraints.maxWidth >= 700) {
              return _buildDesktop(context, p, constraints);
            }
            // Mobile / narrow layout
            return _buildMobile(context, p);
          },
        ),
      ),
      // Футер оставляем как раньше: показываем только на десктопе (как в вашем образце)
      bottomNavigationBar: (!isMobile(context)) ? const Footer() : null,
    );
  }

  // -------------------- Desktop layout --------------------
  Widget _buildDesktop(
      BuildContext context, Project p, BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Слева — карусель скриншотов
            Expanded(
              flex: 5,
              child: _Card(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: _ScreenshotCarousel(screenshots: p.screenshots),
                ),
              ),
            ),

            const SizedBox(width: 24),

            // Справа — название, описание, стек технологий
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок и подзаголовок
                  Text(
                    p.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.subtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 16),

                  // Карточка с описанием (чистая, просторная — Apple-like hierarchy)
                  _Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        p.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(height: 1.4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Технологии и использование
                  Text('Стек технологий',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _TechList(techUsage: p.techUsage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Mobile layout --------------------
  Widget _buildMobile(BuildContext context, Project p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Text(
            p.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(p.subtitle, style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 12),

          // Скриншоты
          SizedBox(
            height: 240,
            child: _ScreenshotCarousel(screenshots: p.screenshots),
          ),

          const SizedBox(height: 12),

          // Описание
          _Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(p.description,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),

          const SizedBox(height: 12),

          // Технологии и использование
          Text('Стек технологий',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _TechList(techUsage: p.techUsage),
        ],
      ),
    );
  }
}

// -------------------- Вспомогательные виджеты --------------------

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    // Нейтральная карта с мягкими закруглениями и лёгкой тенью — соответствует Apple UI/UX принципам
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ScreenshotCarousel extends StatefulWidget {
  final List<String> screenshots;
  const _ScreenshotCarousel({required this.screenshots});

  @override
  State<_ScreenshotCarousel> createState() => _ScreenshotCarouselState();
}

class _ScreenshotCarouselState extends State<_ScreenshotCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final newIndex = _controller.page?.round() ?? 0;
      if (newIndex != _index) setState(() => _index = newIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.screenshots.length,
          itemBuilder: (context, i) {
            final src = widget.screenshots[i];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                src,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(child: CupertinoActivityIndicator());
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child:
                      const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            );
          },
        ),

        // Индикаторы снизу по центру
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.screenshots.length,
              (i) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _controller.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == i ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _index == i
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TechList extends StatelessWidget {
  final Map<String, String> techUsage;
  const _TechList({required this.techUsage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: techUsage.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            collapsedTextColor: Theme.of(context).textTheme.bodyLarge?.color,
            title: Row(
              children: [
                // Короткая метка технологии
                Chip(label: Text(e.key)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(e.value,
                        maxLines: 2, overflow: TextOverflow.ellipsis)),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 4, bottom: 8),
                child: Text(
                  // Пояснительное поле — по умолчанию повторим usage, но вы можете расширять
                  'Роль: ${e.value}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// -------------------- Footer placeholder (оставлено из вашего примера) --------------------
class Footer extends StatelessWidget {
  const Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      child: Text('© ${DateTime.now().year} DevelopMiracle'),
    );
  }
}

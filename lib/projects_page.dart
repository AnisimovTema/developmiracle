import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equatable/equatable.dart';
import 'package:developmiracle/main.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final projects = [
      const _ProjectVM(
          name: 'Activity Self-Tracker',
          imageUrl: 'https://example.com/activity-tracker',
          route: 'tracker',
          description:
              'Collect statistics on your activity every 30 minutes, monitor productivity cycles and increase it'),
      const _ProjectVM(
          name: 'Linguea',
          imageUrl: 'https://example.com/linguea',
          route: 'linguea',
          description:
              'Create your own dictionary - any words, languages and terms. Comfortable workouts using a proven technique. Practical words import/export'),
      const _ProjectVM(
          name: 'Arvessian',
          imageUrl: 'https://example.com/arvessian',
          route: 'arvessian',
          description: 'A new language that anyone can understand'),
    ];

    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 60,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Projects',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: projects.map((project) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/${project.route}',
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 600,
                                      minWidth: 600,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.tealAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            // decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        Text(
                                          project.description,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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

class _ProjectVM extends Equatable {
  final String name;
  final String imageUrl;
  final String route;
  final String description;

  const _ProjectVM({
    required this.name,
    required this.imageUrl,
    required this.route,
    required this.description,
  });

  @override
  List<Object> get props => [
        name,
        imageUrl,
        route,
        description,
      ];
}

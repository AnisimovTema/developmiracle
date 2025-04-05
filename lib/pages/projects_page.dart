import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equatable/equatable.dart';
import 'package:developmiracle/main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final messages = AppLocalizations.of(context)!;
    final projects = [
      _ProjectVM(
        name: messages.activitySelfTracker_title,
        imageUrl: 'https://example.com/activity-tracker',
        route: 'tracker',
        description: messages.activitySelfTracker_description,
      ),
      _ProjectVM(
        name: messages.linguea_title,
        imageUrl: 'https://example.com/linguea',
        route: 'linguea',
        description: messages.linguea_description,
      ),
      _ProjectVM(
          name: messages.arvessian_title,
          imageUrl: 'https://example.com/arvessian',
          route: 'arvessian',
          description: messages.arvessian_description),
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
                        Text(
                          messages.projects,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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

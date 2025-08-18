import 'package:developmiracle/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:developmiracle/main.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final messages = AppLocalizations.of(context)!;
    final double containerWidth =
        mobile ? MediaQuery.of(context).size.width * 0.9 : 600;

    final itProjects = [
      _Project(
        name: messages.activitySelfTracker_title,
        description: messages.activitySelfTracker_description,
        route: 'tracker',
        externalUrl: null,
      ),
      _Project(
        name: messages.linguea_title,
        description: messages.linguea_description,
        route: 'linguea',
        externalUrl: 'https://linguea.app',
      ),
      _Project(
        name: messages.wave_title,
        description: messages.wave_description,
        route: 'wave',
        externalUrl: null,
      ),
    ];

    final communityProjects = [
      _Project(
        name: messages.arvessian_title,
        description: messages.arvessian_description,
        route: 'arvessian',
        externalUrl: null,
      ),
      _Project(
        name: messages.brotherhood_title,
        description: messages.brotherhood_description,
        route: 'brotherhood',
        externalUrl: 'https://brotherhood.example.com',
      ),
    ];

    Future<void> _launchUrl(String url) async {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    }

    void _handleProjectTap(_Project project) {
      // if (project.externalUrl != null) {
      //   _launchUrl(project.externalUrl!);
      // } else
      if (project.route != null) {
        Navigator.pushNamed(context, '/${project.route}');
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                    minWidth: double.infinity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: mobile ? 20 : 60,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          messages.projects,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...itProjects.map((project) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _handleProjectTap(project),
                                child: Container(
                                  width: containerWidth,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.tealAccent),
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
                                        ),
                                      ),
                                      const SizedBox(height: 8),
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
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 580),
                            child: const Divider(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...communityProjects.map((project) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _handleProjectTap(project),
                                child: Container(
                                  width: containerWidth,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.tealAccent),
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
                                        ),
                                      ),
                                      const SizedBox(height: 8),
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
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!mobile)
              const Footer(), // Футер всегда после прокручиваемого контента
          ],
        );
      },
    );
  }
}

class _Project {
  final String name;
  final String description;
  final String? route;
  final String? externalUrl;

  const _Project({
    required this.name,
    required this.description,
    this.route,
    this.externalUrl,
  });
}

import 'package:developmiracle/main.dart';
import 'package:developmiracle/src/settings/settings_controller.dart';
import 'package:developmiracle/widgets/miracle_appbar.dart';
import 'package:developmiracle/widgets/placeholder_text.dart';
import 'package:flutter/material.dart';

class ArvessianPage extends StatelessWidget {
  const ArvessianPage({
    super.key,
    required this.settingsController,
    required this.changeLanguage,
  });

  final SettingsController settingsController;
  final VoidCallback changeLanguage;

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(80, 80),
        child: MiracleAppbar(
          settingsController: settingsController,
          changeLanguage: changeLanguage,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const PlaceholderText(pageTitle: 'Arvessian'),
                    const Spacer(),
                    if (!mobile) const Footer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

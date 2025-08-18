import 'package:developmiracle/main.dart';
import 'package:developmiracle/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class MiracleAppbar extends StatelessWidget {
  const MiracleAppbar({
    super.key,
    required this.settingsController,
    required this.changeLanguage,
    this.navItems,
  });

  final SettingsController settingsController;

  final VoidCallback changeLanguage;

  final List<Widget>? navItems;

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final Locale locale = settingsController.localeMode;
    return AppBar(
      title: Row(
        children: [
          const Text('Miracle Development'),
          const SizedBox(width: 8),
          TextButton.icon(
            icon: const Icon(
              Icons.language,
              color: MiracleDevelopmentApp.accentColor,
              size: 20,
            ),
            onPressed: changeLanguage,
            label: Text(
              locale.languageCode,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: MiracleDevelopmentApp.backgroundColor,
      elevation: 0,
      actions: mobile ? null : navItems,
      forceMaterialTransparency: true,
    );
  }
}

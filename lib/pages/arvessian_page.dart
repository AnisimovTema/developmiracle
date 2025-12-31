import 'package:developmiracle/main.dart';
import 'package:developmiracle/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:rinka/main.dart' as rinka;

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
    rinka.main();
    return SizedBox();
  }
}

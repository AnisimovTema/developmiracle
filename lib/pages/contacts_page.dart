import 'package:developmiracle/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:developmiracle/main.dart';
import 'package:developmiracle/widgets/placeholder_text.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final messages = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  PlaceholderText(pageTitle: messages.contacts),
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

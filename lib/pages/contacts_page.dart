import 'package:developmiracle/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);
    final messages = AppLocalizations.of(context)!;

    // Функция для открытия ссылки
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Можно добавить обработку ошибки
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 60,
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messages.contacts,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white70),
                            children: [
                              TextSpan(
                                text: messages.contacts_start,
                              ),
                              TextSpan(
                                text: 'https://t.me/creativicy',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Открытие ссылки на telegram
                                    _launchUrl('https://t.me/creativicy');
                                  },
                              ),
                              TextSpan(
                                text: messages.contacts_end,
                              ),
                              TextSpan(
                                text: 'support@developmiracle.com',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Открытие почтовой ссылки
                                    _launchUrl(
                                        'mailto:support@developmiracle.com');
                                  },
                              ),
                            ],
                          ),
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

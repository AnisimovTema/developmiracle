import 'package:developmiracle/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class PlaceholderText extends StatelessWidget {
  const PlaceholderText({super.key, required this.pageTitle});

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
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

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.white70),
              children: [
                TextSpan(text: messages.placeholder_text_part_1),
                TextSpan(
                  text: 'https://t.me/creativicy',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Открытие ссылки на telegram
                      _launchUrl('https://t.me/creativicy');
                    },
                ),
                TextSpan(text: messages.placeholder_text_part_2),
                TextSpan(
                  text: 'support@developmiracle.com',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Открытие почтовой ссылки
                      _launchUrl('mailto:support@developmiracle.com');
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

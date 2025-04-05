import 'package:developmiracle/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LingueaPage extends StatelessWidget {
  const LingueaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = isMobile(context);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arvessian'),
        backgroundColor: MyApp.backgroundColor,
        elevation: 0,
        // actions: mobile ? null : buildNavItems(false),
        forceMaterialTransparency: true,
      ),
      body: LayoutBuilder(
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
                          const Text(
                            'Linguea',
                            style: TextStyle(
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
                                const TextSpan(
                                  text:
                                      'Hey, nothing here. This page may still be in development.',
                                ),
                                // TextSpan(
                                //   text: 'https://t.me/creativicy',
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.tealAccent),
                                //   recognizer: TapGestureRecognizer()
                                //     ..onTap = () {
                                //       // Открытие ссылки на telegram
                                //       _launchUrl('https://t.me/creativicy');
                                //     },
                                // ),
                                // const TextSpan(
                                //     text: ' or just send an email to '),
                                // TextSpan(
                                //   text: 'support@developmiracle.com',
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.tealAccent),
                                //   recognizer: TapGestureRecognizer()
                                //     ..onTap = () {
                                //       // Открытие почтовой ссылки
                                //       _launchUrl(
                                //           'mailto:support@developmiracle.com');
                                //     },
                                // ),
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
      ),
    );
  }
}

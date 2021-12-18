import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSection extends StatelessWidget {
  final String? text;
  final String? secondText;

  const InfoSection({this.text, this.secondText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            //left: 12,
            //right: 12,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            children: [
              Html(
                data: text,
                style: htmlStyles,
                onLinkTap: (url, context, attributes, element) async {
                  if (url != null) {
                    if (await canLaunch(url)) {
                      try {
                        await launch(url);

                        return;
                        // ignore: avoid_catches_without_on_clauses
                      } catch (e) {
                        debugPrint('url: $url - не может быть открыт');
                      }
                    }
                  }

                  debugPrint('url: $url - не может быть открыт');
                },
              ),
              if (secondText != null)
                const SizedBox(
                  height: 40,
                ),
              if (secondText != null)
                Html(
                  data: secondText,
                  style: htmlStyles,
                  onLinkTap: (url, context, attributes, element) async {
                  if (url != null) {
                    if (await canLaunch(url)) {
                      try {
                        await launch(url);

                        return;
                        // ignore: avoid_catches_without_on_clauses
                      } catch (e) {
                        debugPrint('url: $url - не может быть открыт');
                      }
                    }
                  }

                  debugPrint('url: $url - не может быть открыт');
                },
                ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

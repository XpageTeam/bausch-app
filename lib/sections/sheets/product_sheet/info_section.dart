import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InfoSection extends StatelessWidget {
  final String text;
  final String secondText;

  const InfoSection({
    required this.text,
    required this.secondText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isNotEmpty) {
      final clearedText = text
          .replaceAll('<p>', '')
          .replaceAll('</p>', '')
          .replaceAll('&nbsp;', '');
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
          top: 20,
          bottom: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Html(
              data: clearedText,
              style: htmlStyles,
              customRender: htmlCustomRender,
              onLinkTap: (url, context, attributes, element) async {
                if (url != null) {
                  if (await canLaunchUrlString(url)) {
                    try {
                      await launchUrlString(url, mode: LaunchMode.inAppWebView);

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
            if (secondText.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Html(
                  data: secondText,
                  style: htmlStyles,
                  customRender: htmlCustomRender,
                  onLinkTap: (url, context, attributes, element) async {
                    if (url != null) {
                      if (await canLaunchUrlString(url)) {
                        try {
                          await launchUrlString(
                            url,
                            mode: LaunchMode.inAppWebView,
                          );
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
              ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}

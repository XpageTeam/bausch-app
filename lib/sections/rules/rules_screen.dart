import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesScreen extends StatelessWidget {
  final ScrollController controller;
  final String data;

  const RulesScreen({
    required this.controller,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Html(
                  data: data,
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
                  customRender: htmlCustomRender,
                  style: htmlStyles,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

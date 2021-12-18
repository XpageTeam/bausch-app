import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesScreen extends StatefulWidget {
  final ScrollController controller;

  const RulesScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final RulesCubit rulesCubit = RulesCubit();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              controller: widget.controller,
              // TODO(Nikita): вывести данные
              child: Html(
                data: 'state.data',
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
                style: htmlStyles,
                customRender: {
                  'table': (context, child) {
                    return SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: (context.tree as TableLayoutElement)
                          .toWidget(context),
                      scrollDirection: Axis.horizontal,
                    );
                  },
                },
              ),
            ),
            CustomSliverAppbar.toPop(
              icon: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

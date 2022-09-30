import 'package:bausch/sections/rules/rules_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RulesScreen extends CoreMwwmWidget<RulesWM> {
  final ScrollController controller;
  final String data;

  RulesScreen({
    required this.controller,
    required this.data,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return RulesWM(context: context);
          },
        );

  @override
  WidgetState<CoreMwwmWidget<RulesWM>, RulesWM> createWidgetState() =>
      _RulesScreenState();
}

class _RulesScreenState extends WidgetState<RulesScreen, RulesWM> {
  Color iconColor = Colors.white;
  bool colorChanged = false;

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60 && !colorChanged) {
          colorChanged = !colorChanged;
          wm.colorState.accept(AppTheme.turquoiseBlue);
        }
        if (offset < 59 && colorChanged) {
          colorChanged = !colorChanged;
          wm.colorState.accept(Colors.white);
        }
      },
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            icon: Container(),
            iconColor: color,
          );
        },
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
                  data: widget.data,
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

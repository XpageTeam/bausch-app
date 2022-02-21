import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/wm/bottom_sheet_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class HtmlScreen extends CoreMwwmWidget<BottomSheetWM> {
  final ScrollController controller;
  final Offer offer;

  HtmlScreen({
    required this.controller,
    required this.offer,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return BottomSheetWM(color: Colors.white);
          },
        );

  @override
  WidgetState<CoreMwwmWidget<BottomSheetWM>, BottomSheetWM>
      createWidgetState() => _HtmlScreenState();
}

class _HtmlScreenState extends WidgetState<HtmlScreen, BottomSheetWM> {
  Color iconColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(Colors.white);
        }
      },
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            padding: const EdgeInsets.all(18),
            icon: Container(),
            iconColor: color,
          );
        },
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            62,
            StaticData.sidePadding,
            0.0,
          ),
          sliver: SliverToBoxAdapter(
            child: Html(
              data: widget.offer.html,
              style: htmlStyles,
              customRender: htmlCustomRender,
            ),
          ),
        ),
      ],
    );
  }
}

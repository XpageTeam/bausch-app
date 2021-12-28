import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:bausch/widgets/appbar/appbar_for_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlScreen extends StatelessWidget {
  final ScrollController controller;
  final Offer offer;

  const HtmlScreen({
    required this.controller,
    required this.offer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(),
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
              data: '<html><h2>Ошибка</h2></html>',
              style: htmlStyles,
              customRender: htmlCustomRender,
            ),
          ),
        ),
      ],
    );
  }
}

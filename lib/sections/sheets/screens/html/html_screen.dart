import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlScreen extends StatefulWidget {
  final ScrollController controller;
  final Offer offer;

  const HtmlScreen({
    required this.controller,
    required this.offer,
    Key? key,
  }) : super(key: key);

  @override
  State<HtmlScreen> createState() => _HtmlScreenState();
}

class _HtmlScreenState extends State<HtmlScreen> {
  Color iconColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          setState(() {
            iconColor = AppTheme.turquoiseBlue;
          });
        } else {
          setState(() {
            iconColor = Colors.white;
          });
        }
      },
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(),
        iconColor: iconColor,
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

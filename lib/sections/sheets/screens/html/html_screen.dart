import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/theme/app_theme.dart';
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        resizeToAvoidBottomInset: true,
        appBar: const AppBarForBottomSheet(),
        body: CustomScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 40.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Stack(
                        children: [
                          // WhiteContainerWithRoundedCorners(
                          //   child: Padding(
                          //     padding: const EdgeInsets.fromLTRB(
                          //       40,
                          //       45,
                          //       40,
                          //       20,
                          //     ),
                          //     child: AutoSizeText(
                          //       offer.title,
                          //       maxLines: 2,
                          //       textAlign: TextAlign.center,
                          //       style: AppStyles.h1,
                          //     ),
                          //   ),
                          //   color: AppTheme.sulu,
                          // ),
                          CustomSliverAppbar(
                            icon: Container(),
                            key: key,
                          ),
                        ],
                      ),
                    ),
                    Html(
                      data: offer.html ?? '<html>Error</html>',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

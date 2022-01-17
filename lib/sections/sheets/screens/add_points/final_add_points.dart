import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/material.dart';

//* Add_points
//* final

class FinalAddPointsArguments {
  final String points;

  FinalAddPointsArguments({required this.points});
}

class FinalAddPointsScreen extends StatelessWidget
    implements FinalAddPointsArguments {
  final ScrollController controller;
  @override
  final String points;

  const FinalAddPointsScreen({
    required this.controller,
    required this.points,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.only(
          top: 14,
          right: StaticData.sidePadding,
        ),
        icon: Container(
          height: 1,
        ),
      ),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 165,
                    backgroundColor: Colors.white,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            color: Colors.white.withOpacity(0.16),
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            '+$points',
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppTheme.mineShaft,
                              fontWeight: FontWeight.w500,
                              fontSize: 85,
                              height: 80 / 85,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          const PointWidget(
                            radius: 18,
                            textStyle: TextStyle(
                              color: AppTheme.mineShaft,
                              fontWeight: FontWeight.w500,
                              fontSize: 27,
                              height: 25 / 27,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AutoSizeText(
                        'Спасибо, что вы с нами!',
                        maxLines: 2,
                        style: AppStyles.h1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      bottomNavBar: CustomFloatingActionButton(
        text: 'Потратить баллы',
        topPadding: 12,
        onPressed: () {
          if (spendPointsPositionKey.currentContext != null) {
            Scrollable.ensureVisible(spendPointsPositionKey.currentContext!);
          }

          Keys.mainContentNav.currentState!.pop();
        },
      ),
    );
  }
}

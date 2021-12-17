import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//* Add_points
//* final
class FinalAddPointsScreen extends StatelessWidget {
  final ScrollController controller;
  const FinalAddPointsScreen({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.sulu,
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              CustomSliverAppbar.toPop(
                icon: Container(),
                key: key,
                rightKey: Keys.simpleBottomSheetNav,
              ),
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
                        children: const [
                          AutoSizeText(
                            '+500',
                            maxLines: 1,
                            style: TextStyle(
                              color: AppTheme.mineShaft,
                              fontWeight: FontWeight.w500,
                              fontSize: 85,
                              height: 80 / 85,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          PointWidget(
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
                        maxLines: 1,
                        style: AppStyles.h1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomFloatingActionButton(
          text: 'Потратить баллы',
          topPadding: 12,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

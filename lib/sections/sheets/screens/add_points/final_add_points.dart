import 'dart:ui';

import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                rightKey: Keys.bottomSheetNav,
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
                    children: const [
                      Text(
                        '+500',
                        style: TextStyle(
                          color: AppTheme.mineShaft,
                          fontWeight: FontWeight.w500,
                          fontSize: 85,
                          height: 80 / 85,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Спасибо, что вы с нами!',
                        style: AppStyles.h1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          text: 'Потратить баллы',
          topPadding: 12,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

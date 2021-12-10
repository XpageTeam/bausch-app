import 'package:bausch/sections/sheets/screens/program/program_screen.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class OfferWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? topRightIcon;

  final VoidCallback onClose;

  const OfferWidget({
    this.title,
    this.subtitle,
    this.topRightIcon,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            //showSheetWithoutItems(context, Models.sheets[1]);
            showFlexibleBottomSheet<void>(
              useRootNavigator: true,
              minHeight: 0,
              initHeight: 0.9, //calculatePercentage(model.models!.length),
              maxHeight: 0.95,
              anchors: [0, 0.6, 0.95],

              context: context,
              builder: (_, c, d) => ProgramScreen(
                controller: c,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.sulu,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: StaticData.sidePadding,
                left: StaticData.sidePadding,
                bottom: 30,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title ??
                              'Получите двойные баллы за подбор контактных линз',
                          style: AppStyles.h1,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          subtitle ??
                              'Успейте зарегистрировать код с упаковки в течение 14 дней и мы начислим вам баллы',
                          style: AppStyles.p1,
                        ),
                      ),
                      const SizedBox(
                        width: 45,
                      ),
                      InkWell(
                        onTap: () => showFlexibleBottomSheet<void>(
                          useRootNavigator: true,
                          minHeight: 0,
                          initHeight:
                              0.9, //calculatePercentage(model.models!.length),
                          maxHeight: 0.95,
                          anchors: [0, 0.6, 0.95],

                          context: context,
                          builder: (_, c, d) => ProgramScreen(
                            controller: c,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/banner-icon.png',
                              height: 60,
                            ),
                            const Positioned(
                              child: Icon(Icons.arrow_forward_sharp),
                              right: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        topRightIcon ??
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              splashRadius: 5,
            ),
      ],
    );
  }
}

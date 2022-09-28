import 'dart:math';
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
  final String? message;

  FinalAddPointsArguments({
    required this.points,
    this.message,
  });
}

class FinalAddPointsScreen extends StatefulWidget
    implements FinalAddPointsArguments {
  final ScrollController controller;

  @override
  final String points;

  @override
  final String? message;

  const FinalAddPointsScreen({
    required this.controller,
    required this.points,
    this.message,
    Key? key,
  }) : super(key: key);

  @override
  State<FinalAddPointsScreen> createState() => _FinalAddPointsScreenState();
}

class _FinalAddPointsScreenState extends State<FinalAddPointsScreen> {
  Color iconColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: ScrollController(),
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.only(
          top: 14,
          right: StaticData.sidePadding,
        ),
        icon: Container(
          height: 1,
        ),
        iconColor: iconColor,
      ),
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: LayoutBuilder(
              builder: (_, c) {
                final circleRadius = c.maxWidth / 2 - 24;
                final internalBoxSize = circleRadius * sqrt(2);

                return Stack(
                  children: [
                    const SizedBox.expand(),
                    Positioned.fill(
                      child: Center(
                        child: CircleAvatar(
                          radius: circleRadius,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: c.maxHeight / 2,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              color: Colors.white.withOpacity(0.16),
                              //height: MediaQuery.of(context).size.height / 3,
                              constraints: const BoxConstraints.expand(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: SizedBox(
                          height: internalBoxSize,
                          width: internalBoxSize,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    '+${widget.points}',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: AppTheme.mineShaft,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 85,
                                      height: 80 / 85,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                  const PointWidget(
                                    radius: 18,
                                    textStyle: TextStyle(
                                      color: AppTheme.mineShaft,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 27,
                                      height: 25 / 27,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: AutoSizeText(
                                  widget.message ?? 'Спасибо, что вы \nс нами!',
                                  maxLines: 2,
                                  style: AppStyles.h1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],

      // TODO(all): Если знаем, что линзы куплены, то нужно предложить сделить их «Моими линзами»
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

import 'dart:math';
import 'dart:ui';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_lenses_screen.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/white_button_with_text.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/material.dart';

//* Add_points
//* final

class FinalAddPointsArguments {
  final String points;
  final String? message;
  final LensProductModel? productBausch;
  final MyLensesWM? myLensesWM;

  FinalAddPointsArguments({
    required this.points,
    this.message,
    this.productBausch,
    this.myLensesWM,
  });
}

class FinalAddPointsScreen extends StatefulWidget
    implements FinalAddPointsArguments {
  final ScrollController controller;

  @override
  final String points;

  @override
  final String? message;

  @override
  final LensProductModel? productBausch;

  @override
  final MyLensesWM? myLensesWM;

  const FinalAddPointsScreen({
    required this.controller,
    required this.points,
    this.message,
    this.productBausch,
    this.myLensesWM,
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
                                    radius: 17,
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
      bottomNavBar: ColoredBox(
        color: AppTheme.mystic,
        child: Padding(
          padding: const EdgeInsets.all(StaticData.sidePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: BlueButtonWithText(
                  text: 'Потратить баллы',
                  onPressed: () {
                    if (spendPointsPositionKey.currentContext != null) {
                      Scrollable.ensureVisible(
                        spendPointsPositionKey.currentContext!,
                      );
                    }
                    Keys.mainContentNav.currentState!.pop();
                  },
                ),
              ),
              if (widget.productBausch != null)
                WhiteButtonWithText(
                  text: 'Сделать моими линзами',
                  onPressed: () {
                    if (spendPointsPositionKey.currentContext != null) {
                      Scrollable.ensureVisible(
                        spendPointsPositionKey.currentContext!,
                      );
                    }
                    Keys.mainContentNav.currentState!.pop();

                    AppsflyerSingleton.sdk.logEvent(
                      'my-lenses-after-buy',
                      <String, dynamic>{
                        'id': widget.productBausch?.id,
                        'name': widget.productBausch?.name,
                      },
                    );

                    AppMetrica.reportEventWithMap(
                      'my-lenses-after-buy',
                      <String, Object>{
                        if (widget.productBausch?.id != null)
                          'id': widget.productBausch!.id,
                        if (widget.productBausch?.name != null)
                          'name': widget.productBausch!.name,
                      },
                    );

                    Keys.mainContentNav.currentState!.pushNamed(
                      '/choose_lenses',
                      arguments: ChooseLensesScreenArguments(
                        isEditing: false,
                        productBausch: widget.productBausch,
                        myLensesWM: widget.myLensesWM,
                      ),
                    );
                  },
                ),
              const SizedBox(height: 8),
              const BottomInfoBlock(topPadding: 0),
            ],
          ),
        ),
      ),
    );
  }
}

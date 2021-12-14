import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

//catalog_webinar
class WebinarsScreen extends StatelessWidget implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final WebinarItemModel model;

  const WebinarsScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
                bottom: 4,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TopSection.webinar(model, key),
                    const SizedBox(
                      height: 4,
                    ),
                    WhiteContainerWithRoundedCorners(
                      padding: EdgeInsets.fromLTRB(12, 20, 12, 40),
                      child: Column(
                        children: [
                          Text(
                            'Программа вебинара, 60 минут:',
                            style: AppStyles.h2,
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'Реальное влияние цифровых устройствна наши глаза',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'Компьютерный зрительный синдром: причины, симптомы и профилактика',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text: 'Головные боли при работе с гаджетами',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'Как сохранить здоровье глаз при работе за компьютером',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'Компьютерный зрительный синдром и контактные линзы',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomFloatingActionButton(
          text: 'Перейти к просмотру',
          onPressed: () {
            Keys.bottomSheetItemsNav.currentState!.pushNamed(
              '/verification_webinar',
              arguments: SheetScreenArguments(model: model),
            );
            // debugPrint(model.vimeoId);
            // showDialog<void>(
            //   context: Keys.bottomSheetItemsNav.currentContext!,
            //   builder: (context) {
            //     return DialogWithPlayers(
            //       vimeoId: model.vimeoId,
            //     );
            //   },
            // );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

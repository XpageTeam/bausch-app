import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';
import 'package:bausch/static/static_data.dart';

class VerificationScreenArguments {
  final String title;
  final String? subtitle;
  final CatalogItemModel model;
  final ScrollController controller;
  final bool isFinal;

  VerificationScreenArguments({
    required this.title,
    this.subtitle,
    required this.model,
    required this.controller,
    required this.isFinal,
  });
}

class VerificationScreen extends StatelessWidget
    implements VerificationScreenArguments {
  @override
  final ScrollController controller;
  @override
  final CatalogItemModel model;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  final bool isFinal;

  const VerificationScreen(
      {required this.model,
      required this.controller,
      required this.title,
      required this.isFinal,
      this.subtitle,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: isFinal ? AppTheme.sulu : AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.sidePadding),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomSliverAppbar(),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            title,
                            style: AppStyles.h2,
                          ),
                          if (!isFinal)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  subtitle ?? '',
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (isFinal)
                            WhiteRoundedContainer(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'promocode',
                                    style: AppStyles.h2,
                                  )
                                ],
                              ),
                            ),
                          if (!isFinal)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                DiscountInfo(text: 'Скидка 500 ₽'),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'В оптике ЛинзСервис',
                                  style: AppStyles.h2,
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 4,
                          ),
                          WhiteRoundedContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: const [
                                      Text(
                                        'Раствор Biotrue универсальный (300 мл)',
                                        style: AppStyles.h2,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      ButtonContent(
                                        price: '1300',
                                        alignment: MainAxisAlignment.start,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Image.asset(
                                  'assets/free-packaging.png',
                                  height: 100,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'После покупки у вас останется 100 баллов',
                            style: AppStyles.p1,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 132,
          color: AppTheme.mystic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding),
                child: BlueButtonWithText(
                  text: 'Потратить баллы',
                  onPressed: () {
                    if (!isFinal) {
                      Utils.bottomSheetNav.currentState!.pushNamed('/final');
                    }
                  },
                ),
              ),
              InfoBlock(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

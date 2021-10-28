import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class DiscountVerification extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const DiscountVerification({
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
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSliverAppbar.toPop(
                          icon: Container(),
                          key: key,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Подтвердите покупку',
                          style: AppStyles.h2,
                        ),
                        Column(
                          children: const [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'После подтверждения мы спишем баллы, и вы получите промокод',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            DiscountInfo(text: 'Скидка 500 ₽'),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'в оптике ЛинзСервис',
                              style: AppStyles.h2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BigCatalogItem(
                          model: model,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'После покупки у вас останется 100 баллов',
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
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
                  horizontal: StaticData.sidePadding,
                ),
                child: BlueButtonWithText(
                  text: 'Потратить баллы',
                  onPressed: () {
                    Keys.bottomSheetItemsNav.currentState!
                        .pushNamed('/final_discount');
                  },
                ),
              ),
              const InfoBlock(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

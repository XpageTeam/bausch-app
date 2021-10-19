import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class FinalDiscountOptics extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const FinalDiscountOptics({
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
        backgroundColor: AppTheme.sulu,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CustomSliverAppbar(
                      padding: EdgeInsets.only(top: StaticData.sidePadding),
                      navKey: Keys.bottomSheetItemsNav,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 40),
                      child: Text(
                        'Вот ваш промокод на скидку 500 ₽ в оптике ЛинзСервис',
                        style: AppStyles.h2,
                      ),
                    ),
                    WhiteRoundedContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'adasd34',
                            style: AppStyles.h2,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 40,
                      ),
                      child: Text(
                        'Промокод можно использовать в течение полугода. Он истечёт 28 февраля 2022 года. Промокод хранится в Профиле.',
                        style: AppStyles.p1,
                      ),
                    ),
                    BigCatalogItem(model: model),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: const BottomButtonWithRoundedCorners(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

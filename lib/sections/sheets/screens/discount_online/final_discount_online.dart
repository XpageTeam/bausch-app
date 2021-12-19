import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class FinalDiscountOnline extends StatelessWidget {
  final ScrollController controller;
  final PromoItemModel model;

  const FinalDiscountOnline({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      backgroundColor: AppTheme.sulu,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
        //iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(top: 78, bottom: 40),
                  child: Text(
                    'Это ваш промокод на скидку 500 ₽ в интернет-магазине ЛинзСервис',
                    style: AppStyles.h1,
                  ),
                ),
                ContainerWithPromocode(
                  promocode: model.code,
                ),
                Padding(
                  padding: const EdgeInsets.only(
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
      bottomButton: const BottomButtonWithRoundedCorners(
        text: 'Скопировать и перейти на сайт',
      ),
    );
  }
}

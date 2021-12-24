import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class FinalDiscountOptics extends StatelessWidget {
  final ScrollController controller;
  final PromoItemModel model;
  final String? text;
  final String? buttonText;

  final DiscountOptic? discountOptic;
  final DiscountType discountType;

  const FinalDiscountOptics({
    required this.controller,
    required this.model,
    required this.discountType,
    this.discountOptic,
    this.buttonText,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
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
                  padding: const EdgeInsets.only(top: 80, bottom: 40),
                  child: Text(
                    text ??
                        'Это ваш промокод на скидку 500 ₽ '
                            'в ${discountType == DiscountType.offline ? 'оптике' : 'интернет-магазине'} '
                            ' ${discountOptic != null ? discountOptic!.title : ''}',
                    // 'Вот ваш промокод на скидку 500 ₽ '
                    // '${discountOptic != null ? 'в ${discountType == DiscountTypeClass.offline ? 'оптике' : 'интернет-магазине'} ${discountOptic!.title}' : ''}',
                    style: AppStyles.h2,
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
      bottomNavBar: BottomButtonWithRoundedCorners(
        text: discountType == DiscountType.offline
            ? 'На главную'
            : 'Скопировать код и перейти на сайт',
      ),
    );
  }
}

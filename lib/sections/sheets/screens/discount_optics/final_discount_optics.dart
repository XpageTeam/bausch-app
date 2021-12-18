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

class FinalDiscountOptics extends StatelessWidget {
  final ScrollController controller;
  final PromoItemModel model;
  final String? text;
  final String? buttonText;
  final GlobalKey<NavigatorState>? rightKey;

  const FinalDiscountOptics({
    required this.controller,
    required this.model,
    this.buttonText,
    this.text,
    this.rightKey,
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
                // CustomSliverAppbar.toPop(
                //   icon: Container(),
                //   key: key,
                //   rightKey: rightKey,
                //   backgroundColor: Colors.white,
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 78, bottom: 40),
                  child: Text(
                    text ??
                        'Это ваш промокод на скидку 500 ₽ в оптике ЛинзСервис',
                    style: AppStyles.h1,
                  ),
                ),
                ContainerWithPromocode(
                  promocode: model.code,
                  withIcon: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 40,
                  ),
                  child: Text(
                    'Промокод можно использовать в течение полугода. Он истечёт 28 февраля 2022 года. Промокод хранится в личном кабинете.',
                    style: AppStyles.p1,
                  ),
                ),
                BigCatalogItem(model: model),
              ],
            ),
          ),
        ),
      ],
      bottomButton: BottomButtonWithRoundedCorners(
        text: buttonText ?? 'На главную',
      ),
    );
  }
}

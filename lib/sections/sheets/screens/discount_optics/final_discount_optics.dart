import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
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

  const FinalDiscountOptics({
    required this.controller,
    required this.model,
    this.buttonText,
    this.text,
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
                    CustomSliverAppbar.toPop(
                      icon: Container(),
                      key: key,
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Text(
                        text ??
                            'Вот ваш промокод на скидку 500 ₽ в оптике ЛинзСервис',
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
        ),
        floatingActionButton: BottomButtonWithRoundedCorners(
          text: buttonText ?? 'На главную',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

class FinalFreePackaging extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const FinalFreePackaging({
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
                    CustomSliverAppbar.toPop(icon: Container(), key: key),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Заказ оформлен',
                        style: AppStyles.h2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 40,
                      ),
                      child: Text(
                        'За статусом заказа можно будет следить в Профиле.',
                        style: AppStyles.p1,
                      ),
                    ),
                    BigCatalogItem(model: model),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 120),
                      child: Column(
                        children: const [
                          TextWithPoint(
                            text:
                                'После того, как данные заказа будут переданы логистической компании, мы позвоним для подтверждения адреса доставки и данных получателя по указанному в профиле номеру телефона. Обычно это происходит в течение 2-3 недель. Если нам не удастся дозвониться, мы будем вынуждены отменить заказ.',
                          ),
                        ],
                      ),
                    ),
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

import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class FinalPartners extends StatelessWidget {
  final ScrollController controller;
  final PartnersItemModel model;
  const FinalPartners({
    required this.controller,
    required this.model,
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
                  padding: const EdgeInsets.only(
                    top: 78,
                    bottom: 40,
                  ),
                  // TODO(Nikolay): Нет данных.
                  child: Text(
                    'Это ваш промокод на 45-дневную подписку на онлайн-кинотеатр More.TV',
                    style: AppStyles.h1,
                  ),
                ),
                if (model.poolPromoCode != null)
                  ContainerWithPromocode(
                    promocode: model.poolPromoCode!,
                    onPressed: () =>
                        Utils.copyStringToClipboard(model.poolPromoCode!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 40,
                  ),
                  // TODO(Nikolay): Нет данных.
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
      bottomNavBar: model.poolPromoCode != null
          ? BottomButtonWithRoundedCorners(
              text: model.link != null
                  ? 'Скопировать код и перейти на сайт'
                  : 'На главную',
              withInfo: false,
              onPressed: model.link != null
                  ? () {
                      Utils.copyStringToClipboard(
                        model.poolPromoCode!,
                      );
                      Utils.tryLaunchUrl(
                        rawUrl: model.link!,
                        isPhone: false,
                      );
                    }
                  : null,
            )
          : null,
    );
  }
}

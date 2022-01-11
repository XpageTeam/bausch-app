import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class FinalConsultation extends StatelessWidget {
  final ScrollController controller;
  final ConsultationItemModel model;

  const FinalConsultation({
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
        icon: Container(
          height: 1,
        ),
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
                  padding: const EdgeInsets.only(top: 78),
                  // TODO(Nikolay): Нет данных.
                  child: Text(
                    'Вот ваш промокод на онлайн-консультацию',
                    style: AppStyles.h1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: ContainerWithPromocode(
                    promocode: model.poolPromoCode,
                  ),
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
      bottomNavBar: BottomButtonWithRoundedCorners(
        text: 'Скопировать код и перейти на сайт',
        onPressed: () {
          Utils.copyStringToClipboard(
            model.poolPromoCode,
          );
          // TODO(Nikolay): Нужна ссылка.
          // Utils.tryLaunchUrl(
          //   rawUrl: model.link!,
          //   isPhone: false,
          // );
        },
      ),
    );
  }
}

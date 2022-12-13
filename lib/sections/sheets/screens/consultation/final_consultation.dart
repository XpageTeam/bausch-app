import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/models/orders_data/order_data.dart';
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
  final OrderData orderData;

  const FinalConsultation({
    required this.controller,
    required this.model,
    required this.orderData,
    Key? key,
  }) : super(
          key: key,
        );

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
                if (orderData.title != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 78),
                    child: Text(
                      orderData.title!,
                      style: AppStyles.h1,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: ContainerWithPromocode(
                    promocode: orderData.promoCode ??
                        'Промокод будет доступен в истории заказов через несколько минут',
                  ),
                ),
                if (orderData.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 40,
                    ),
                    child: Text(
                      orderData.subtitle!,
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
        text: model.partnerLink != null && orderData.promoCode != null
            ? 'Скопировать код и перейти на сайт'
            : 'На главную',
        onPressed: model.partnerLink != null && orderData.promoCode != null
            ? () {
                Utils.copyStringToClipboard(
                  orderData.promoCode!,
                );

                Utils.tryLaunchUrl(
                  rawUrl: model.partnerLink!,
                );

                AppsflyerSingleton.sdk.logEvent('onlineConsultationLink', null);
                AppMetrica.reportEventWithMap('onlineConsultationLink', null);
              }
            : () {
                Keys.mainContentNav.currentState!.pop();
              },
      ),
    );
  }
}

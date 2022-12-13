import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';

class FinalPartners extends StatelessWidget {
  final ScrollController controller;
  final PartnersItemModel model;
  final PartnerOrderResponse orderData;

  const FinalPartners({
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
                  child: Text(
                    orderData.title != null ? orderData.title! : '',
                    style: AppStyles.h1,
                  ),
                ),
                ContainerWithPromocode(
                  promocode: orderData.promoCode ??
                      'Промокод будет доступен в истории заказов через несколько минут',
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
        text: model.link != null && orderData.promoCode != null
            ? 'Скопировать код и перейти на сайт'
            : 'На главную',
        withInfo: false,
        onPressed: model.link != null && orderData.promoCode != null
            ? () {
                Utils.copyStringToClipboard(orderData.promoCode!);

                Utils.tryLaunchUrl(
                  rawUrl: model.link!,
                  onError: (ex) {
                    showDefaultNotification(
                      title: ex.title,
                      // subtitle: ex.subtitle,
                    );
                  },
                );

                AppsflyerSingleton.sdk.logEvent(
                  'partnersItemsOrderLink',
                  <String, dynamic>{
                    'id': model.id,
                    'title': model.name,
                    'link': model.link,
                  },
                );

                AppMetrica.reportEventWithMap(
                  'partnersItemsOrderLink',
                  <String, Object>{
                    'id': model.id,
                    'title': model.name,
                    if (model.link != null) 'link': model.link!,
                  },
                );
              }
            : () {
                Keys.mainContentNav.currentState!.pop();
              },
      ),
    );
  }
}

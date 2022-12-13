import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
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

class FinalDiscountOptics extends StatelessWidget {
  final ScrollController controller;
  final PromoItemModel model;
  final String? text;
  final String? buttonText;

  final Optic? discountOptic;
  final DiscountType discountType;

  final PartnerOrderResponse? orderData;

  FinalDiscountOptics({
    required this.controller,
    required this.model,
    required String section,
    this.orderData,
    this.discountOptic,
    this.buttonText,
    this.text,
    Key? key,
  })  : discountType = section.contains('online')
            ? DiscountType.onlineShop
            : DiscountType.offline,
        super(
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
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (orderData?.title != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 80, bottom: 40),
                    child: Text(
                      orderData!.title!,
                      style: AppStyles.h2,
                    ),
                  ),
                ContainerWithPromocode(
                  promocode: orderData?.promoCode ??
                      'Промокод будет доступен в истории заказов через несколько минут',
                ),
                if (orderData?.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 40,
                    ),
                    child: Text(
                      orderData!.subtitle!,
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
        text: (discountType == DiscountType.onlineShop) &&
                orderData?.promoCode != null
            ? 'Скопировать код и перейти на сайт'
            : 'На главную',
        onPressed: (discountType == DiscountType.onlineShop) &&
                orderData?.promoCode != null
            ? () {
                Utils.copyStringToClipboard(orderData!.promoCode!);

                if (discountOptic != null && discountOptic!.link != null) {
                  Utils.tryLaunchUrl(
                    rawUrl: discountOptic!.link!,
                    onError: (ex) {
                      showDefaultNotification(
                        title: ex.title,
                        // subtitle: ex.subtitle,
                      );
                    },
                  );
                } else {
                  showTopError(
                    const CustomException(
                      title: 'Не удалось перейти на сайт',
                    ),
                  );
                }
              }
            : () {
                Keys.mainContentNav.currentState!.pop();
              },
      ),
    );
  }
}

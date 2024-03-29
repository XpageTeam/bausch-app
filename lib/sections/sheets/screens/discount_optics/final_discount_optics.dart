import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/final_discount_wm.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/loading_code_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FinalDiscountOptics extends CoreMwwmWidget<FinalDiscountWM> {
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
          widgetModelBuilder: (context) => FinalDiscountWM(
            context: context,
            discountOptic: discountOptic,
            discountType: section.contains('online')
                ? DiscountType.onlineShop
                : DiscountType.offline,
            itemModel: model,
            orderId: orderData?.orderID,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<FinalDiscountWM>, FinalDiscountWM>
      createWidgetState() => _FinalDiscountOpticsState();
}

class _FinalDiscountOpticsState
    extends WidgetState<FinalDiscountOptics, FinalDiscountWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: widget.controller,
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
                if (widget.orderData?.title != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 80, bottom: 40),
                    child: Text(
                      widget.orderData!.title!,
                      // widget.text ??
                      //     'Это ваш промокод на скидку 500 ₽ '
                      //         'в ${widget.discountType == DiscountType.offline ? 'оптике' : 'интернет-магазине'} '
                      //         ' ${widget.discountOptic != null ? widget.discountOptic!.title : ''}',
                      // 'Вот ваш промокод на скидку 500 ₽ '
                      // '${discountOptic != null ? 'в ${discountType == DiscountTypeClass.offline ? 'оптике' : 'интернет-магазине'} ${discountOptic!.title}' : ''}',
                      style: AppStyles.h2,
                    ),
                  ),
                EntityStateBuilder<String>(
                  streamedState: wm.promocodeState,
                  errorChild: ContainerWithPromocode(
                    promocode:
                        'Промокод будет доступен в истории заказов через несколько минут',
                    withIcon: false,
                    onPressed: () {},
                  ),
                  loadingChild: const LoadingCodeContainer(
                    text: 'Генерируем ваш промокод...',
                  ),
                  builder: (_, state) {
                    return ContainerWithPromocode(
                      promocode: state,
                    );
                  },
                ),
                if (widget.orderData?.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 40,
                    ),
                    child: Text(
                      widget.orderData!.subtitle!,
                      style: AppStyles.p1,
                    ),
                  ),
                BigCatalogItem(model: widget.model),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: StreamedStateBuilder<bool>(
        streamedState: wm.enabledState,
        builder: (_, enabled) {
          return BottomButtonWithRoundedCorners(
            text: (widget.discountType == DiscountType.offline || !enabled)
                ? 'На главную'
                : 'Скопировать код и перейти на сайт',
            onPressed: (widget.discountType == DiscountType.onlineShop &&
                    enabled)
                ? () {
                    Utils.copyStringToClipboard(wm.promocodeState.value.data!);

                    if (widget.discountOptic != null &&
                        widget.discountOptic!.link != null) {
                      Utils.tryLaunchUrl(
                        rawUrl: widget.discountOptic!.link!,
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
                    wm.buttonAction();
                  },
          );
        },
      ),
    );
  }
}

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
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
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
    required this.discountType,
    this.orderData,
    this.discountOptic,
    this.buttonText,
    this.text,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => FinalDiscountWM(
            context: context,
            discountOptic: discountOptic,
            discountType: discountType,
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
                      //     '?????? ?????? ???????????????? ???? ???????????? 500????? '
                      //         '?? ${widget.discountType == DiscountType.offline ? '????????????' : '????????????????-????????????????'} '
                      //         ' ${widget.discountOptic != null ? widget.discountOptic!.title : ''}',
                      // '?????? ?????? ???????????????? ???? ???????????? 500????? '
                      // '${discountOptic != null ? '?? ${discountType == DiscountTypeClass.offline ? '????????????' : '????????????????-????????????????'} ${discountOptic!.title}' : ''}',
                      style: AppStyles.h2,
                    ),
                  ),
                EntityStateBuilder<String>(
                  streamedState: wm.promocodeState,
                  errorChild: ContainerWithPromocode(
                    promocode: '???????????????? ?????????? ???????????????? ?? ?????????????? ?????????????? ?????????? ?????????????????? ??????????',
                    withIcon: false,
                    onPressed: () {},
                  ),
                  loadingChild: const LoadingCodeContainer(
                    text: '???????????????????? ?????? ????????????????...',
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
                ? '???? ??????????????'
                : '?????????????????????? ?????? ?? ?????????????? ???? ????????',
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
                            subtitle: ex.subtitle,
                          );
                        },
                      );
                    } else {
                      showTopError(
                        const CustomException(
                          title: '???? ?????????????? ?????????????? ???? ????????',
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

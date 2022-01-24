import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/sections/sheets/screens/partners/widget_models/final_partners_wm.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/loading_code_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FinalPartners extends CoreMwwmWidget<FinalPartnersWM> {
  final ScrollController controller;
  final PartnersItemModel model;
  final PartnerOrderResponse? orderData;

  FinalPartners({
    required this.controller,
    required this.model,
    this.orderData,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => FinalPartnersWM(
            context: context,
            itemModel: model,
            orderId: orderData?.orderID,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<FinalPartnersWM>, FinalPartnersWM>
      createWidgetState() => _FinalPartnersState();
}

class _FinalPartnersState extends WidgetState<FinalPartners, FinalPartnersWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: widget.controller,
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
                    widget.orderData?.title != null
                        ? widget.orderData!.title!
                        : '',
                    style: AppStyles.h1,
                  ),
                ),
                if (widget.model.staticPromoCode != null &&
                    widget.model.staticPromoCode!.isNotEmpty)
                  ContainerWithPromocode(
                    promocode: widget.model.staticPromoCode!,
                    onPressed: () => Utils.copyStringToClipboard(
                      widget.model.staticPromoCode!,
                    ),
                  )
                else
                  EntityStateBuilder<String>(
                    streamedState: wm.promocodeState,
                    errorChild: ContainerWithPromocode(
                      promocode: 'Промокод будет доступен в истории заказов!',
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
      bottomNavBar: widget.model.poolPromoCode != null
          ? BottomButtonWithRoundedCorners(
              text: widget.model.link != null
                  ? 'Скопировать код и перейти на сайт'
                  : 'На главную',
              withInfo: false,
              onPressed: widget.model.link != null
                  ? () {
                      Utils.copyStringToClipboard(
                        widget.model.poolPromoCode!,
                      );
                      Utils.tryLaunchUrl(
                        rawUrl: widget.model.link!,
                        isPhone: false,
                      );
                    }
                  : null,
            )
          : null,
    );
  }
}

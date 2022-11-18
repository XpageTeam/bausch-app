import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/models/orders_data/order_data.dart';
import 'package:bausch/sections/sheets/screens/consultation/widget_model/final_consultation_wm.dart';
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

class FinalConsultation extends CoreMwwmWidget<FinalConsultationWM> {
  final ScrollController controller;
  final ConsultationItemModel model;
  final OrderData orderData;

  FinalConsultation({
    required this.controller,
    required this.model,
    required this.orderData,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => FinalConsultationWM(
            context: context,
            itemModel: model,
            orderId: orderData.orderID,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<FinalConsultationWM>, FinalConsultationWM>
      createWidgetState() => _FinalConsultationState();
}

class _FinalConsultationState
    extends WidgetState<FinalConsultation, FinalConsultationWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: widget.controller,
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
                if (widget.orderData.title != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 78),
                    child: Text(
                      widget.orderData.title!,
                      style: AppStyles.h1,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: EntityStateBuilder<String>(
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
                ),
                if (widget.orderData.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 40,
                    ),
                    child: Text(
                      widget.orderData.subtitle!,
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
            text: enabled ? 'Скопировать код и перейти на сайт' : 'На главную',
            onPressed: enabled
                ? () {
                    if (widget.model.partnerLink != null) {
                      Utils.copyStringToClipboard(
                        wm.promocodeState.value.data!,
                      );

                      Utils.tryLaunchUrl(
                        rawUrl: widget.model.partnerLink!,
                      );

                      AppsflyerSingleton.sdk.logEvent('onlineConsultationLink', null);
                      AppMetrica.reportEventWithMap('onlineConsultationLink', null);
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

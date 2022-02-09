import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/orders_data/order_data.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/sections/select_optic/select_optics_screen.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_discount_optics
class DiscountOpticsScreen extends CoreMwwmWidget<DiscountOpticsScreenWM>
    implements ItemSheetScreenArguments {
  final ScrollController controller;

  @override
  final PromoItemModel model;

  @override
  final OrderData? orderData;

  DiscountOpticsScreen({
    required this.controller,
    required this.model,
    required DiscountType discountType,
    this.orderData,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => DiscountOpticsScreenWM(
            context: context,
            itemModel: model,
            discountType: discountType,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<DiscountOpticsScreenWM>, DiscountOpticsScreenWM>
      createWidgetState() => _DiscountOpticsScreenState();
}

class _DiscountOpticsScreenState
    extends WidgetState<DiscountOpticsScreen, DiscountOpticsScreenWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(AppTheme.mystic);
        }
      },
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            padding: const EdgeInsets.all(18),
            icon: const SizedBox(),
            iconColor: color,
          );
        },
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 12,
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
            bottom: 4,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                TopSection.product(
                  widget.model,
                  const DiscountInfo(text: 'Скидка 500 ₽ '),
                  widget.key,
                ),
                const SizedBox(
                  height: 4,
                ),
                if (wm.difference > 0)
                  Warning.warning('Не хватает ${wm.difference} баллов')
                else
                  const SizedBox(),
                InfoSection(
                  text: widget.model.previewText,
                  secondText: '',
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            12,
            StaticData.sidePadding,
            20,
          ),
          sliver: LegalInfo(
            texts: wm.legalInfoTexts,
          ),
        ),
        EntityStateBuilder<List<Optic>>(
          streamedState: wm.discountOpticsStreamed,
          loadingChild: SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  StaticData.sidePadding,
                  20,
                  StaticData.sidePadding,
                  20,
                ),
                child: Center(
                  child: AnimatedLoader(),
                ),
              ),
            ]),
          ),
          errorChild: const _NoDiscountsAvailable(),
          builder: (_, discountOptics) {
            if (discountOptics.isEmpty) {
              return const _NoDiscountsAvailable();
            }

            final items = <Widget>[
              Text(
                wm.selectHeaderText,
                style: AppStyles.h1,
              ),
              if (wm.discountType == DiscountType.offline)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                  ),
                  child: Text(
                    'Скидкой можно воспользоваться в любой из оптик сети.',
                    style: AppStyles.p1,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: StreamedStateBuilder<Optic?>(
                  streamedState: wm.currentDiscountOptic,
                  builder: (_, selectedOptic) => SelectShopSection(
                    selectedOptic: selectedOptic,
                    discountOptics: discountOptics,
                    onChanged: wm.setCurrentOptic,
                    discountType: wm.discountType,
                  ),
                ),
              ),
              if (wm.discountType == DiscountType.offline)
                StreamedStateBuilder<Optic?>(
                  streamedState: wm.currentDiscountOptic,
                  builder: (_, currentDiscountOptic) => Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 4,
                    ),
                    child: WhiteButton(
                      text: currentDiscountOptic != null
                          ? currentDiscountOptic.title
                          : 'Адреса оптик',
                      icon: Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                          top: 16,
                          bottom: 16,
                        ),
                        child: Image.asset(
                          'assets/icons/map-marker.png',
                          height: 16,
                        ),
                      ),
                      onPressed: () => Keys.mainNav.currentState!.push<void>(
                        MaterialPageRoute(
                          builder: (context) => SelectOpticScreen(
                            cities: wm.cities,
                            onOpticSelect: (optic, _, __) =>
                                wm.setCurrentOptic(optic),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Warning.warning(wm.warningText),
            ];

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                20,
                StaticData.sidePadding,
                20,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => items[index],
                  childCount: items.length,
                ),
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: HowToUsePromocode(text: wm.howToUseText),
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: StreamedStateBuilder<Optic?>(
        streamedState: wm.currentDiscountOptic,
        builder: (_, currentOptic) {
          return CustomFloatingActionButton(
            text: wm.isEnough ? 'Получить скидку' : 'Накопить баллы',
            icon: wm.isEnough
                ? null
                : const Icon(
                    Icons.add,
                    color: AppTheme.mineShaft,
                  ),
            onPressed: wm.isEnough
                ? currentOptic != null
                    ? () => wm.buttonAction()
                    : null
                : () => wm.buttonAction(),
          );
        },
      ),
    );
  }
}

class _NoDiscountsAvailable extends StatelessWidget {
  const _NoDiscountsAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          StaticData.sidePadding,
          20,
          StaticData.sidePadding,
          20,
        ),
        child: Text(
          'Нет доступных скидок',
          style: AppStyles.h1,
        ),
      ),
    );
  }
}

class DiscountOpticsArguments extends ItemSheetScreenArguments {
  final Optic discountOptic;
  final DiscountType discountType;
  final PartnerOrderResponse? orderDataResponse;

  DiscountOpticsArguments({
    required this.discountOptic,
    required this.discountType,
    required CatalogItemModel model,
    required this.orderDataResponse,
  }) : super(
          model: model,
        );
}

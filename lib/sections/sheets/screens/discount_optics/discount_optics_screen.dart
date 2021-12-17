import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/sections/shops/shops_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum DiscountType {
  offline,
  onlineShop,
}

//catalog_discount_optics
class DiscountOpticsScreen extends CoreMwwmWidget<DiscountOpticsScreenWM>
    implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final PromoItemModel model;

  DiscountOpticsScreen({
    required this.controller,
    required this.model,
    required DiscountType discountType,
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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: widget.controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
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
                    InfoSection(
                      text: widget.model.previewText,
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
                40,
              ),
              sliver: LegalInfo(
                texts: wm.legalInfoTexts,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              //TODO(Nikita): customCheckBox
              sliver: SliverToBoxAdapter(
                child: EntityStateBuilder<List<DiscountOptic>>(
                  streamedState: wm.discountOpticsStreamed,
                  loadingChild: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  builder: (_, discountOptics) => discountOptics.isEmpty
                      ? Text(
                          'Нет доступных скидок',
                          style: AppStyles.h1,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              wm.selectHeaderText,
                              style: AppStyles.h1,
                            ),
                            if (wm.discountType == DiscountType.offline)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  bottom: 20,
                                ),
                                child: Text(
                                  'Скидкой можно воспользоваться в любой из оптик сети.',
                                  style: AppStyles.p1,
                                ),
                              ),
                            SelectShopSection(
                              discountOptics: discountOptics,
                              onChanged: wm.setCurrentOptic,
                              discountType: wm.discountType,
                            ),
                            if (wm.discountType == DiscountType.offline)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  bottom: 10,
                                ),
                                child: WhiteButton(
                                  text: 'Адреса оптик',
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 12,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/map-marker.png',
                                      height: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    Keys.mainNav.currentState!.push<void>(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => // TODO(Nikolay): Передавать список полученных оптик сюда.
                                                ShopsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            Warning.warning(wm.warningText),
                          ],
                        ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: HowToUsePromocode(text: wm.howToUseText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: StreamedStateBuilder<DiscountOptic?>(
          streamedState: wm.currentDiscountOptic,
          builder: (_, currentOptic) {
            return CustomFloatingActionButton(
              text: wm.difference > 0
                  ? 'Нехватает ${wm.difference} б'
                  : 'Получить скидку',
              onPressed: currentOptic != null
                  ? () => wm.buttonAction()
                  : wm.difference > 0
                      ? () => wm.buttonAction()
                      : null,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class VerificationDiscountOpticsArguments extends SheetScreenArguments {
  final DiscountOptic discountOptic;

  VerificationDiscountOpticsArguments({
    required this.discountOptic,
    required CatalogItemModel model,
  }) : super(
          model: model,
        );
}

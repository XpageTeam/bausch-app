import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
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
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_discount_optics
class DiscountOpticsScreen extends CoreMwwmWidget<DiscountOpticsScreenWM>
    implements ItemSheetScreenArguments {
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
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
        icon: SizedBox(),
        iconColor: AppTheme.mystic,
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
        SliverToBoxAdapter(
          child: EntityStateBuilder<List<Optic>>(
            streamedState: wm.discountOpticsStreamed,
            loadingChild: const Padding(
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
            errorChild: const _NoDiscountsAvailable(),
            builder: (_, discountOptics) => discountOptics.isEmpty
                ? const _NoDiscountsAvailable()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(
                      StaticData.sidePadding,
                      20,
                      StaticData.sidePadding,
                      20,
                    ),
                    child: Column(
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
                                onPressed: () =>
                                    Keys.mainNav.currentState!.push<void>(
                                  MaterialPageRoute(
                                    builder: (context) => SelectOpticScreen(
                                      cities: wm.cities,
                                      onOpticSelect: wm.setCurrentOptic,
                                    ),
                                  ),
                                ),
                              ),
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

class _SelectOpticButton extends StatelessWidget {
  final StreamedState<Optic?> currentDiscountOptic;
  final VoidCallback onPressed;

  const _SelectOpticButton({
    required this.currentDiscountOptic,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<Optic?>(
      streamedState: currentDiscountOptic,
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
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _NoDiscountsAvailable extends StatelessWidget {
  const _NoDiscountsAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class DiscountOpticsArguments extends ItemSheetScreenArguments {
  final Optic discountOptic;
  final DiscountType discountType;

  DiscountOpticsArguments({
    required this.discountOptic,
    required this.discountType,
    required CatalogItemModel model,
  }) : super(
          model: model,
        );
}

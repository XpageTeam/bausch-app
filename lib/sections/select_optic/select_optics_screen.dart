import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/select_optic/select_optics_screen_body.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/shop_filter.dart';
import 'package:bausch/sections/select_optic/widgets/shop_page_switcher.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Макет:
//* Program
//* list
class SelectOpticScreen extends CoreMwwmWidget<SelectOpticScreenWM> {
  final void Function(Optic optic, String city, OpticShop? shop) onOpticSelect;
  final String selectButtonText;

  SelectOpticScreen({
    required this.onOpticSelect,
    this.selectButtonText = 'Выбрать эту сеть оптик',
    List<OpticCity>? cities,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => SelectOpticScreenWM(
            context: context,
            initialCities: cities,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<SelectOpticScreenWM>, SelectOpticScreenWM>
      createWidgetState() => _SelectOpticScreenState();
}

class _SelectOpticScreenState
    extends WidgetState<SelectOpticScreen, SelectOpticScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Адреса оптик',
        backgroundColor: AppTheme.mystic,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Переключатель (карта/список)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              18,
              StaticData.sidePadding,
              20,
            ),
            child: ShopPageSwitcher(
              callback: wm.switchAction,
            ),
          ),

          // Кнопка выбора города
          EntityStateBuilder<String>(
            streamedState: wm.currentCityStreamed,
            builder: (context, currentCity) => Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                20,
              ),
              child: _SelectCityButton(
                city: currentCity,
                onPressed: wm.selectCityAction,
              ),
            ),
          ),

          // Кнопки фильтра магазинов
          StreamedStateBuilder<List<Optic>>(
            streamedState: wm.opticsByCityStreamed,
            builder: (_, optics) {
              final filters = Filter.getFiltersFromOpticList(
                optics,
              );
              return Padding(
                padding: const EdgeInsets.only(
                  left: StaticData.sidePadding,
                  right: StaticData.sidePadding,
                  bottom: 20.0,
                ),
                child: ShopFilterWidget(
                  filters: filters,
                  callback: wm.filtersOnChanged,
                ),
              );
            },
          ),

          // Карта/список
          Expanded(
            child: StreamedStateBuilder<SelectOpticPage>(
              streamedState: wm.currentPageStreamed,
              builder: (_, currentPage) => EntityStateBuilder<List<OpticShop>>(
                streamedState: wm.filteredOpticShopsStreamed,
                loadingChild: const Center(
                  child: AnimatedLoader(),
                ),
                // TODO(Nikolay): Чекнуть.
                errorBuilder: (context, e) {
                  final ex = e as CustomException;
                  //debugPrint(ex.subtitle);
                  showDefaultNotification(
                    title: ex.title,
                    subtitle: ex.subtitle,
                  );

                  return const SizedBox();
                },
                builder: (_, opticShops) => SelectOpticScreenBody(
                  selectButtonText: widget.selectButtonText,
                  currentPage: currentPage,
                  opticShops: opticShops,
                  onOpticShopSelect: (selectedShop) =>
                      wm.onOpticShopSelectAction(
                    OpticShopParams(
                      selectedShop,
                      (optic, shop) => widget.onOpticSelect(
                        optic,
                        wm.currentCityStreamed.value.data ?? '',
                        shop,
                      ),
                    ),
                  ),
                  // whenCompleteModalBottomSheet: (mapBodyWm) {
                  //   wm.setFirstCity();

                  //   Future.delayed(
                  //     const Duration(milliseconds: 10),
                  //     () {
                  //       mapBodyWm
                  //         ..isModalBottomSheetOpen.accept(false)
                  //         ..setCenterAction(
                  //           wm.filteredOpticShopsStreamed.value.data!,
                  //         );
                  //     },
                  //   );
                  // },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectCityButton extends StatelessWidget {
  final String city;
  final VoidCallback onPressed;
  const _SelectCityButton({
    required this.city,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Город',
                      style: AppStyles.p1Grey,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Flexible(
                      child: Text(
                        city,
                        style: AppStyles.h2Bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.mineShaft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

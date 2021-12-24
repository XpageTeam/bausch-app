import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/shops/map_body.dart';
import 'package:bausch/sections/shops/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/shops/widgets/shop_container.dart';
import 'package:bausch/sections/shops/widgets/shop_list_widget.dart';
import 'package:bausch/sections/shops/widgets/shop_page_switcher.dart';
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
  SelectOpticScreen({
    List<OpticCity>? cities,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => SelectOpticScreenWM(
            context: context,
            initialOptics: cities,
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
              child: SelectCityButton(
                city: currentCity,
                onPressed: wm.selectCityAction,
              ),
            ),
          ),

          // Кнопки фильтра магазинов
          // Padding(
          //   padding: const EdgeInsets.only(
          //     left: StaticData.sidePadding,
          //     right: StaticData.sidePadding,
          //     bottom: 20.0,
          //   ),
          //   child: ShopFilter(
          //     filters: Filter.getFiltersFromShopList(
          //       shopList,
          //     ),
          //     callback: wm.filtersOnChanged,
          //   ),
          // ),

          // Карта/список
          // TODO(Nikolay): Как-то надо сохранять состояние виджета с картой и со списком магазинов.
          Expanded(
            child: StreamedStateBuilder<ShopsContentType>(
              streamedState: wm.contentTypeStreamed,
              builder: (_, currentContentType) =>
                  EntityStateBuilder<List<OpticShop>>(
                streamedState: wm.opticShopsStreamed,
                loadingChild: const Center(
                  child: AnimatedLoader(),
                ),
                errorBuilder: (context, e) {
                  final ex = e as CustomException;
                  showDefaultNotification(
                    title: ex.title,
                    subtitle: ex.subtitle,
                  );

                  return const SizedBox();
                },
                builder: (_, opticShops) =>
                    wm.contentTypeStreamed.value == ShopsContentType.list
                        ? ShopListWidget(
                            containerType: ShopContainer, shopList: [],
                            // TODO(Nikolay): сделать.
                            // optics[0]
                            //     .disountOpticShops!
                            //     .map(
                            //       (e) => e.toShopModel,
                            //     )
                            //     .toList(),
                          )
                        : MapBody(
                            // TODO(Nikolay): Переделать.
                            opticShops: opticShops,
                            shopList: [],
                            shopsEmptyCallback: (mapBodyWm) {
                              mapBodyWm.isModalBottomSheetOpen.accept(true);
                              showModalBottomSheet<dynamic>(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (context) => BottomSheetContent(
                                  title: 'Поблизости нет оптик',
                                  subtitle:
                                      'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
                                  btnText: 'Хорошо',
                                  onPressed: Navigator.of(context).pop,
                                ),
                              ).whenComplete(() {
                                mapBodyWm.isModalBottomSheetOpen.accept(false);
                                wm.setFirstCity();
                              });
                            },
                          ),
              ),
            ),
          ),

          // С фильтром
          // Expanded(
          //   child: BlocBuilder<ShopFilterBloc, ShopFilterState>(
          //     bloc: filterBloc,
          //     builder: (context, filterState) {
          //       return BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
          //         bloc: pageSwitcherCubit,
          //         builder: (context, switherState) {
          //           if (switherState is PageSwitcherShowList) {
          //             return ShopListAdapter(
          //               containerType: ShopContainer,
          //               shopList: shopList,
          //               state: filterState,
          //             );
          //           } else {
          //             return MapBody(
          //               cityList: widget.cityList,
          //               shopList: shopList
          //                   .where(
          //                     (shop) =>
          //                         filterState is! ShopFilterChange ||
          //                         filterState.selectedFilters.any(
          //                           (filter) => filter.title == shop.name,
          //                         ),
          //                   )
          //                   .toList(),
          //             );
          //           }
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SelectCityButton extends StatelessWidget {
  final String city;
  final VoidCallback onPressed;
  const SelectCityButton({
    required this.city,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
      onPressed: onPressed,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
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
      ],
      chevronColor: AppTheme.mineShaft,
    );
  }
}

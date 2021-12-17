import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/shops/cubits/page_switcher_cubit/page_switcher_cubit_cubit.dart';
import 'package:bausch/sections/shops/map_body.dart';
import 'package:bausch/sections/shops/widgets/shop_container.dart';
import 'package:bausch/sections/shops/widgets/shop_list_adapter.dart';
import 'package:bausch/sections/shops/widgets/shop_page_switcher.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:bausch/widgets/shop_filter_widget/shop_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ShopsScreenBody extends StatefulWidget {
  final List<CityModel> cityList;
  final String? currentCity;
  final void Function(String newCity) cityChanged;

  const ShopsScreenBody({
    required this.cityList,
    required this.cityChanged,
    this.currentCity,
    Key? key,
  }) : super(key: key);

  @override
  State<ShopsScreenBody> createState() => _ShopsScreenBodyState();
}

class _ShopsScreenBodyState extends State<ShopsScreenBody> {
  final pageSwitcherCubit = PageSwitcherCubit();

  late final ShopFilterBloc filterBloc;
  late final List<Filter> filterList;

  List<ShopModel> shopList = [];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.cityList.any((element) => element.name == widget.currentCity)) {
      shopList = widget.cityList
          .firstWhere((element) => element.name == widget.currentCity)
          .shopsRepository
          .shops;
    }

    // for (final city in widget.cityList) {
    //   shopList.addAll(city.shopsRepository.shops);
    // }

    filterList = Filter.getFiltersFromShopList(
      shopList,
    );

    filterBloc = ShopFilterBloc(
      defaultFilter: filterList[0],
      allFilters: filterList,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => filterBloc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Переключатель
          Padding(
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              18,
              StaticData.sidePadding,
              20,
            ),
            child: ShopPageSwitcher(
              onChange: (index) {
                if (currentIndex != index) {
                  currentIndex = index;
                  pageSwitcherCubit.changePage(index);
                }
              },
            ),
          ),

          // Кнопка выбора города
          if (widget.currentCity != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                20,
              ),
              child: DefaultButton(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
                onPressed: () async {
                  // Открыть окно со списком городов
                  final cityName =
                      await Keys.mainNav.currentState!.push<String>(
                    PageRouteBuilder<String>(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CityScreen(
                        citiesWithShops: widget.cityList
                            .map(
                              (e) => e.name,
                            )
                            .toList(),
                      ),
                    ),
                  );

                  if (cityName != null && cityName != widget.currentCity) {
                    widget.cityChanged(cityName);
                  }
                },
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
                          widget.currentCity!,
                          style: AppStyles.h2Bold,
                        ),
                      ),
                    ],
                  ),
                ],
                chevronColor: AppTheme.mineShaft,
              ),
            ),

          // Фильтр магазинов
          Padding(
            padding: const EdgeInsets.only(
              left: StaticData.sidePadding,
              right: StaticData.sidePadding,
              bottom: 20.0,
            ),
            child: ShopFilterWidget(
              filterList: filterList,
            ),
          ),

          // С фильтром
          Expanded(
            child: BlocBuilder<ShopFilterBloc, ShopFilterState>(
              bloc: filterBloc,
              builder: (context, filterState) {
                return BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
                  bloc: pageSwitcherCubit,
                  builder: (context, switherState) {
                    // TODO(Nikolay): Как-то надо сохранять состояние виджета с картой и со списком магазинов.
                    if (switherState is PageSwitcherShowList) {
                      return ShopListAdapter(
                        containerType: ShopContainer,
                        shopList: shopList,
                        state: filterState,
                      );
                    } else {
                      return MapBody(
                        shopList: shopList
                            .where(
                              (shop) =>
                                  filterState is! ShopFilterChange ||
                                  filterState.selectedFilters.any(
                                    (filter) => filter.title == shop.name,
                                  ),
                            )
                            .toList(),
                      );
                    }
                  },
                );
              },
            ),
          ),

          // Без фильтра
          // Expanded(
          //   child: BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
          //     bloc: pageSwitcherCubit,
          //     builder: (context, switherState) {
          //       if (switherState is PageSwitcherShowList) {
          //         return ShopListWidget(
          //           containerType: ShopContainer,
          //           shopList: widget.shopList,
          //         );
          //       } else {
          //         return MapWithButtons(
          //           shopList: widget.shopList,
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

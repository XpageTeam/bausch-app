import 'package:bausch/models/dadata/dadata_response_data_model.dart';
import 'package:bausch/sections/select_optic/map_body.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/select_optic/widgets/shop_container_with_button.dart';
import 'package:bausch/sections/select_optic/widgets/shop_list_widget.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:flutter/material.dart';

class SelectOpticScreenBody extends StatelessWidget {
  final SelectOpticPage currentPage;
  final List<OpticShop> opticShops;
  final void Function(OpticShop selectedShop) onOpticShopSelect;
  final Future<void> Function(DadataResponseDataModel)  onCityDefinitionCallback;

  final String selectButtonText;

  const SelectOpticScreenBody({
    required this.currentPage,
    required this.opticShops,
    required this.onOpticShopSelect,
    required this.selectButtonText,
    required this.onCityDefinitionCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentPage == SelectOpticPage.list
        ? ShopListWidget(
            containerType: ShopContainerWithButton,
            shopList: opticShops,
            onOpticShopSelect: onOpticShopSelect,
          )
        : MapBody(
            selectButtonText: selectButtonText,
            opticShops: opticShops,
            onOpticShopSelect: onOpticShopSelect,
            onCityDefinitionCallback: onCityDefinitionCallback,
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
              );
              // .whenComplete(
              //   () => whenCompleteModalBottomSheet(mapBodyWm),
              // );
            },
          );
    // return IndexedStack(
    //   index: currentPage == SelectOpticPage.list ? 0 : 1,
    //   children: [
    //     ShopListWidget(
    //       containerType: ShopContainerWithButton,
    //       shopList: opticShops,
    //       onOpticShopSelect: onOpticShopSelect,
    //     ),
    //     MapBody(
    //       opticShops: opticShops,
    //       onOpticShopSelect: onOpticShopSelect,
    //       shopsEmptyCallback: (mapBodyWm) {
    //         mapBodyWm.isModalBottomSheetOpen.accept(true);

    //         showModalBottomSheet<dynamic>(
    //           barrierColor: Colors.transparent,
    //           context: context,
    //           builder: (context) => BottomSheetContent(
    //             title: 'Поблизости нет оптик',
    //             subtitle:
    //                 'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
    //             btnText: 'Хорошо',
    //             onPressed: Navigator.of(context).pop,
    //           ),
    //         ).whenComplete(
    //           () => whenCompleteModalBottomSheet(mapBodyWm),
    //         );
    //       },
    //     ),
    //   ],
    // );
  }
}
// import 'package:bausch/models/shop/filter_model.dart';
// import 'package:bausch/models/shop/shop_model.dart';
// import 'package:bausch/repositories/shops/shops_repository.dart';
// import 'package:bausch/sections/order_registration/widgets/order_button.dart';
// import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
// import 'package:bausch/sections/shops/cubits/page_switcher_cubit/page_switcher_cubit_cubit.dart';
// import 'package:bausch/sections/shops/map_body.dart';
// import 'package:bausch/sections/shops/widgets/shop_container.dart';
// import 'package:bausch/sections/shops/widgets/shop_list_adapter.dart';
// import 'package:bausch/sections/shops/widgets/shop_page_switcher.dart';
// import 'package:bausch/static/static_data.dart';
// import 'package:bausch/theme/app_theme.dart';
// import 'package:bausch/theme/styles.dart';
// import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
// import 'package:bausch/widgets/shop_filter_widget/shop_filter_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SelectOpticsScreenBody extends StatefulWidget {
//   final List<CityModel> cityList;
//   final String? currentCity;
//   final void Function(String newCity) cityChanged;

//   const SelectOpticsScreenBody({
//     required this.cityList,
//     required this.cityChanged,
//     this.currentCity,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<SelectOpticsScreenBody> createState() => _SelectOpticsScreenBodyState();
// }

// class _SelectOpticsScreenBodyState extends State<SelectOpticsScreenBody> {
//   final pageSwitcherCubit = PageSwitcherCubit();

//   late ShopFilterBloc filterBloc;
//   late List<Filter> filterList;

//   List<ShopModel> shopList = [];

//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.cityList.any((element) => element.name == widget.currentCity)) {
//       shopList = widget.cityList
//           .firstWhere((element) => element.name == widget.currentCity)
//           .shopsRepository
//           .shops;
//     }

//     // for (final city in widget.cityList) {
//     //   shopList.addAll(city.shopsRepository.shops);
//     // }

//     filterList = Filter.getFiltersFromShopList(
//       shopList,
//     );

//     filterBloc = ShopFilterBloc(
//       defaultFilter: filterList[0],
//       allFilters: filterList,
//     );
//   }

//   @override
//   void didUpdateWidget(covariant SelectOpticsScreenBody oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.cityList.any((element) => element.name == widget.currentCity)) {
//       shopList = widget.cityList
//           .firstWhere((element) => element.name == widget.currentCity)
//           .shopsRepository
//           .shops;
//     }

//     // for (final city in widget.cityList) {
//     //   shopList.addAll(city.shopsRepository.shops);
//     // }

//     filterList = Filter.getFiltersFromShopList(
//       shopList,
//     );

//     filterBloc = ShopFilterBloc(
//       defaultFilter: filterList[0],
//       allFilters: filterList,
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => filterBloc,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Переключатель
//           Padding(
//             padding: const EdgeInsets.fromLTRB(
//               StaticData.sidePadding,
//               18,
//               StaticData.sidePadding,
//               20,
//             ),
//             child: ShopPageSwitcher(
//               callback: (index) {
//                 if (currentIndex != index) {
//                   currentIndex = index;
//                   pageSwitcherCubit.changePage(index);
//                 }
//               },
//             ),
//           ),

//           // Кнопка выбора города
//           if (widget.currentCity != null)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 StaticData.sidePadding,
//                 0,
//                 StaticData.sidePadding,
//                 20,
//               ),
//               child: DefaultButton(
//                 padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
//                 onPressed: () async {
//                   // Открыть окно со списком городов
//                   final cityName =
//                       await Keys.mainNav.currentState!.push<String>(
//                     PageRouteBuilder<String>(
//                       pageBuilder: (context, animation, secondaryAnimation) =>
//                           CityScreen(
//                         citiesWithShops: widget.cityList
//                             .map(
//                               (e) => e.name,
//                             )
//                             .toList(),
//                       ),
//                     ),
//                   );

//                   if (cityName != null && cityName != widget.currentCity) {
//                     widget.cityChanged(cityName);
//                   }
//                 },
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Город',
//                         style: AppStyles.p1Grey,
//                       ),
//                       const SizedBox(
//                         height: 6,
//                       ),
//                       Flexible(
//                         child: Text(
//                           widget.currentCity!,
//                           style: AppStyles.h2Bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 chevronColor: AppTheme.mineShaft,
//               ),
//             ),

//           // Фильтр магазинов
//           Padding(
//             padding: const EdgeInsets.only(
//               left: StaticData.sidePadding,
//               right: StaticData.sidePadding,
//               bottom: 20.0,
//             ),
//             child: ShopFilter(
//               filterList: filterList,
//             ),
//           ),

//           // С фильтром
//           Expanded(
//             child: BlocBuilder<ShopFilterBloc, ShopFilterState>(
//               bloc: filterBloc,
//               builder: (context, filterState) {
//                 return BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
//                   bloc: pageSwitcherCubit,
//                   builder: (context, switherState) {
                     // TODO(Nikolay): Как-то надо сохранять состояние виджета с картой и со списком магазинов.
//                     if (switherState is PageSwitcherShowList) {
//                       return ShopListAdapter(
//                         containerType: ShopContainer,
//                         shopList: shopList,
//                         state: filterState,
//                       );
//                     } else {
//                       return MapBody(
//                         cityList: widget.cityList,
//                         shopList: shopList
//                             .where(
//                               (shop) =>
//                                   filterState is! ShopFilterChange ||
//                                   filterState.selectedFilters.any(
//                                     (filter) => filter.title == shop.name,
//                                   ),
//                             )
//                             .toList(),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),

//           // Без фильтра
//           // Expanded(
//           //   child: BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
//           //     bloc: pageSwitcherCubit,
//           //     builder: (context, switherState) {
//           //       if (switherState is PageSwitcherShowList) {
//           //         return ShopListWidget(
//           //           containerType: ShopContainer,
//           //           shopList: widget.shopList,
//           //         );
//           //       } else {
//           //         return MapWithButtons(
//           //           shopList: widget.shopList,
//           //         );
//           //       }
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

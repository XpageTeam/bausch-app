import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/shops/cubits/page_switcher_cubit/page_switcher_cubit_cubit.dart';
import 'package:bausch/sections/shops/widgets/address_switcher.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/shops/widgets/map_with_buttons.dart';
import 'package:bausch/sections/shops/widgets/shop_list_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:bausch/widgets/shop_filter_widget/shop_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopsScreenBody extends StatefulWidget {
  final List<ShopModel> shopList;

  const ShopsScreenBody({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  State<ShopsScreenBody> createState() => _ShopsScreenBodyState();
}

class _ShopsScreenBodyState extends State<ShopsScreenBody> {
  final pageSwitcherCubit = PageSwitcherCubit();
  int currentIndex = 0;

  late final ShopFilterBloc filterBloc;

  final btnTexts = [
    'Все оптики',
    'ЛинзСервис',
    'Оптика-А',
    'Оптика-Б',
    'Оптика-В',
    'Оптика-Г',
    'Оптика-Д',
    'Оптика-Е',
    'Оптика-Ж'
  ];

  @override
  void initState() {
    super.initState();
    filterBloc = ShopFilterBloc(defaultFilter: btnTexts[0]);
  }

  @override
  void dispose() {
    pageSwitcherCubit.close();
    filterBloc.close();
    super.dispose();
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              0,
              StaticData.sidePadding,
              20,
            ),
            child: DefaultButton(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
              onPressed: () {
                // TODO(Nikolay): Реализовать кнопку.
                showModalBottomSheet<void>(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (context) => BottomSheetContent(
                    title: 'ЛинзСервис',
                    subtitle: 'ул. Задарожная, д. 20, к. 2, ТЦ Океания',
                    phone: '+7 920 325-62-26',
                    site: 'lensservice.ru',
                    additionalInfo:
                        'Скидкой можно воспользоваться в любой из оптик сети.',
                    onPressed: () {},
                    btnText: 'Выбрать эту сеть оптик',
                  ),
                );
              },
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Город',
                      style: AppStyles.p1Grey,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Москва',
                      style: AppStyles.h2Bold,
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
              btnTexts: btnTexts,
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
                        shopList: widget.shopList,
                        state: filterState,
                      );
                    } else {
                      return MapAdapter(
                        shopList: widget.shopList,
                        state: filterState,
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
          //       // TODO(Nikolay): Как-то надо сохранять состояние виджета с картой и со списком магазинов.
          //       if (switherState is PageSwitcherShowList) {
          //         return ShopListWidget(
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

class ShopListAdapter extends StatelessWidget {
  final ShopFilterState state;
  final List<ShopModel> shopList;
  const ShopListAdapter({
    required this.state,
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(Nikolay): Переделать: в этом списке виджеты немного оличаются.
    return ShopListWidget(
      shopList: shopList
          .where(
            (shop) =>
                state is! ShopFilterChange ||
                state.selectedFilters.contains(shop.name),
          )
          .toList(),
    );
  }
}

class MapAdapter extends StatelessWidget {
  final ShopFilterState state;
  final List<ShopModel> shopList;
  const MapAdapter({
    required this.state,
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapWithButtons(
      shopList: shopList
          .where(
            (shop) =>
                state is! ShopFilterChange ||
                state.selectedFilters.contains(shop.name),
          )
          .toList(),
    );
  }
}

class ShopListWidgetOther extends StatelessWidget {
  final List<ShopModel> shopList;
  final ShopFilterState state;
  const ShopListWidgetOther({
    required this.shopList,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        right: StaticData.sidePadding,
        left: StaticData.sidePadding,
        bottom: 20,
      ),
      child: ShopListContent(
        filteredShopList: shopList
            .where(
              (shop) =>
                  state is! ShopFilterChange ||
                  state.selectedFilters.contains(shop.name),
            )
            .toList(),
        state: state,
      ),
    );
  }
}

class ShopListContent extends StatelessWidget {
  final List<ShopModel> filteredShopList;
  final ShopFilterState state;
  const ShopListContent({
    required this.filteredShopList,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: filteredShopList.isEmpty
          ? [
              const Center(
                child: Text(
                  'Пусто',
                  style: AppStyles.p1,
                ),
              )
            ]
          : filteredShopList
              .map(
                (shop) => Container(
                  margin: filteredShopList.last == shop
                      ? null
                      : const EdgeInsets.only(bottom: 4),
                  child: ShopContainer(shop: shop),
                ),
              )
              .toList(),
    );
  }
}

class ShopContainer extends StatelessWidget {
  final ShopModel shop;
  const ShopContainer({
    required this.shop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(StaticData.sidePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shop.name,
            style: AppStyles.h2Bold,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            shop.address,
            style: AppStyles.p1,
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              // TODO(Nikolay): Реализовать нажатие по номеру телефона.
            },
            child: Text(
              shop.phone,
              style: AppStyles.p1.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.turquoiseBlue,
                decorationThickness: 2,
              ),
            ),
          ),
          if (shop.site != null) ...[
            const SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                // TODO(Nikolay): Реализовать переход по ссылке.
              },
              child: Text(
                shop.site!,
                style: AppStyles.p1.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.turquoiseBlue,
                  decorationThickness: 2,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

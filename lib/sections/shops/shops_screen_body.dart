import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/shops/cubits/page_switcher_cubit/page_switcher_cubit_cubit.dart';
import 'package:bausch/sections/shops/widgets/address_switcher.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/shops/widgets/map_adapter.dart';
import 'package:bausch/sections/shops/widgets/shop_container.dart';
import 'package:bausch/sections/shops/widgets/shop_list_adapter.dart';
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
    'Оптика-Ж',
  ];

  int currentIndex = 0;

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
                        containerType: ShopContainer,
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

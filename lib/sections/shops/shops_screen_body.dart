import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/shops/cubits/page_switcher_cubit/page_switcher_cubit_cubit.dart';
import 'package:bausch/sections/shops/widgets/address_switcher.dart';
import 'package:bausch/sections/shops/widgets/map_with_buttons.dart';
import 'package:bausch/sections/shops/widgets/shop_list_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopsScreenBody extends StatefulWidget {
  final List<ShopModel> shopList;

  ShopsScreenBody({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  State<ShopsScreenBody> createState() => _ShopsScreenBodyState();
}

class _ShopsScreenBodyState extends State<ShopsScreenBody> {
  final _pageSwitcherCubit = PageSwitcherCubit();
  int _currentIndex = 0;
  @override
  void dispose() {
    _pageSwitcherCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //* Переключатель
        Padding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            18,
            StaticData.sidePadding,
            20,
          ),
          child: ShopPageSwitcher(
            onChange: (index) {
              if (_currentIndex != index) {
                _currentIndex = index;
                _pageSwitcherCubit.changePage(index);
              }
            },
          ),
        ),

        //* Кнопка выбора города
        Padding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            18,
            StaticData.sidePadding,
            20,
          ),
          child: DefaultButton(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
            onPressed: () {
              // TODO(Nikolay): Реализовать кнопку.
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

        //* Карта -> Список Магазинов
        Expanded(
          child: BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
            bloc: _pageSwitcherCubit,
            builder: (context, state) {
              // TODO(Nikolay): Как-то надо сохранять состояние виджета с картой и со списком магазинов.
              if (state is PageSwitcherShowList) {
                return ShopListWidget(
                  shopList: widget.shopList,
                );
              } else {
                return MapWithButtons(
                  shopList: widget.shopList,
                );
              }
            },
          ),
        ),

        // Expanded(
        //   child: BlocBuilder<PageSwitcherCubit, PageSwitcherState>(
        //     bloc: _pageSwitcherCubit,
        //     builder: (context, state) {
        //       // TODO(Nikolay): Как-то надо сохранять состояние виджета с картой и со списком магазинов.
        //       return IndexedStack(
        //         index: state is PageSwitcherShowList ? 1 : 0,
        //         children: [
        //           MapWithButtons(
        //             shopList: widget.shopList,
        //           ),
        //           ShopListWidget(
        //             shopList: widget.shopList,
        //           ),
        //         ],
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

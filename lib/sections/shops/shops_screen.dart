import 'dart:ui';

import 'package:bausch/sections/shops/cubits/shop_list_cubit/shoplist_cubit.dart';
import 'package:bausch/sections/shops/providers/shop_list_bloc_provider.dart';
import 'package:bausch/sections/shops/shops_screen_body.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/default_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* Макет:
//* Program
//* list
class ShopsScreen extends StatelessWidget {
  String currentCity = 'Москва';
  ShopsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Адреса оптик',
        backgroundColor: AppTheme.mystic,
      ),
      body: ShopListCubitProvider(
        cityName: currentCity,
        child: BlocConsumer<ShopListCubit, ShopListState>(
          listener: (context, state) {
            if (state is ShopListSuccess && state.shopList.isEmpty) {
              showModalBottomSheet<dynamic>(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) => BottomSheetContent(
                  title: 'Поблизости нет оптик',
                  subtitle:
                      'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
                  btnText: 'Хорошо',
                  onPressed: () {
                    // TODO(Nikolay): Реализовать onPressed.
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ShopListSuccess) {
              return ShopsScreenBody(
                currentCity: currentCity,
                shopList: state.shopList,
                cityChanged: (newCity) {
                  BlocProvider.of<ShopListCubit>(context)
                      .loadShopListByCity(newCity);
                  currentCity = newCity;
                },
              );
            }

            if (state is ShopListFailed) {
              return Center(
                child: DefaultInfoWidget(
                  title: 'Ошибка',
                  subtitle: 'Описание ошибки',
                  onPressed: () => BlocProvider.of<ShopListCubit>(context)
                      .loadShopListByCity(currentCity),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppTheme.turquoiseBlue,
              ),
            );
          },
        ),
      ),
    );
  }
}

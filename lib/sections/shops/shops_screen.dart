import 'dart:ui';

import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/shops/cubits/shop_list_cubit/shoplist_cubit.dart';
import 'package:bausch/sections/shops/providers/shop_list_bloc_provider.dart';
import 'package:bausch/sections/shops/shops_screen_body.dart';
import 'package:bausch/sections/shops/widgets/shop_list_empty_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/default_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* Макет:
//* Program
//* list
class ShopsScreen extends StatelessWidget {
  const ShopsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      //* Включаю прозрачность статус бара
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        appBar: const DefaultAppBar(
          title: 'Адреса оптик',
          backgroundColor: AppTheme.mystic,
        ),
        body: ShopListCubitProvider(
          child: BlocConsumer<ShopListCubit, ShopListState>(
            listener: (context, state) {
              if (state is ShopListSuccess && state.shopList.isEmpty) {
                showModalBottomSheet<dynamic>(
                  barrierColor: Colors.transparent,
                  context: context,
                  // TODO(Nikolay): Как-то вынести в универсальный виджет.
                  builder: (context) => const ShopListEmptyBottomSheet(),
                );
              }
            },
            builder: (context, state) {
              if (state is ShopListSuccess) {
                return ShopsScreenBody(
                  shopList: state.shopList,
                );
              }

              if (state is ShopListFailed) {
                return Center(
                  child: DefaultInfoWidget(
                    title: 'Ошибка',
                    subtitle: 'Описание ошибки',
                    onPressed: () =>
                        BlocProvider.of<ShopListCubit>(context).loadShopList(),
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
      ),
    );
  }
}

import 'dart:ui';

import 'package:bausch/sections/shops/blocs/shop_list_bloc/shop_list_bloc.dart';
import 'package:bausch/sections/shops/providers/shop_list_bloc_provider.dart';
import 'package:bausch/sections/shops/shop_list_body_success.dart';
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
  const ShopsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      //* Включаю прозрачность статус бара
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: ShopListBlocProvider(
        child: Scaffold(
          backgroundColor: AppTheme.mystic,
          appBar: const DefaultAppBar(
            title: 'Адреса оптик',
            backgroundColor: AppTheme.mystic,
          ),
          body: BlocBuilder<ShopListBloc, ShopListState>(
            builder: (context, state) {
              if (state is ShopListSuccess) {
                return ShopScreenBodySuccess(
                  shopList: state.shopList,
                );
              }

              if (state is ShopListFailed) {
                return Center(
                  child: DefaultInfoWidget(
                    title: 'Ошибка',
                    subtitle: 'Описание ошибки',
                    onPressed: () => BlocProvider.of<ShopListBloc>(context)
                        .add(ShopsListLoad()),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ),
    );
  }
}

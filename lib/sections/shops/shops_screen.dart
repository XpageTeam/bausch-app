import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/shops/cubits/shop_list_cubit/shoplist_cubit.dart';
import 'package:bausch/sections/shops/providers/shop_list_bloc_provider.dart';
import 'package:bausch/sections/shops/shops_screen_body.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/default_info_widget.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//* Макет:
//* Program
//* list
class ShopsScreen extends StatefulWidget {
  const ShopsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  String? currentCity;

  @override
  void initState() {
    super.initState();
    // TODO(Nikolay): Вернуть проверку авторизации пользователя.
    // if (Provider.of<AuthWM>(context, listen: false).authStatus.value ==
    //     AuthStatus.authenticated) {
    currentCity = Provider.of<UserWM>(
      context,
      listen: false,
    ).userData.value.data?.user.city;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Адреса оптик',
        backgroundColor: AppTheme.mystic,
      ),
      body: ShopListCubitProvider(
        city: currentCity,
        child: BlocConsumer<ShopListCubit, ShopListState>(
          listener: (context, state) {
            // if (state is ShopListSuccess &&
            //     state.cityList.isNotEmpty &&
            //     !state.cityList.any(
            //       (element) => element.name == currentCity,
            //     )) {
            //   // Если нет магазинов в городе, который указан у пользователя, то показать окно
            // showModalBottomSheet<dynamic>(
            //   barrierColor: Colors.transparent,
            //   context: context,
            //   builder: (context) => BottomSheetContent(
            //     title: 'Поблизости нет оптик',
            //     subtitle:
            //         'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
            //     btnText: 'Хорошо',
            //     onPressed: Navigator.of(context).pop,
            //   ),
            // );

            //   // Сделать первый по списку город текущим
            //   currentCity = sort(state.cityList)?[0].name;
            //   // Повторный запрос
            //   BlocProvider.of<ShopListCubit>(context).loadShopList();
            // }
          },
          builder: (context, state) {
            if (state is ShopListSuccess) {
              final city = BlocProvider.of<ShopListCubit>(context).city;
              debugPrint('city: $city');
              return ShopsScreenBody(
                cityList: state.cityList,
                currentCity: city,

                // currentCity ??

                cityChanged: (newCity) {
                  BlocProvider.of<ShopListCubit>(context)
                    ..city = newCity
                    ..loadShopList();
                  // currentCity = newCity;
                },
              );
            }

            if (state is ShopListFailed) {
              return Center(
                child: DefaultInfoWidget(
                  title: 'Ошибка',
                  subtitle: 'Описание ошибки',
                  onPressed:
                      BlocProvider.of<ShopListCubit>(context).loadShopList,
                ),
              );
            }

            return const Center(
              // child: CircularProgressIndicator.adaptive(
              //   backgroundColor: AppTheme.turquoiseBlue,
              // ),
              child: AnimatedLoader(),
            );
          },
        ),
      ),
    );
  }

  List<CityModel>? sort(List<CityModel> cities) {
    if (cities.isEmpty) return null;
    return cities..sort((a, b) => a.name.compareTo(b.name));
  }
}

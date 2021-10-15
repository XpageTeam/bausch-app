import 'dart:ui';

import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/shops/cubits/shop_list_cubit/shoplist_cubit.dart';
import 'package:bausch/sections/shops/providers/shop_list_bloc_provider.dart';
import 'package:bausch/sections/shops/shops_screen_body.dart';
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

      // TODO(Nikolay): Возможно тоже стоит убрать этот виджет и написать здесь просто blocprovider.
      child: ShopListCubitProvider(
        child: Scaffold(
          backgroundColor: AppTheme.mystic,
          appBar: const DefaultAppBar(
            title: 'Адреса оптик',
            backgroundColor: AppTheme.mystic,
          ),
          body: BlocConsumer<ShopListCubit, ShopListState>(
            listener: (context, state) {
              if (state is ShopListSuccess && state.shopList.isEmpty) {
                showModalBottomSheet<dynamic>(
                  barrierColor: Colors.transparent,
                  context: context,
                  // TODO(Nikolay): Как-то вынести в универсальный виджет.
                  builder: (context) => Container(
                    padding: const EdgeInsets.fromLTRB(
                      StaticData.sidePadding,
                      4,
                      StaticData.sidePadding,
                      24,
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //* Чёрная пимпочка
                        Center(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.only(
                              bottom: 2,
                            ),
                            width: MediaQuery.of(context).size.width / 9.87,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: AppTheme.mineShaft,
                            ),
                          ),
                        ),

                        //* Кнопка закрыть
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: NormalIconButton(
                            backgroundColor: AppTheme.mystic,
                            onPressed: Navigator.of(context).pop,
                            icon: const Icon(
                              Icons.close,
                              color: AppTheme.mineShaft,
                            ),
                          ),
                        ),

                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Поблизости нет оптик',
                              style: AppStyles.h2Bold,
                            ),
                          ),
                        ),

                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Text(
                              'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
                              style: AppStyles.p1,
                            ),
                          ),
                        ),

                        BlueButton(
                          onPressed: () {
                            // TODO(Nikolay): Реализовать кнопку в контейнере с магазином.
                          },
                          children: const [
                            Text(
                              'Хорошо',
                              style: AppStyles.h2Bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
          // body: BlocBuilder<ShopListCubit, ShopListState>(
          //   builder: (context, state) {
          //   if (state is ShopListSuccess) {
          //     return ShopsScreenBody(
          //       shopList: state.shopList,
          //     );
          //   }

          //   if (state is ShopListFailed) {
          //     return Center(
          //       child: DefaultInfoWidget(
          //         title: 'Ошибка',
          //         subtitle: 'Описание ошибки',
          //         onPressed: () =>
          //             BlocProvider.of<ShopListCubit>(context).loadShopList(),
          //       ),
          //     );
          //   }

          //   return const Center(
          //     child: CircularProgressIndicator.adaptive(
          //       backgroundColor: AppTheme.turquoiseBlue,
          //     ),
          //   );
          // },
          // ),
        ),
      ),
    );
  }
}

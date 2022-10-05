import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/packages/alphabet_scroll_view/lib/alphabet_scroll_view.dart';
import 'package:bausch/sections/loader/loader_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/wm/city_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityScreen extends CoreMwwmWidget<CityScreenWM> {
  final List<String>? citiesWithShops;
  final List<String> withFavoriteItems;
  CityScreen({
    required this.withFavoriteItems,
    Key? key,
    this.citiesWithShops,
  }) : super(
          widgetModelBuilder: (context) => CityScreenWM(
            const WidgetModelDependencies(),
            context: context,
            citiesWithShops: citiesWithShops,
          ),
          key: key,
        );

  @override
  _CityScreenState createWidgetState() => _CityScreenState();
}

class _CityScreenState extends WidgetState<CityScreen, CityScreenWM> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: close,
      child: ResponsiveWrapper.builder(
        EntityStateBuilder<List<String>>(
          streamedState: wm.citiesList,
          loadingChild: const Scaffold(
            appBar: DefaultAppBar(
              title: 'Город',
              backgroundColor: AppTheme.mystic,
            ),
            body: LoaderScreen(),
          ),
          errorBuilder: (_, e) {
            e as CustomException;

            return Scaffold(
              appBar: const DefaultAppBar(
                title: 'Город',
                backgroundColor: AppTheme.mystic,
              ),
              body: ErrorPage(
                title: e.title,
                // subtitle: e.subtitle,
                buttonText: 'Обновить',
                buttonCallback: wm.citiesListReloadAction,
              ),
            );
          },
          builder: (_, citiesList) {
            return Scaffold(
              appBar: DefaultAppBar(
                title: 'Город',
                backgroundColor: AppTheme.mystic,
                onPop: close,
              ),
              body: StreamedStateBuilder<bool>(
                streamedState: wm.isSearchActive,
                builder: (_, isSearchActive) {
                  return StreamedStateBuilder<bool>(
                    streamedState: wm.canCompleteSearch,
                    builder: (_, state) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: StaticData.sidePadding,
                          right: StaticData.sidePadding,
                          bottom: state && isSearchActive ? 70 : 0,
                        ),
                        child: SafeArea(
                          top: false,
                          bottom: state && isSearchActive,
                          child: Column(
                            children: [
                              NativeTextInput(
                                labelText: 'Найти город',
                                controller: wm.citiesFilterController,
                              ),
                              Flexible(
                                child: StreamedStateBuilder<List<String>>(
                                  streamedState: wm.filteredCitiesList,
                                  builder: (_, citiesList) {
                                    if (citiesList.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'Поиск не принёс результатов :(',
                                          style: AppStyles.h2,
                                        ),
                                      );
                                    }

                                    return AlphabetScrollView(
                                      itemExtent: 50,
                                      list: citiesList.map((city) {
                                        return AlphaModel(city);
                                      }).toList(),
                                      selectedTextStyle: AppStyles.h1,
                                      unselectedTextStyle: AppStyles.h2,
                                      favoriteItems: widget.withFavoriteItems,
                                      topWidget: widget.withFavoriteItems
                                              .contains('Вся РФ')
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: Warning.warning(
                                                'Если вы не нашли свой город в списке, вы можете выбрать «Вся РФ» – эти магазины осуществляют доставку по всей России',
                                              ),
                                            )
                                          : null,
                                      // selectedLetterTextStyle: AppStyles.p1,
                                      // unselectedLetterTextStyle: TextStyle(
                                      //   color: AppTheme.mineShaft,
                                      //   fontWeight: FontWeight.w400,
                                      //   fontSize: 12.sp,
                                      //   height: 16 / 12,
                                      //   fontFamily: 'Euclid Circular A',
                                      // ),
                                      itemBuilder: (context, i, cityName) {
                                        return InkWell(
                                          onTap: () {
                                            close(cityName);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                cityName,
                                                style: AppStyles.h2,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: StreamedStateBuilder<bool>(
                  streamedState: wm.isSearchActive,
                  builder: (_, isSearchActive) {
                    return StreamedStateBuilder<bool>(
                      streamedState: wm.canCompleteSearch,
                      builder: (_, state) {
                        if (state && isSearchActive) {
                          return BlueButtonWithText(
                            text: 'Выбрать',
                            onPressed: wm.selectCityAction,
                          );
                        }

                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          },
        ),
        defaultScale: true,
        minWidth: 375,
      ),
    );
  }

  Future<bool> close([String? cityName]) async {
    Navigator.of(context).pop(cityName);

    return Future(() => false);
  }
}

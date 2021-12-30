import 'package:bausch/models/city/dadata_city.dart';
import 'package:bausch/packages/alphabet_scroll_view/lib/alphabet_scroll_view.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/wm/city_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityScreen extends CoreMwwmWidget<CityScreenWM> {
  final List<String>? citiesWithShops;
  CityScreen({
    Key? key,
    this.citiesWithShops,
  }) : super(
          widgetModelBuilder: (context) => CityScreenWM(
            const WidgetModelDependencies(),
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
    return EntityStateBuilder(
      streamedState: wm.citiesList,
      loadingChild: const LoaderScreen(),
      builder: (_, __) {
        return Scaffold(
          appBar: const DefaultAppBar(
            title: 'Город',
            backgroundColor: AppTheme.mystic,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: StaticData.sidePadding,
              right: StaticData.sidePadding,
            ),
            child: Column(
              children: [
                NativeTextInput(
                  labelText: 'Найти город',
                  controller: wm.citiesFilterController,
                ),

                // TODO(Nikita): Добавить сверху избранные города и выбранный
                Flexible(
                  child: StreamedStateBuilder<List<DadataCity>>(
                    streamedState: wm.filteredCitiesList,
                    builder: (_, cities) {
                      return AlphabetScrollView(
                        itemExtent: 50,
                        list: cities.map((city) {
                          return AlphaModel(city.name);
                        }).toList(),
                        selectedTextStyle: AppStyles.h1,
                        unselectedTextStyle: AppStyles.h2,
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
                              Navigator.of(context).pop(cityName);
                            },
                            borderRadius: BorderRadius.circular(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
  }
}

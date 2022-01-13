import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/shop_filter.dart';
import 'package:bausch/sections/select_optic/widgets/shop_page_switcher.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/test_select_optic/test_map.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class TestSelectOpticScreen extends CoreMwwmWidget<TestSelectOpticScreenWM> {
  TestSelectOpticScreen({
    required List<OpticCity> opticCities,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) =>
              TestSelectOpticScreenWM(context, opticCities),
        );

  @override
  WidgetState<TestSelectOpticScreen, TestSelectOpticScreenWM>
      createWidgetState() => _TestSelectOpticScreenState();
}

class _TestSelectOpticScreenState
    extends WidgetState<TestSelectOpticScreen, TestSelectOpticScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Адреса оптик',
        backgroundColor: AppTheme.mystic,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Переключение страницы
          Padding(
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              18,
              StaticData.sidePadding,
              20,
            ),
            child: ShopPageSwitcher(
              onSwitch: wm.switchPageAction,
            ),
          ),

          //* Выбор города
          EntityStateBuilder<String>(
            streamedState: wm.currentCityStreamed,
            builder: (context, currentCity) => Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                20,
              ),
              child: _SelectCityButton(
                city: currentCity,
                onPressed: wm.selectCityAction,
              ),
            ),
          ),

          //* Переключение фильтра
          EntityStateBuilder<List<Filter>>(
            streamedState: wm.newFiltersStreamed,
            builder: (_, newFilters) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: StaticData.sidePadding,
                  right: StaticData.sidePadding,
                  bottom: 20.0,
                ),
                child: ShopFilterWidget(
                  filters: newFilters,
                  onFiltersChanged: wm.filtersOnChanged,
                ),
              );
            },
          ),

          //* Карта
          Expanded(
            child: EntityStateBuilder<String>(
              streamedState: wm.currentCityStreamed,
              builder: (_, currentCity) =>
                  StreamedStateBuilder<SelectOpticPage>(
                streamedState: wm.currentPageStreamed,
                builder: (_, currentPage) => currentPage == SelectOpticPage.map
                    ? TestMap(
                        widgetModelBuilder: (context) => wm.testMapWM,
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TestSelectOpticScreenWM extends WidgetModel {
  final BuildContext context;
  late final TestMapWM testMapWM;

  final currentCityStreamed = EntityStreamedState<String>();
  final newFiltersStreamed = EntityStreamedState<List<Filter>>();
  final currentPageStreamed =
      StreamedState<SelectOpticPage>(SelectOpticPage.map);

  final changeCityAction = StreamedAction<String>();
  final filtersOnChanged = StreamedAction<List<Filter>>();
  final switchPageAction = StreamedAction<SelectOpticPage>();

  final selectCityAction = VoidAction();

  final List<OpticCity> opticCities;
  List<Filter> selectedFilters = [];

  TestSelectOpticScreenWM(this.context, this.opticCities)
      : super(
          const WidgetModelDependencies(),
        );
  @override
  void onLoad() {
    if (opticCities.isEmpty) {
      _loadOpticCities();
    }
    _initCurrentCity();
    _updateFilters();

    _initTestMapWM();

    super.onLoad();
  }

  @override
  void onBind() {
    selectCityAction.bind(
      (_) => _selectCity(),
    );

    changeCityAction.bind(_updateCity);

    filtersOnChanged.bind(
      (selectedFilters) => _filterShops(selectedFilters!),
    );

    switchPageAction.bind(
      (newPage) {
        currentPageStreamed.accept(newPage!);

        if (newPage == SelectOpticPage.map) {
          final currentCity = currentCityStreamed.value.data;
          if (currentCity != null &&
              opticCities.any((city) => city.title == currentCity)) {
            testMapWM.setCenterAction(_getShopsByCurrentCity());
          }
        }
      },
    );

    super.onBind();
  }

  void _initTestMapWM() {
    // TODO(Nikolay): Закидывать список магазинов.
    testMapWM = TestMapWM(context, []);
  }

  Future<void> _selectCity() async {
    final newCity = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(
          citiesWithShops: opticCities.map((e) => e.title).toList(),
        ),
      ),
    );

    _updateCity(newCity);
    _updateFilters();
    _updateMap();
  }

  void _updateFilters() {
    debugPrint('wasd: _updateFilters()');
    if (opticCities.any(
      (city) => city.title == currentCityStreamed.value.data,
    )) {
      final newFilters = Filter.getFiltersFromOpticList(
        opticCities
            .firstWhere(
              (city) => city.title == currentCityStreamed.value.data,
            )
            .optics,
      );
      newFiltersStreamed.content(newFilters);
    } else {
      newFiltersStreamed.error();
    }
  }

  void _updateCity(String? newCity) {
    if (newCity == null || newCity == currentCityStreamed.value.data) {
      return;
    }
    currentCityStreamed.content(newCity);
  }

  void _filterShops(List<Filter> selectedFilters) {
    final currentCity = currentCityStreamed.value.data;

    if (currentCity != null &&
        opticCities.any((city) => city.title == currentCity)) {
      final shops = _getShopsByCurrentCity();
      final filteredShops = selectedFilters.first.id == 0
          ? shops
          : shops
              .where(
                (shop) => selectedFilters.any(
                  (filter) => filter.title == shop.title,
                ),
              )
              .toList();
      testMapWM.updateMapObjectsAction(filteredShops);
    }
  }

  void _updateMap() {
    debugPrint('wasd: _updateMap()');

    final currentCity = currentCityStreamed.value.data;
    if (currentCity != null &&
        opticCities.any((city) => city.title == currentCity)) {
      final shops = _getShopsByCurrentCity();
      testMapWM.updateMapObjectsAction(shops);
      testMapWM.setCenterAction(shops);
    }
  }

  List<OpticShop> _getShopsByCurrentCity() {
    // TODO(Nikolay): Закидывать список магазинов.
    final currentCity = currentCityStreamed.value.data;
    return opticCities
        .firstWhere((city) => city.title == currentCity)
        .optics
        .fold<List<OpticShop>>(
      [],
      (arr, optic) => arr..addAll(optic.shops),
    );
  }

  void _initCurrentCity() {
    final userCity = Provider.of<UserWM>(context, listen: false)
        .userData
        .value
        .data
        ?.user
        .city;

    if (userCity != null) {
      currentCityStreamed.content(userCity);
      if (opticCities.any((city) => city.title != userCity)) {
        // showModalBottomSheet<void>(
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
      }
    } else {
      currentCityStreamed.error();
    }
  }

  void _loadOpticCities() {
    debugPrint('wasd: _loadOpticCities()');
  }
}

class _SelectCityButton extends StatelessWidget {
  final String city;
  final VoidCallback onPressed;
  const _SelectCityButton({
    required this.city,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        splashColor: AppTheme.mystic,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Город',
                      style: AppStyles.p1Grey,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Flexible(
                      child: Text(
                        city,
                        style: AppStyles.h2Bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.mineShaft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/select_optic/select_optics_screen_body.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/certificate_filter_section.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/certificate_filter_section_model.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/shop_filter.dart';
import 'package:bausch/sections/select_optic/widgets/shop_page_switcher.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Макет:
//* Program
//* list
class SelectOpticScreen extends CoreMwwmWidget<SelectOpticScreenWM> {
  final String selectButtonText;
  final bool isCertificateMap;

  SelectOpticScreen({
    this.selectButtonText = 'Выбрать эту сеть оптик',
    this.isCertificateMap = true,
    List<OpticCity>? cities,
    String? initialCity,
    void Function(Optic optic, String city, OpticShop? shop)? onOpticSelect,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => SelectOpticScreenWM(
            context: context,
            initialCities: cities ?? [],
            initialCity: initialCity,
            isCertificateMap: isCertificateMap,
            onOpticSelect: onOpticSelect,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<SelectOpticScreenWM>, SelectOpticScreenWM>
      createWidgetState() => _SelectOpticScreenState();
}

class _SelectOpticScreenState
    extends WidgetState<SelectOpticScreen, SelectOpticScreenWM> {
  List<bool> activeLensTypes = [false, false, false];
  List<bool> additionalFilters = [false, false];
  int additionalFiltersCount = 0;
  int activeLensCount = 0;
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Provider.value(
        value: wm,
        child: Scaffold(
          backgroundColor: AppTheme.mystic,
          appBar: const DefaultAppBar(
            title: 'Адреса оптик',
            backgroundColor: AppTheme.mystic,
          ),
          resizeToAvoidBottomInset: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Переключатель (карта/список)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  StaticData.sidePadding,
                  15,
                  StaticData.sidePadding,
                  22,
                ),
                child: StreamedStateBuilder<SelectOpticPage>(
                  streamedState: wm.currentPageStreamed,
                  builder: (_, page) {
                    return ShopPageSwitcher(
                      initialType: page,
                      callback: wm.switchPage,
                    );
                  },
                ),
              ),

              // Кнопка выбора города
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
                    onPressed: wm.selectCity,
                  ),
                ),
              ),

              // Кнопки фильтра магазинов
              if (widget.isCertificateMap)
                StreamedStateBuilder<CertificateFilterSectionModel?>(
                  streamedState: wm.certificateFilterSectionModelState,
                  builder: (_, certificateFilterSectionModel) {
                    return certificateFilterSectionModel == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                            ),
                            child: CertificateFiltersSection(
                              model: certificateFilterSectionModel,
                            ),
                          );
                  },
                )
              else
                StreamedStateBuilder<List<Optic>>(
                  streamedState: wm.opticsByCityStreamed,
                  builder: (_, optics) {
                    final filters = Filter.getFiltersFromOpticList(
                      optics,
                    );
                    // debugPrint('optics: ${optics.length}');
                    return StreamedStateBuilder<List<Filter>>(
                      streamedState: wm.selectedFiltersState,
                      builder: (_, selectedFilters) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            // left: StaticData.sidePadding,
                            // right: StaticData.sidePadding,
                            bottom: 20.0,
                          ),
                          child: ShopFilterWidget(
                            filters: filters,
                            selectedFilters: selectedFilters,
                            onTap: wm.onFilterTap,
                          ),
                        );
                      },
                    );
                  },
                ),

              // Карта/список
              Expanded(
                child: StreamedStateBuilder<SelectOpticPage>(
                  streamedState: wm.currentPageStreamed,
                  builder: (_, currentPage) =>
                      EntityStateBuilder<List<OpticShop>>(
                    streamedState: wm.filteredOpticShopsStreamed,
                    loadingChild: const Center(
                      child: AnimatedLoader(),
                    ),
                    errorBuilder: (context, e) {
                      final ex = e as CustomException;
                      //debugPrint(ex.subtitle);
                      showDefaultNotification(
                        title: ex.title,
                        // subtitle: ex.subtitle,
                      );

                      return const SizedBox();
                    },
                    builder: (_, opticShops) => SelectOpticScreenBody(
                      selectButtonText: widget.selectButtonText,
                      currentPage: currentPage,
                      opticShops: opticShops,
                      isCertificateMap: widget.isCertificateMap,
                      onCityDefinitionCallback:
                          (_) async {}, //wm.onCityDefinition,
                      initialOptic: wm.selectedOpticShop,
                      onOpticShopSelectList: wm.showOpticOnMap,
                      onOpticShopSelectMap: wm.selectOptic,

                      //  (selectedShop) =>
                      //     wm.onOpticShopSelectAction(
                      //   OpticShopParams(
                      //     selectedShop,
                      //     (optic, shop) => widget.onOpticSelect(
                      //       optic,
                      //       wm.currentCityStreamed.value.data ?? '',
                      //       shop,
                      //     ),
                      //   ),
                      // ),
                      // whenCompleteModalBottomSheet: (mapBodyWm) {
                      //   wm.setFirstCity();

                      //   Future.delayed(
                      //     const Duration(milliseconds: 10),
                      //     () {
                      //       mapBodyWm
                      //         ..isModalBottomSheetOpen.accept(false)
                      //         ..setCenterAction(
                      //           wm.filteredOpticShopsStreamed.value.data!,
                      //         );
                      //     },
                      //   );
                      // },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      defaultScale: true,
      minWidth: 375,
    );
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
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: city.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/map-marker.png',
                              height: 16,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              'Город',
                              style: AppStyles.h2Bold,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
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

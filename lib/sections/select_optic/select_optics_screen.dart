import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/select_optic/certificate_filter_screen.dart';
import 'package:bausch/sections/select_optic/select_optics_screen_body.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/choose_types_sheet.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/shop_filter.dart';
import 'package:bausch/sections/select_optic/widgets/shop_page_switcher.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Макет:
//* Program
//* list
class SelectOpticScreen extends CoreMwwmWidget<SelectOpticScreenWM> {
  final void Function(Optic optic, String city, OpticShop? shop) onOpticSelect;
  final String selectButtonText;

  SelectOpticScreen({
    required this.onOpticSelect,
    this.selectButtonText = 'Выбрать эту сеть оптик',
    List<OpticCity>? cities,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => SelectOpticScreenWM(
            context: context,
            initialCities: cities,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<SelectOpticScreenWM>, SelectOpticScreenWM>
      createWidgetState() => _SelectOpticScreenState();
}

class _SelectOpticScreenState
    extends WidgetState<SelectOpticScreen, SelectOpticScreenWM> {
  // TODO(pavlov): верстаю сертификатные изменения
  final bool isCertificateMap = true;
  List<bool> activeLensTypes = [false, false, false];
  List<bool> additionalFilters = [false, false];
  int additionalFiltersCount = 0;
  int activeLensCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Адреса оптик',
        backgroundColor: AppTheme.mystic,
      ),
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
            child: ShopPageSwitcher(
              callback: wm.switchAction,
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
                onPressed: wm.selectCityAction,
              ),
            ),
          ),

          // Кнопки фильтра магазинов
          if (isCertificateMap)
            Padding(
              padding: const EdgeInsets.only(
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (activeLensCount > 0)
                    BlueButton(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Мега крутые',
                              style: AppStyles.h2,
                            ),
                            if (activeLensCount > 1) ...[
                              const SizedBox(width: 8),
                              WhiteContainerWithRoundedCorners(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 6),
                                    Text(
                                      'Еще ${activeLensCount - 1}',
                                      style: AppStyles.h2,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 2),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      onPressed: () async {
                        await showModalBottomSheet<num>(
                          isScrollControlled: true,
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.8),
                          builder: (context) {
                            return ChooseTypesSheet(
                              onSendUpdate: (
                                newActiveLenses,
                              ) {
                                setState(() {
                                  activeLensCount = 0;
                                  activeLensTypes = newActiveLenses;
                                  for (final element in activeLensTypes) {
                                    if (element) {
                                      activeLensCount++;
                                    }
                                  }
                                });

                                Navigator.of(context).pop();
                              },
                              typesStatus: activeLensTypes,
                            );
                          },
                        );
                      },
                    )
                  else
                    WhiteContainerWithRoundedCorners(
                      padding: const EdgeInsets.all(8),
                      onTap: () async {
                        await showModalBottomSheet<num>(
                          isScrollControlled: true,
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.8),
                          builder: (context) {
                            return ChooseTypesSheet(
                              onSendUpdate: (
                                newActiveLenses,
                              ) {
                                setState(() {
                                  activeLensCount = 0;
                                  activeLensTypes = newActiveLenses;
                                  for (final element in activeLensTypes) {
                                    if (element) {
                                      activeLensCount++;
                                    }
                                  }
                                });

                                Navigator.of(context).pop();
                              },
                              typesStatus: activeLensTypes,
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Подбор линз',
                            style: AppStyles.h2,
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  WhiteContainerWithRoundedCorners(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder<String>(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CertificateFilterScreen(
                            typesStatus: activeLensTypes,
                            additionalFilters: additionalFilters,
                            onSendUpdate: (currentTypes, currentAdditions) {
                              setState(() {
                                activeLensCount = 0;
                                additionalFiltersCount = 0;
                                activeLensTypes = currentTypes;
                                additionalFilters = currentAdditions;
                                for (final element in activeLensTypes) {
                                  if (element) {
                                    activeLensCount++;
                                  }
                                }
                                for (final element in additionalFilters) {
                                  if (element) {
                                    additionalFiltersCount++;
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(StaticData.sidePadding),
                          child: Image.asset(
                            'assets/icons/filter.png',
                            height: 14,
                            width: 14,
                          ),
                        ),
                        if (additionalFiltersCount == 0)
                          const SizedBox.shrink()
                        else
                          Container(
                            width: 19,
                            height: 19,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.turquoiseBlue,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                additionalFiltersCount.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Euclid Circular A',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            StreamedStateBuilder<List<Optic>>(
              streamedState: wm.opticsByCityStreamed,
              builder: (_, optics) {
                final filters = Filter.getFiltersFromOpticList(
                  optics,
                );
                return Padding(
                  padding: const EdgeInsets.only(
                    left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                    bottom: 20.0,
                  ),
                  child: ShopFilterWidget(
                    filters: filters,
                    callback: wm.filtersOnChanged,
                  ),
                );
              },
            ),

          // Карта/список
          Expanded(
            child: StreamedStateBuilder<SelectOpticPage>(
              streamedState: wm.currentPageStreamed,
              builder: (_, currentPage) => EntityStateBuilder<List<OpticShop>>(
                streamedState: wm.filteredOpticShopsStreamed,
                loadingChild: const Center(
                  child: AnimatedLoader(),
                ),
                errorBuilder: (context, e) {
                  final ex = e as CustomException;
                  //debugPrint(ex.subtitle);
                  showDefaultNotification(
                    title: ex.title,
                    subtitle: ex.subtitle,
                  );

                  return const SizedBox();
                },
                builder: (_, opticShops) => SelectOpticScreenBody(
                  selectButtonText: widget.selectButtonText,
                  currentPage: currentPage,
                  opticShops: opticShops,
                  onCityDefinitionCallback: wm.onCityDefinition,
                  onOpticShopSelect: (selectedShop) =>
                      wm.onOpticShopSelectAction(
                    OpticShopParams(
                      selectedShop,
                      (optic, shop) => widget.onOpticSelect(
                        optic,
                        wm.currentCityStreamed.value.data ?? '',
                        shop,
                      ),
                    ),
                  ),
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
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
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

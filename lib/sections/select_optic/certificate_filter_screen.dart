import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/choose_types_sheet.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CertificateFilterScreen extends StatelessWidget {
  final SelectOpticScreenWM wm;

  const CertificateFilterScreen({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final certificateFiltersModel =
        wm.certificateFilterSectionModelState.value!;

    final lensFilters = certificateFiltersModel.lensFilters;
    final commonFilters = certificateFiltersModel.commonFilters;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Фильтры',
        backgroundColor: AppTheme.mystic,
        topRightWidget: TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: wm.resetAllFilters,
          child: const Text(
            'Сбросить',
            style: AppStyles.p1,
          ),
        ),
        titleFlex: 1,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 26,
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
        ),
        child: EntityStateBuilder<List<OpticShop>>(
          streamedState: wm.filteredOpticShopsStreamed,
          builder: (_, filteredOptics) {
            final count = filteredOptics.length;
            return BlueButtonWithText(
              text: count == 0
                  ? 'Нет оптик'
                  : 'Показать $count ${HelpFunctions.wordByCount(
                      count,
                      [
                        'вариантов',
                        'вариант',
                        'варианта',
                      ],
                    )}',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: StreamedStateBuilder<List<CommonFilter>>(
                streamedState: wm.selectedCommonFiltersState,
                builder: (_, selectedCommonFilters) {
                  return Column(
                    children: commonFilters
                        .map(
                          (filter) => Padding(
                            padding: EdgeInsets.only(
                              top: filter != commonFilters.first ? 4 : 0,
                            ),
                            child: _CommonFilterWidget(
                              filter: filter,
                              isSelected: selectedCommonFilters.contains(
                                filter,
                              ),
                              onTap: () => wm.onCommonFilterTap(filter),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              child: Text(
                'Подбор линз',
                style: AppStyles.h1,
              ),
            ),
            WhiteContainerWithRoundedCorners(
              padding: const EdgeInsets.only(
                top: 2,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
                // bottom: 16,
              ),
              child: StreamedStateBuilder<List<LensFilter>>(
                streamedState: wm.selectedLensFiltersState,
                builder: (_, selectedLensFilters) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lensFilters
                        .map(
                          (filter) => LensFilterWidget(
                            filter: filter,
                            isSelected: selectedLensFilters.contains(filter),
                            onTap: () => wm.onLensFilterTap(filter),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommonFilterWidget extends StatelessWidget {
  final CommonFilter filter;
  final VoidCallback onTap;
  final bool isSelected;

  const _CommonFilterWidget({
    required this.filter,
    required this.onTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 14.0,
                bottom: 16.0,
              ),
              child: Text(
                filter.title,
                style: AppStyles.h2,
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 18.0,
            ),
            child: FilterCheckBox(
              isSelected: isSelected,
            ),
          ),
        ],
      ),
    );
  }
}

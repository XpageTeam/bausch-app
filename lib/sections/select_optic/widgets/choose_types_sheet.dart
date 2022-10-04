import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseTypesSheet extends StatelessWidget {
  final SelectOpticScreenWM wm;

  const ChooseTypesSheet({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = wm.certificateFilterSectionModelState.value!.lensFilters;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ColoredBox(
        color: AppTheme.mystic,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.mineShaft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Подбор линз',
                      style: AppStyles.h1,
                    ),
                    GestureDetector(
                      onTap: wm.resetLensFilters, // wm.resetLensFilters,
                      child: const Text(
                        'Сбросить',
                        style: AppStyles.h3,
                      ),
                    ),
                  ],
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
                      children: filters
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
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 26),
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
            ],
          ),
        ),
      ),
    );
  }
}

class LensFilterWidget extends StatelessWidget {
  final LensFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const LensFilterWidget({
    required this.filter,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // ignore: use_colored_box
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            // const SizedBox(
            //   width: StaticData.sidePadding,
            // ),
            Padding(
              padding: const EdgeInsets.only(
                top: 14.0,
                bottom: 18,
              ),
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: filter.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 14.0,
                  bottom: 18,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: filter.title,
                          style: AppStyles.h2,
                          children: filter.subtitle != null &&
                                  filter.subtitle!.isNotEmpty
                              ? [
                                  const TextSpan(
                                    text: ' ∙ ',
                                  ),
                                  TextSpan(
                                    text: filter.subtitle!.toLowerCase(),
                                    style: AppStyles.h2GreyBold,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 18,
              ),
              child: FilterCheckBox(
                isSelected: isSelected,
              ),
            ),
            // CustomCheckbox(
            //   value: isSelected,
            //   onChanged: (_) => onTap(),
            //   borderRadius: 2,
            // ),
          ],
        ),
      ),
    );
  }
}

class FilterCheckBox extends StatelessWidget {
  final bool isSelected;
  const FilterCheckBox({
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 18,
      width: 18,
      duration: const Duration(
        milliseconds: 100,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: isSelected ? AppTheme.mineShaft : Colors.transparent,
        border: Border.all(
          color: AppTheme.mineShaft,
          width: 2,
        ),
      ),
      child: isSelected
          ? const FittedBox(
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          : const SizedBox(),
    );
  }
}

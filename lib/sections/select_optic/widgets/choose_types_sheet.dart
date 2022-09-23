import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/select_optic/select_optics_screen.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseTypesSheet extends StatelessWidget {
  final List<Filter> filters;

  const ChooseTypesSheet({
    required this.filters,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wm = context.read<SelectOpticScreenWM>();

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
                      onTap: () {}, // wm.resetLensFilters,
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
                  top: 4,
                  bottom: 4,
                ),
                child: StreamedStateBuilder<List<Filter>>(
                  streamedState: wm.selectedLensFiltersState,
                  builder: (_, selectedLensFilters) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filters
                          .map(
                            (filter) => _LensFilterWidget(
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
                child: BlueButtonWithText(
                  text: 'Показать 2 варианта',
                  onPressed: () {
                    Navigator.of(context).pop();
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

class _LensFilterWidget extends StatelessWidget {
  final Filter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _LensFilterWidget({
    required this.filter,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  filter.title,
                  style: AppStyles.h2,
                ),
                const Text(
                  ' (астигматизм)',
                  style: AppStyles.h2GreyBold,
                ),
              ],
            ),
          ),
          CustomCheckbox(
            value: isSelected,
            onChanged: null,
            // onChanged: (value) {
            //   currentValues[2] = value!;
            // },
            borderRadius: 2,
          ),
        ],
      ),
    );
  }
}

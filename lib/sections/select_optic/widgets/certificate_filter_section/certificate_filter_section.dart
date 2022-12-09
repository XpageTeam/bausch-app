import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/all_filters_button.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/certificate_filter_section_model.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/common_filter_button.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/lens_filter_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CertificateFiltersSection extends StatelessWidget {
  final CertificateFilterSectionModel model;

  const CertificateFiltersSection({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wm = context.read<SelectOpticScreenWM>();

    return ScrollConfiguration(
      behavior: const AntiGlowBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: StaticData.sidePadding,
            ),
            StreamedStateBuilder<int>(
              streamedState: wm.selectedFiltersCountState,
              builder: (_, selectedFiltersCount) {
                return AllFiltersButton(
                  enabledFiltersCount: selectedFiltersCount,
                  onTap: wm.openAllCertificateFilters,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: StreamedStateBuilder<List<LensFilter>>(
                streamedState: wm.selectedLensFiltersState,
                builder: (_, selectedLensFilters) {
                  return LensFilterButton(
                    lensFilters: model.lensFilters,
                    selectedLensFilters: selectedLensFilters,
                    onTap: wm.showLensFiltersBottomsheet,
                  );
                },
              ),
            ),
            StreamedStateBuilder<List<CommonFilter>>(
              streamedState: wm.selectedCommonFiltersState,
              builder: (_, selectedCommonFilters) => Row(
                children: model.commonFilters
                    .map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: CommonFilterButton(
                          filter: filter,
                          onTap: wm.onCommonFilterTap,
                          isSelected: selectedCommonFilters.contains(filter),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              width: StaticData.sidePadding,
            ),
          ],
        ),
      ),
    );
  }
}

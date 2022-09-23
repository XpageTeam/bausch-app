import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class LensFilterButton extends StatelessWidget {
  final List<Filter> selectedLensFilters;
  final List<Filter> lensFilters;

  final VoidCallback onTap;

  const LensFilterButton({
    required this.lensFilters,
    required this.selectedLensFilters,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCount = selectedLensFilters.length;
    debugPrint('selectedCount: $selectedCount');
    return selectedCount > 0
        ? WhiteContainerWithRoundedCorners(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.turquoiseBlue,
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9, bottom: 11),
                  child: Text(
                    selectedLensFilters.first.title,
                    style: AppStyles.h2,
                  ),
                ),
                if (selectedCount > 1)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: WhiteContainerWithRoundedCorners(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 5),
                            child: Text(
                              'Еще ${selectedCount - 1}',
                              style: AppStyles.h2,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
        : WhiteContainerWithRoundedCorners(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 12,
                  ),
                  child: Text(
                    'Подбор линз',
                    style: AppStyles.h2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
  }
}

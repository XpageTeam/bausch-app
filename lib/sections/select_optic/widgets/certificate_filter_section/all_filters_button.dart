import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AllFiltersButton extends StatelessWidget {
  final VoidCallback onTap;
  final int enabledFiltersCount;
  const AllFiltersButton({
    required this.onTap,
    required this.enabledFiltersCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(StaticData.sidePadding),
            child: Image.asset(
              'assets/icons/filter.png',
              height: 16,
              width: 16,
            ),
          ),
          if (enabledFiltersCount > 0)
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
                  enabledFiltersCount.toString(),
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
    );
  }
}

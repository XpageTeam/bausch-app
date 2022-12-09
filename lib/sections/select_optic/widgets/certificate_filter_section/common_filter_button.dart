import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CommonFilterButton extends StatelessWidget {
  final CommonFilter filter;
  final bool isSelected;
  final ValueChanged<CommonFilter> onTap;
  const CommonFilterButton({
    required this.filter,
    required this.onTap,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      color: isSelected ? AppTheme.turquoiseBlue : Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      onTap: () => onTap(filter),
      child: Text(
        filter.title,
        style: AppStyles.h2,
      ),
    );
  }
}

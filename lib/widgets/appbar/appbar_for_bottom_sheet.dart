import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppBarForBottomSheet extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(12.0);

  const AppBarForBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(
        12,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 3,
        ),
        child: Center(
          child: Container(
            height: 4,
            width: 38,
            decoration: BoxDecoration(
              color: AppTheme.mineShaft,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

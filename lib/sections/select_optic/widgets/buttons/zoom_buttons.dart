import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class ZoomButtons extends StatelessWidget {
  final VoidCallback zoomIn;
  final VoidCallback zoomOut;
  const ZoomButtons({
    required this.zoomIn,
    required this.zoomOut,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppTheme.turquoiseBlue.withOpacity(0.9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NormalIconButton(
                icon: const Icon(
                  Icons.add,
                  color: AppTheme.mineShaft,
                ),
                backgroundColor:
                    Colors.transparent, // AppTheme.turquoiseBlue.withOpacity(0.5),
                onPressed: zoomIn,
              ),
              NormalIconButton(
                icon: const Icon(
                  Icons.remove,
                  color: AppTheme.mineShaft,
                ),
                backgroundColor:
                    Colors.transparent, // AppTheme.turquoiseBlue.withOpacity(0.5),
                onPressed: zoomOut,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

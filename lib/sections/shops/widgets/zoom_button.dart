import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class ZoomButton extends StatelessWidget {
  final VoidCallback? zoomIn;
  final VoidCallback? zoomOut;
  const ZoomButton({
    this.zoomIn,
    this.zoomOut,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppTheme.turquoiseBlue,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NormalIconButton(
            icon: const Icon(
              Icons.add,
              color: AppTheme.mineShaft,
            ),
            backgroundColor: AppTheme.turquoiseBlue,
            onPressed: zoomIn,
          ),
          NormalIconButton(
            icon: const Icon(
              Icons.remove,
              color: AppTheme.mineShaft,
            ),
            backgroundColor: AppTheme.turquoiseBlue,
            onPressed: zoomOut,
          ),
        ],
      ),
    );
  }
}

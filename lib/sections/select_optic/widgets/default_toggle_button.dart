import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DefaultToggleButton extends StatelessWidget {
  final Color color;
  final SelectOpticPage type;
  final Function(SelectOpticPage type) onPressed;

  const DefaultToggleButton({
    required this.color,
    required this.type,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: color,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onPressed(type),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              type.asString,
              style: AppStyles.h2Bold,
            ),
          ),
        ),
      ),
    );
  }
}

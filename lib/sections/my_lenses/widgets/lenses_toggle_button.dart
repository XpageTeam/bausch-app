import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class LensesToggleButton extends StatelessWidget {
  final Color color;
  final MyLensesPage type;
  final Function(MyLensesPage type) onPressed;

  const LensesToggleButton({
    required this.color,
    required this.type,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color, width: 2),
        color: Colors.white,
      ),
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
            padding: const EdgeInsets.only(bottom: 11, top: 9),
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

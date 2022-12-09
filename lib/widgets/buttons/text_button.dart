import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final VoidCallback? onPressed;
  final double? arrowSize;
  const CustomTextButton({
    required this.title,
    this.titleStyle,
    this.arrowSize,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppTheme.turquoiseBlue,
      borderRadius: BorderRadius.circular(5),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          // horizontal: 12,
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: titleStyle ?? AppStyles.h1,
              ),
              WidgetSpan(
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppTheme.mineShaft,
                    size: arrowSize ?? 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        /*child: Row(
          children: [
            Flexible(
              child: Text(
                title,
                style: AppStyles.h1,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              color: AppTheme.mineShaft,
              size: 16,
            ),
          ],
        ),*/
      ),
    );
  }
}

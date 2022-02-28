import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const CustomTextButton({
    required this.title,
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
          vertical: 10.0,
          // horizontal: 12,
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: AppStyles.h1,
              ),
              WidgetSpan(
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppTheme.mineShaft,
                    size: 16,
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

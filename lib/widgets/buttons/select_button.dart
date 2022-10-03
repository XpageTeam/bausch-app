import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final String value;
  final Color color;
  final Color? textColor;

  final String? labeltext;
  final VoidCallback? onPressed;
  const SelectButton({
    required this.value,
    required this.color,
    this.textColor,
    this.onPressed,
    this.labeltext,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: labeltext == null ? 26 : 18,
            top: labeltext == null ? 26 : 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (labeltext != null)
                      Text(
                        labeltext!,
                        style: AppStyles.p1Grey,
                      ),
                    Flexible(
                      child: Text(
                        value,
                        style: labeltext == null
                            ? AppStyles.h2GreyBold.copyWith(color: textColor)
                            : AppStyles.h2.copyWith(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

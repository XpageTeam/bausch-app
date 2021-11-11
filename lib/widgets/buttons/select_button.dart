import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final String value;
  final Color color;
  final String? labeltext;
  final VoidCallback? onPressed;
  const SelectButton({
    required this.value,
    required this.color,
    this.onPressed,
    this.labeltext,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labeltext != null)
                    Text(
                      labeltext!,
                      style: AppStyles.p1Grey,
                    ),
                  Text(
                    value,
                    style:
                        labeltext == null ? AppStyles.h2GreyBold : AppStyles.h2,
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_downward_sharp,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

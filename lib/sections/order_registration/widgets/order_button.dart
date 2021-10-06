import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  final Widget title;
  final Color iconColor;
  final VoidCallback? onPressed;
  const OrderButton({
    required this.title,
    required this.iconColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () {
            debugPrint('statement');
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title,
                Icon(
                  Icons.chevron_right_sharp,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

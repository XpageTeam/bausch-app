import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomRadioButton({
    required this.text,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
        });
        widget.onPressed?.call();
      },
      child: WhiteContainerWithRoundedCorners(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.text,
                style: AppStyles.h3,
              ),
            ),
            CustomCheckbox(
              value: value,
              borderRadius: 180,
              onChanged: (newValue) {
                setState(() {
                  value = newValue ?? false;
                });
                widget.onPressed?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
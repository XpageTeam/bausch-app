import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String text;
  final int? value;
  final int? groupValue;
  // final void Function(String whatDoYouUse) onPressed;
  final ValueChanged<bool?>? onChanged;
  final bool? selected;
  final double? checkBoxRadius;

  const CustomRadioButton({
    required this.text,
    required this.onChanged,
    this.checkBoxRadius = 180,
    this.groupValue,
    this.value,
    this.selected,
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
      onTap: () => widget.onChanged?.call(true),
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
              value: widget.groupValue != null
                  ? widget.value == widget.groupValue
                  : widget.selected,
              onChanged: widget.onChanged,
              borderRadius: widget.checkBoxRadius,
            ),
          ],
        ),
      ),
    );
  }
}

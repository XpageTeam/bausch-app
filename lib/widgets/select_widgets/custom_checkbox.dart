import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final double? borderRadius;
  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.value,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: MaterialStateProperty.all(AppTheme.mineShaft),
      onChanged: widget.onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? 2,
        ),
      ),
    );
  }
}

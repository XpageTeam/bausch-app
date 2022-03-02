import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final int? value;
  final int? groupValue;
  final bool? selected;

  final ValueChanged<bool?>? onChanged;
  final String? text;

  const CustomRadio({
    required this.value,
    required this.onChanged,
    this.selected,
    this.groupValue,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChanged?.call(true),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCheckbox(
            // ignore: avoid_bool_literals_in_conditional_expressions
            value: widget.groupValue != null
                ? widget.value == widget.groupValue
                : widget.selected,
            onChanged: widget.onChanged,
            borderRadius: 180,
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Text(
              widget.text ?? '',
              style: AppStyles.h2,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final int? value;
  final int? groupValue;
  final ValueChanged<bool?>? onChanged;
  final String? text;

  const CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
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
      onTap: () {
        widget.onChanged!.call(true);
      },
      child: Row(
        children: [
          CustomCheckbox(
            value: widget.value == widget.groupValue ? true : false,
            onChanged: widget.onChanged,
            borderRadius: 180,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            widget.text ?? '',
            style: AppStyles.h2,
          ),
        ],
      ),
    );
  }
}

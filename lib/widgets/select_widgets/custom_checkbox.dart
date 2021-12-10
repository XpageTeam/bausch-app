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
  final size = 18 + 11 * 2.0; // размер чекбокса плюс отступы
  late bool currentValue = widget.value ?? false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        setState(
          () => currentValue = !currentValue,
        );
        widget.onChanged?.call(currentValue);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.all(11.0),
          decoration: BoxDecoration(
            color: currentValue
                ? AppTheme.mineShaft
                : Colors.transparent, // или цвет заполнения
            border: Border.all(
              color: AppTheme.mineShaft,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? 2,
            ),
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              return currentValue
                  ? Icon(
                      Icons.check,
                      size: constraints.maxWidth,
                      color: Colors.white,
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }
}

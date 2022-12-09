import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final double? borderRadius;
  final bool marginNeeded;

  const CustomCheckbox({
    required this.onChanged,
    this.value,
    this.borderRadius,
    this.marginNeeded = true,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late final double size; // размер чекбокса плюс отступы
  late bool currentValue;
  @override
  void initState() {
    super.initState();
    size = widget.marginNeeded ? 18 + 11 * 2.0 : 16;
    currentValue = widget.value ?? false;
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentValue = widget.value ?? currentValue;
  }

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
          margin: widget.marginNeeded ? const EdgeInsets.all(11.0) : null,
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

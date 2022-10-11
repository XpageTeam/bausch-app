import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SelectWidget extends StatefulWidget {
  final List<String> items;
  final ValueChanged<int> onChanged;
  final int initValue;

  const SelectWidget({
    required this.items,
    required this.onChanged,
    required this.initValue,
    Key? key,
  }) : super(key: key);

  @override
  _SelectWidgetState createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  int value = 0;

  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.items.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              value = index;
              widget.onChanged(value);
            });
          },
          child: Container(
            child: Text(
              widget.items[index],
              style: AppStyles.h2,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: index == value ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

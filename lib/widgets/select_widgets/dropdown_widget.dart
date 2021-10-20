import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final List<String> list;
  final ValueChanged<String?>? onChanged;
  final String? value;

  const DropdownWidget({
    required this.list,
    required this.onChanged,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      elevation: 0,
      borderRadius: BorderRadius.circular(2),
      style: AppStyles.h2,
      value: widget.value,
      items: widget.list.map(buildMenuItem).toList(),
      onChanged: widget.onChanged,
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        //alignment: AlignmentDirectional.center,
        value: item,
        child: Text(item),
      );
}

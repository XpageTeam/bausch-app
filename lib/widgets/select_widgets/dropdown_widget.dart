import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';

//* Select
class DropdownWidget extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onItemSelected;
  final String selectedKey;
  final String labeltext;
  final Color? backgroundColor;
  final Color? cornersColor;
  const DropdownWidget({
    required this.items,
    required this.onItemSelected,
    required this.selectedKey,
    this.labeltext = 'Label',
    this.backgroundColor,
    this.cornersColor,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return MenuButton(
      child: SelectButton(
        value: widget.selectedKey == '' ? widget.labeltext : widget.selectedKey,
        color: widget.backgroundColor ?? AppTheme.mystic,
        labeltext: widget.selectedKey != '' ? widget.labeltext : null,
      ),
      itemBackgroundColor: widget.cornersColor ?? Colors.white,
      menuButtonBackgroundColor: widget.cornersColor ?? Colors.white,
      //showSelectedItemOnList: false,
      scrollPhysics: const BouncingScrollPhysics(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      divider: const Divider(
        height: 0,
        color: AppTheme.grey,
      ),
      items: widget.items,
      // ignore: avoid_types_on_closure_parameters
      itemBuilder: (String value) {
        return SelectItem(
          value: value,
          color: widget.backgroundColor ?? AppTheme.mystic,
        );
      },
      toggledChild: SelectButton(
        value: widget.selectedKey == '' ? widget.labeltext : widget.selectedKey,
        color: widget.backgroundColor ?? AppTheme.mystic,
        labeltext: widget.selectedKey != '' ? widget.labeltext : null,
      ),
      onItemSelected: widget.onItemSelected,
    );
  }
}

class SelectItem extends StatelessWidget {
  final String value;
  final Color color;
  const SelectItem({required this.value, required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 26,
          top: 26,
        ),
        child: Text(
          value,
          style: AppStyles.h2GreyBold,
        ),
      ),
    );
  }
}

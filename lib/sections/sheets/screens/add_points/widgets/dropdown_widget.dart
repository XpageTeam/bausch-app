import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';

class DropdownWidget extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onItemSelected;
  final String selectedKey;
  const DropdownWidget({
    required this.items,
    required this.onItemSelected,
    required this.selectedKey,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return MenuButton(
      child: SelectButton(value: widget.selectedKey),
      itemBackgroundColor: AppTheme.mystic,
      menuButtonBackgroundColor: AppTheme.mystic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(width: 0, color: AppTheme.mystic),
        color: AppTheme.mystic,
      ),
      divider: const Divider(
        height: 0,
        color: AppTheme.grey,
      ),
      items: widget.items,
      itemBuilder: (String value) {
        return SelectItem(value: value);
      },
      toggledChild: SelectButton(value: widget.selectedKey),
      onItemSelected: widget.onItemSelected,
    );
  }
}

class SelectButton extends StatelessWidget {
  final String value;
  const SelectButton({required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 26,
        top: 26,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: AppStyles.h2GreyBold,
          ),
          const Icon(
            Icons.arrow_downward_sharp,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class SelectItem extends StatelessWidget {
  final String value;
  const SelectItem({required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

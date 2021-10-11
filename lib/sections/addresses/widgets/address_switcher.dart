import 'package:bausch/sections/addresses/widgets/default_toggle_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

typedef SwitcherCallback = void Function(bool rightValue);

class AddressesSwitcher extends StatefulWidget {
  final SwitcherCallback? switcherCallback;
  final EdgeInsets margin;
  const AddressesSwitcher({
    this.switcherCallback,
    this.margin = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  _AddressesSwitcherState createState() => _AddressesSwitcherState();
}

class _AddressesSwitcherState extends State<AddressesSwitcher> {
  bool isList = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppTheme.grey, //!  const Color(0xffcacecf)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: DefaultToggleButton(
              text: 'На карте',
              color: isList ? Colors.transparent : Colors.white,
              onPressed: () {
                setState(
                  () {
                    isList = false;

                    if (widget.switcherCallback != null) {
                      widget.switcherCallback!(isList);
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: DefaultToggleButton(
              text: 'Список',
              color: isList ? Colors.white : Colors.transparent,
              onPressed: () {
                setState(
                  () {
                    isList = true;

                    if (widget.switcherCallback != null) {
                      widget.switcherCallback!(isList);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

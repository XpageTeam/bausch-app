import 'package:bausch/sections/shops/widgets/default_toggle_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ShopPageSwitcher extends StatefulWidget {
  final Function(int) onChange;
  const ShopPageSwitcher({
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  _ShopPageSwitcherState createState() => _ShopPageSwitcherState();
}

class _ShopPageSwitcherState extends State<ShopPageSwitcher> {
  final btnTexts = ['На карте', 'Список'];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppTheme.grey.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: btnTexts
            .map(
              (text) => Expanded(
                child: DefaultToggleButton(
                  text: text,
                  color: currentIndex == btnTexts.indexOf(text)
                      ? Colors.white
                      : Colors.transparent,
                  onPressed: () {
                    setState(
                      () {
                        currentIndex = btnTexts.indexOf(text);
                        widget.onChange(currentIndex);
                      },
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

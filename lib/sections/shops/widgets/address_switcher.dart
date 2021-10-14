import 'package:bausch/sections/shops/widgets/default_toggle_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

typedef SwitcherCallback = void Function(Pages newPage);

enum Pages {
  map,
  list,
}

class ShopPageSwitcher extends StatefulWidget {
  final SwitcherCallback? switcherCallback;
  final EdgeInsets margin;
  const ShopPageSwitcher({
    this.switcherCallback,
    this.margin = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  _ShopPageSwitcherState createState() => _ShopPageSwitcherState();
}

class _ShopPageSwitcherState extends State<ShopPageSwitcher> {
  bool isList = false;
  Pages currentPage = Pages.map;
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
                    currentPage = Pages.map;
                    isList = false;

                    if (widget.switcherCallback != null) {
                      widget.switcherCallback!(currentPage);
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
                    currentPage = Pages.list;
                    isList = true;

                    if (widget.switcherCallback != null) {
                      widget.switcherCallback!(currentPage);
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

import 'package:bausch/sections/profile/notifications_section.dart';
import 'package:bausch/sections/profile/orders_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/select_widgets/select_widget.dart';
import 'package:flutter/material.dart';

class ScrollableProfileContent extends StatefulWidget {
  final ScrollController controller;
  const ScrollableProfileContent({required this.controller, Key? key})
      : super(key: key);

  @override
  State<ScrollableProfileContent> createState() =>
      _ScrollableProfileContentState();
}

class _ScrollableProfileContentState extends State<ScrollableProfileContent> {
  bool isOrdersEnabled = true;

  int groupChecked = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.mystic,
      child: CustomScrollView(
        controller: widget.controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: Container(),
            backgroundColor: Colors.transparent,
            toolbarHeight: 80,
            excludeHeaderSemantics: true,
            automaticallyImplyLeading: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              color: AppTheme.mystic,
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: SelectWidget(
                  items: const ['Заказы 122', 'Уведомления 8'],
                  onChanged: (i) {
                    if (i == 0) {
                      setState(() {
                        isOrdersEnabled = true;
                      });
                    } else {
                      setState(() {
                        isOrdersEnabled = false;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          if (isOrdersEnabled) ...[
            //* Вкладка с заказами
            const OrdersSection(),
          ] else ...[
            //* Вкладка с уведомлениями (с переключателем)
            NotificationSection(
              groupChecked: groupChecked,
              onChanged: (newGroupChecked) => setState(
                () {
                  groupChecked = newGroupChecked;
                },
              ),
            ),
          ],
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

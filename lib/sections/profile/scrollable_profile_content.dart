import 'package:bausch/sections/profile/notifications_section.dart';
import 'package:bausch/sections/profile/orders_section.dart';
import 'package:bausch/sections/profile/widgets/blured_image.dart';
import 'package:bausch/sections/profile/widgets/rank_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
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
            // expandedHeight: 85,
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
            //* Вкладка с уведомлениями(переключатель)
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
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 48;

  MySliverAppBar({
    required this.expandedHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppTheme.turquoiseBlue,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 2,
              left: StaticData.sidePadding,
              right: StaticData.sidePadding,
            ),
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                NormalIconButton(
                  icon: Icon(Icons.chevron_left),
                ),
                NormalIconButton(
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,
            child: Text(
              'Саша',
              style: AppStyles.h1,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 37),
              child: Opacity(
                opacity: _calcOpacity(shrinkOffset),
                child: const RankWidget(title: 'Классный друг'),
              ),
            ),
          ),
          Positioned(
            top: expandedHeight / 2,
            left: 0,
            right: 0,
            child: const BluredImage(),
          ),
        ],
      ),
    );
  }

  double _calcOpacity(double shrinkOffset) {
    return 1 - shrinkOffset / expandedHeight < 0
        ? 0
        : 1 - shrinkOffset / expandedHeight;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

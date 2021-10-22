import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/sections/profile/notifications_section.dart';
import 'package:bausch/sections/profile/orders_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
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
            backgroundColor: Colors.transparent,
            toolbarHeight: 60,
            expandedHeight: 70,
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

          //* Вкладка с заказами
          if (isOrdersEnabled) const OrdersSection(),

          //* Вкладка с уведомлениями(переключатель)
          if (!isOrdersEnabled)
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CustomRadio(
                    value: 0,
                    groupValue: groupChecked,
                    text: 'Все уведомления',
                    onChanged: (v) {
                      setState(() {
                        groupChecked = 0;
                      });
                    },
                  ),
                  CustomRadio(
                    value: 1,
                    groupValue: groupChecked,
                    text: 'История баллов',
                    onChanged: (v) {
                      setState(() {
                        groupChecked = 1;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),

          //* Вкладка с уведомлениями(сами уведомления)
          if (!isOrdersEnabled) const NotificationSection(),

          if (!isOrdersEnabled)
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    OfferWidget(
                      title: 'Получите двойные баллы за подбор контактных линз',
                      subtitle:
                          'После подбора вам будет передан код, зарегистрируйте его течение 14 дней ',
                      topRightIcon: Container(),
                    ),
                  ],
                ),
              ),
            ),
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

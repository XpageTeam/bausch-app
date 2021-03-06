// ignore_for_file: avoid_unnecessary_containers, avoid-returning-widgets
import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/notification_item.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class NotificationsWM extends WidgetModel {
  final List<NotificationModel> items;

  final StreamedState<List<Widget>> widgetslist;
  final filterValue = StreamedState<int>(0);

  final changeFilterAction = StreamedAction<int>();

  NotificationsWM({
    required this.items,
  })  : widgetslist = StreamedState(_getNotificationsList(items)),
        super(const WidgetModelDependencies());

  @override
  void onLoad() {
    super.onLoad();

    changeFilterAction.bind((val) {
      filterValue.accept(val!);
      setWidgetsList();
    });

    setWidgetsList();
  }

  void setWidgetsList() {
    widgetslist.accept([]);

    final banners = Container(
      child: OffersSection(
        type: OfferType.notificationsScreen,
        showLoader: false,
        margin: const EdgeInsets.only(bottom: 4),
      ),
    );

    final filteredItems = <Widget>[];

    for (final item in items) {
      if (filterValue.value == 1) {
        if (item.points != null && item.points != 0) {
          filteredItems.add(
            Container(
              margin: const EdgeInsets.only(
                bottom: 4,
              ),
              child: NotificationItem(data: item),
            ),
          );
        }
      } else {
        filteredItems.add(
          Container(
            margin: const EdgeInsets.only(
              bottom: 4,
            ),
            child: NotificationItem(data: item),
          ),
        );
      }
    }

    if (filteredItems.length < 5) {
      widgetslist.accept([
        ...filteredItems,
        banners,
      ]);
    } else {
      final notifications = [...filteredItems]..insert(2, banners);

      widgetslist.accept(notifications);
    }

    if (items.any((item) => item.points == null || item.points == 0)) {
      widgetslist.accept([
        Container(
          child: StreamedStateBuilder<int>(
            streamedState: filterValue,
            builder: (_, value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomRadio(
                    value: 0,
                    groupValue: value,
                    text: '?????? ??????????????????????',
                    onChanged: (v) {
                      changeFilterAction(0);
                    },
                  ),
                  CustomRadio(
                    value: 1,
                    groupValue: value,
                    text: '?????????????? ????????????',
                    onChanged: (v) {
                      changeFilterAction(1);
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              );
            },
          ),
        ),
        ...widgetslist.value,
      ]);
    }
  }
}

List<Widget> _getNotificationsList(List<NotificationModel> list) {
  return list.map((item) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 4,
      ),
      child: NotificationItem(data: item),
    );
  }).toList();
}

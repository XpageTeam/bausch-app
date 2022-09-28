// ignore_for_file: avoid_unnecessary_containers, avoid-returning-widgets
import 'dart:async';

import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/content/requester/profile_requester.dart';
import 'package:bausch/sections/profile/notification_item.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class NotificationsWM extends WidgetModel {
  final List<NotificationModel> items;

  late final StreamedState<List<Widget>> widgetList;
  final StreamedState<List<NotificationModel>> notificationsReadList =
      StreamedState<List<NotificationModel>>([]);
  final filterValue = StreamedState<int>(0);

  final changeFilterAction = StreamedAction<int>();
  final void Function(int amount)? updateCallback;
  final _requester = ProfileRequester();
  List<int> updatedNotificationIds = [];
  bool updatingInProgress = false;
  bool _isLoaded = false;

  NotificationsWM({
    required this.items,
    this.updateCallback,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    super.onLoad();
    if (!_isLoaded) {
      widgetList = StreamedState(_getNotificationsList(items, this));
      notificationsReadList.accept([...items]);
      _isLoaded = false;

      changeFilterAction.bind((val) {
        filterValue.accept(val!);
        setWidgetsList();
      });

      _readAll();

      setWidgetsList();
    }
  }

  void setWidgetsList() {
    widgetList.accept([]);

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
              child: NotificationItem(
                data: item,
                wm: this,
              ),
            ),
          );
        }
      } else {
        filteredItems.add(
          Container(
            margin: const EdgeInsets.only(
              bottom: 4,
            ),
            child: NotificationItem(
              data: item,
              wm: this,
            ),
          ),
        );
      }
    }

    if (filteredItems.length < 5) {
      widgetList.accept([
        ...filteredItems,
        banners,
      ]);
    } else {
      final notifications = [...filteredItems]..insert(2, banners);

      widgetList.accept(notifications);
    }

    if (items.any((item) => item.points == null || item.points == 0)) {
      widgetList.accept([
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
                    text: 'Все уведомления',
                    onChanged: (v) {
                      changeFilterAction(0);
                    },
                  ),
                  CustomRadio(
                    value: 1,
                    groupValue: value,
                    text: 'История баллов',
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
        ...widgetList.value,
      ]);
    }
  }

  void _readAll() {
    updateCallback?.call(0);
    final unreaded = items.where((element) => element.read == null || false);

    unawaited(
      _requester.sendNotificationsRead(
        ids: unreaded.map((e) => e.id).toList(),
      ),
    );
  }

  // Future updateNotifications() async {
  //   if (updatingInProgress) return;
  //   updatingInProgress = true;
  //   await Future.delayed(
  //     const Duration(milliseconds: 50),
  //     () async {
  //       final currentIds = [...updatedNotificationIds];
  //       var unreadCount = 0;
  //       updatedNotificationIds.clear();
  //       updatingInProgress = false;
  //       final newList = <NotificationModel>[];
  //       unawaited(_requester.sendNotificationsRead(ids: currentIds));
  //       for (final element in notificationsReadList.value) {
  //         if (currentIds.where((value) => element.id == value).isNotEmpty) {
  //           newList.add(NotificationModel(
  //             id: element.id,
  //             title: element.title,
  //             points: element.points,
  //             type: element.type,
  //             date: element.date,
  //             read: true,
  //           ));
  //         } else {
  //           newList.add(element);
  //           if (!element.read!) {
  //             unreadCount++;
  //           }
  //         }
  //       }
  //       await notificationsReadList.accept([...newList]);
  //       updateCallback!(unreadCount);
  //       debugPrint('updated: $unreadCount');
  //     },
  //   );
  // }
}

List<Widget> _getNotificationsList(
  List<NotificationModel> list,
  NotificationsWM wm,
) {
  return list.map((item) {
    return Container(
      key: Key('notification ${item.id}'),
      margin: const EdgeInsets.only(
        bottom: 4,
      ),
      child: NotificationItem(
        data: item,
        wm: wm,
      ),
    );
  }).toList();
}

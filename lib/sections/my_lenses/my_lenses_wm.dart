import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum MyLensesPage { currentLenses, oldLenses }

extension ShopsContentTypeAsString on MyLensesPage {
  String get asString =>
      this == MyLensesPage.currentLenses ? 'Ношу сейчас' : 'Были раньше';
}

class MyLensesWM extends WidgetModel {
  final BuildContext context;
  final switchAction = StreamedAction<MyLensesPage>();
  final historyList = ['5 май, 16:00', '6 май, 16:00', '7 май, 16:00'];
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);
  final notificationStatus = StreamedState<List<String>>(['Нет', '1']);
  // TODO(pavlov): заглушка для уведомлений, пока нет бэка
  Map<String, bool> notificationsList = <String, bool>{
    'Нет': true,
    'В день замены': false,
    'За 1 день': false,
    'За 2 дня': false,
    'За неделю': false,
  };
  String customNotification = '';

  MyLensesWM({required this.context}) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    switchAction.bind(
      (newType) => _switchPage(newType!),
    );
    super.onBind();
  }

  // TODO(pavlov): тут в будущем сохранять уведомления
  void updateNotifications(
    Map<String, bool> notifications,
    String custom,
  ) {
    customNotification = custom;
    notificationsList
      ..clear()
      ..addAll(notifications);
    showDefaultNotification(
      title: 'Данные успешно обновлены',
      success: true,
    );
    notifications.removeWhere((key, value) => value == false);
    if (notifications.isEmpty && customNotification == '') {
      notificationsList.update('Нет', (value) => true);
    }

    if (notifications.isEmpty && customNotification == '') {
      notificationStatus.accept(['Нет', '1']);
    } else if (notifications.isEmpty && customNotification != '') {
      notificationStatus.accept([customNotification, '1']);
    } else if (notifications.length == 1 && customNotification == '') {
      notificationStatus.accept([notifications.keys.first, '1']);
    } else {
      notificationStatus.accept([
        '',
        (notifications.length + (customNotification != '' ? 1 : 0)).toString(),
      ]);
    }

    Keys.mainContentNav.currentState!.pop();
  }

  void _switchPage(MyLensesPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }
}

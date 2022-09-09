import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/my_lenses/requesters/my_lenses_requester.dart';
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
  final lensesDifferentLife = StreamedState(true);
  final bothPuttedOn = StreamedState(false);
  final leftLensDate = StreamedState<LensDateModel?>(null);
  final rightLensDate = StreamedState<LensDateModel?>(null);
  // TODO(ask): день замены будет как-то приходить или мне самому считать?
  // используется для правой линзы и когда срок линз одинаковый
  final rightReplacementDay =
      StreamedState('Просрочен'); // Нет // Да // Просрочен
  final leftReplacementDay = StreamedState('Нет'); // Нет // Да // Просрочен
  final switchAction = StreamedAction<MyLensesPage>();
  final previousLenses = ['Бауш', 'Энд', 'Ломб'];
  final historyList = ['5 май, 16:00', '6 май, 16:00', '7 май, 16:00'];
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);
  final notificationStatus = StreamedState<List<String>>(['Нет', '1']);
  final dailyReminder = StreamedState(false);
  final dailyReminderRepeat = StreamedState('Нет');
  final dailyReminderRepeatDate = StreamedState<DateTime?>(null);
  final lensesPairModel = StreamedState<LensesPairModel?>(null);
  final currentProduct = StreamedState<LensProductModel?>(null);
  final MyLensesRequester myLensesRequester = MyLensesRequester();
  final loadingInProgress = StreamedState(false);

  // TODO(pavlov): заглушка для уведомлений, пока нет бэка
  Map<String, bool> notificationsMap = <String, bool>{
    'Нет': true,
    'В день замены': false,
    'За 1 день': false,
    'За 2 дня': false,
    'За неделю': false,
    // 'За 3 дня': false,
    // 'За 4 дня': false,
    // 'За 5 дней': false,
  };
  String customNotification = '';

  MyLensesWM({required this.context}) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    loadAllData();
    switchAction.bind(
      (newType) => _switchPage(newType!),
    );
    super.onBind();
  }

  Future loadAllData() async {
    try {
      // TODO(pavlov): нужна кнопка обновить
      await loadingInProgress.accept(true);
      // TODO(pavlov): если приходит нал, надо как-то перенаправлять на другую страницу
      await lensesPairModel
          .accept(await myLensesRequester.loadChosenLensesInfo());
      await currentProduct.accept(await myLensesRequester.loadLensProduct(
        id: lensesPairModel.value!.productId!,
      ));
      // final lensesDates = await myLensesRequester.loadLensesDates();
      // print('ba3');
      // await rightLensDate.accept(lensesDates.right);
      // await leftLensDate.accept(lensesDates.left);
      await loadingInProgress.accept(false);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      await lensesPairModel.accept(LensesPairModel(
        right: PairModel(
          diopters: null,
          cylinder: null,
          axis: null,
          addition: null,
        ),
        left: PairModel(
          diopters: null,
          cylinder: null,
          axis: null,
          addition: null,
        ),
      ));
    }
  }

  Future putOnLenses({
    required DateTime? leftDate,
    required DateTime? rightDate,
    bool differentLife = false,
  }) async {
    try {
      await myLensesRequester.putOnLensesPair(
        leftDate: leftDate,
        rightDate: rightDate,
      );
      // TODO(wait): тут нужен запрос на обновленное получение дат
      if (leftDate != null && rightDate != null) {
        await bothPuttedOn.accept(true);
      }
      if (differentLife) {
        await lensesDifferentLife.accept(true);
      }

      if (leftDate != null) {
        await leftLensDate
            .accept(leftLensDate.value!.copyWith(dateStart: leftDate));
      }
      if (rightDate != null) {
        await rightLensDate
            .accept(rightLensDate.value!.copyWith(dateStart: rightDate));
      }
      //  await myLensesRequester.updateReminders(
      //  reminders:
      // );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('ban' + e.toString());
    }
  }

  // TODO(pavlov): тут в будущем сохранять уведомления
  void updateNotifications(
    Map<String, bool> notifications,
    String custom,
  ) {
    print('ban'+ notifications[0].toString());
    customNotification = custom;
    notificationsMap
      ..clear()
      ..addAll(notifications);
    showDefaultNotification(
      title: 'Данные успешно обновлены',
      success: true,
    );
    notifications.removeWhere((key, value) => value == false);
    if (notifications.isEmpty && customNotification == '') {
      notificationsMap.update('Нет', (value) => true);
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

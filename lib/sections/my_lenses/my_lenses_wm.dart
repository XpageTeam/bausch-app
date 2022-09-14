// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/my_lenses/requesters/my_lenses_requester.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_end_sheet.dart';
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
  // тут приходит дата начала, конца, сколько дней осталось
  final leftLensDate = StreamedState<LensDateModel?>(null);
  final rightLensDate = StreamedState<LensDateModel?>(null);
  final switchAction = StreamedAction<MyLensesPage>();
  final previousLenses = ['Бауш', 'Энд', 'Ломб'];
  final historyList = ['5 май, 16:00', '6 май, 16:00', '7 май, 16:00'];
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);
  final notificationStatus = StreamedState<List<String>>(['Нет', '1']);
  final dailyReminder = StreamedState(false);
  final dailyReminderRepeat = StreamedState('Нет');
  final dailyReminderRepeatDate = StreamedState<DateTime?>(null);
  final StreamedState<LensesPairModel?> lensesPairModel;
  final currentProduct = StreamedState<LensProductModel?>(null);
  final MyLensesRequester myLensesRequester = MyLensesRequester();
  final loadingInProgress = StreamedState(false);

  List<MyLensesNotificationModel> notificationsList = [
// TODO(ask): уточнить порядок id
    MyLensesNotificationModel(isActive: true, title: 'Нет', id: 0),
    MyLensesNotificationModel(isActive: false, title: 'В день замены', id: 1),
    MyLensesNotificationModel(isActive: false, title: 'За 1 день', id: 2),
    MyLensesNotificationModel(isActive: false, title: 'За 2 дня', id: 3),
    MyLensesNotificationModel(isActive: false, title: 'За неделю', id: 4),
    MyLensesNotificationModel(isActive: false, title: 'За 3 дня', id: 5),
    MyLensesNotificationModel(isActive: false, title: 'За 4 дня', id: 6),
    MyLensesNotificationModel(isActive: false, title: 'За 5 дней', id: 7),
  ];

  MyLensesWM({required this.context, required this.lensesPairModel})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    loadAllData();
    switchAction.bind(
      (newType) => _switchPage(newType!),
    );
    super.onBind();
  }

  Future loadAllData() async {
    // TODO(pavlov): нужна кнопка обновить
    // все эти загрузки потихоньку перетащить в main_screen_wm
    await loadingInProgress.accept(true);
    // TODO(pavlov): из-за наличия редактирования, эта функция осталась
    // надо переделать
    await loadLensesPair();
    await loadLensesDates();
    await loadingInProgress.accept(false);
  }

  Future loadLensesPair() async {
    try {
      await lensesPairModel
          .accept(await myLensesRequester.loadChosenLensesInfo());
      await currentProduct.accept(await myLensesRequester.loadLensProduct(
        id: lensesPairModel.value!.productId!,
      ));
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

  Future loadLensesDates() async {
    try {
      // TODO(ask): тут сейчас приходит неправильный остаток дней до замены
      final lensesDates = await myLensesRequester.loadLensesDates();
      await rightLensDate.accept(lensesDates.right);
      await leftLensDate.accept(lensesDates.left);
    } catch (e) {
      debugPrint('ban' + e.toString());
    }
  }

  Future putOnLenses({
    required DateTime? leftDate,
    required DateTime? rightDate,
  }) async {
    try {
      await myLensesRequester.putOnLensesPair(
        leftDate: leftDate,
        rightDate: rightDate,
      );

      // TODO(wait): тут нужен запрос на редактирование дат
      // и на получение дат
      if (leftDate != null) {
        await leftLensDate.accept(LensDateModel(
          dateEnd: leftDate.add(Duration(days: currentProduct.value!.lifeTime)),
          dateStart: leftDate,
          // TODO(ask): здесь какая-то математическая проблема подсчетов
          // при двух dateStart датах daysLeft может быть 0
          daysLeft:
              (leftDate.add(Duration(days: currentProduct.value!.lifeTime)))
                  .difference(DateTime.now())
                  .inDays,
        ));
      }
      if (rightDate != null) {
        await rightLensDate.accept(LensDateModel(
          dateEnd:
              rightDate.add(Duration(days: currentProduct.value!.lifeTime)),
          dateStart: rightDate,
          daysLeft:
              (rightDate.add(Duration(days: currentProduct.value!.lifeTime)))
                  .difference(DateTime.now())
                  .inDays,
        ));
      }
      await updateNotifications(notifications: notificationsList);
    } catch (e) {
      debugPrint('putOnLenses $e');
    }
  }

  Future pufOffLenses() async {
    if (rightLensDate.value == null || leftLensDate.value == null) {
      await leftLensDate.accept(null);
      await rightLensDate.accept(null);
    } else {
      await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return PutOnEndSheet(
            onLeftConfirmed: () {
              leftLensDate.accept(null);
              Navigator.of(context).pop();
            },
            onRightConfirmed: () {
              rightLensDate.accept(null);
              Navigator.of(context).pop();
            },
            onBothConfirmed: () {
              leftLensDate.accept(null);
              rightLensDate.accept(null);
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future updateNotifications({
    required List<MyLensesNotificationModel> notifications,
  }) async {
    notificationsList
      ..clear()
      ..addAll(notifications);
    notifications.removeWhere((value) => value.isActive == false);
    final ids = <int>[];
    if (notifications.isEmpty) {
      notificationsList[0] = notificationsList[0].copyWith(isActive: true);
      await notificationStatus.accept(['Нет', '1']);
      ids.add(0);
    } else if (notifications.length == 1) {
      await notificationStatus.accept([
        notifications.firstWhere((element) => element.isActive == true).title,
        '1',
      ]);
      ids.add(
        notifications.firstWhere((element) => element.isActive == true).id,
      );
    } else {
      await notificationStatus.accept(['', (notifications.length).toString()]);
      for (final element in notifications) {
        if (element.isActive) {
          ids.add(element.id);
        }
      }
    }
    try {
      await myLensesRequester.updateReminders(reminders: ids);
    } catch (e) {
      debugPrint(e.toString());
    }
    showDefaultNotification(
      title: 'Данные успешно обновлены',
      success: true,
    );
    Keys.mainContentNav.currentState!.pop();
  }

  void _switchPage(MyLensesPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }
}

class MyLensesNotificationModel {
  final bool isActive;
  final String title;
  final int id;

  MyLensesNotificationModel({
    required this.isActive,
    required this.title,
    required this.id,
  });

  // factory LensDateModel.fromMap(Map<String, dynamic> map) {
  //   try {
  //     return LensDateModel(
  //       dateStart: map['dateStart'] as DateTime,
  //       dateEnd: map['dateEnd'] as DateTime,
  //       daysLeft: map['daysLeft'] as int,
  //     );
  //   } catch (e) {
  //     throw ResponseParseException('Ошибка в PairDateModel: $e');
  //   }
  // }

  MyLensesNotificationModel copyWith({
    bool? isActive,
    String? title,
    int? id,
  }) {
    return MyLensesNotificationModel(
      isActive: isActive ?? this.isActive,
      title: title ?? this.title,
      id: id ?? this.id,
    );
  }
}

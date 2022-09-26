// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/sections/my_lenses/requesters/my_lenses_requester.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_end_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum MyLensesPage { currentLenses, oldLenses }

extension ShopsContentTypeAsString on MyLensesPage {
  String get asString =>
      this == MyLensesPage.currentLenses ? 'Ношу' : 'Были раньше';
}

class MyLensesWM extends WidgetModel {
  // тут приходит дата начала, конца, сколько дней осталось
  final leftLensDate = StreamedState<LensDateModel?>(null);
  final rightLensDate = StreamedState<LensDateModel?>(null);
  final switchAction = StreamedAction<MyLensesPage>();
  final wornHistoryList = StreamedState<List<LensesWornHistoryModel>>([]);
  final productHistoryList = StreamedState<List<LensesPairModel>>([]);
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);
  final notificationStatus = StreamedState<List<String>>(['Нет', '1']);
  final currentRemindes = StreamedState<List<String>>([]);
  final dailyReminder = StreamedState(false);
  final dailyReminderRepeat = StreamedState('Нет');
  final dailyReminderRepeatDate = StreamedState<DateTime?>(null);
  final StreamedState<LensesPairModel?> lensesPairModel =
      StreamedState<LensesPairModel?>(null);
  final currentProduct = StreamedState<LensProductModel?>(null);
  final MyLensesRequester myLensesRequester = MyLensesRequester();
  final recommendedProducts = StreamedState<List<RecommendedProductModel>>([]);
  final loadingInProgress = StreamedState(false);

  MyLensesWM() : super(const WidgetModelDependencies());

  @override
  void onBind() {
    loadAllData();
    switchAction.bind(
      (newType) => _switchPage(newType!),
    );
    super.onBind();
  }

// TODO(pavlov): проверить как работает загрузка при переключении
  Future loadAllData() async {
    await loadingInProgress.accept(true);
    await loadLensesPair();
    await recommendedProducts.accept(
      await loadRecommendedProducts(productId: currentProduct.value?.id),
    );
    await loadLensesDates();
    await loadWornHistory();
    await loadProductsHistory();
    await loadLensesReminders();
    await loadingInProgress.accept(false);
  }

  Future updateReminders({
    required List<String> reminders,
    bool shouldPop = false,
  }) async {
    try {
      await myLensesRequester.updateReminders(reminders: reminders);
      if (reminders.isEmpty) {
        await notificationStatus.accept(['Нет', '1']);
      } else if (reminders.length == 1) {
        switch (reminders[0]) {
          case '0':
            await notificationStatus.accept(['В день замены', '1']);
            break;
          case '1':
            await notificationStatus.accept(['За 1 день', '1']);
            break;
          case '2':
            await notificationStatus.accept(['За 2 дня', '1']);
            break;
          case '3':
            await notificationStatus.accept(['За 3 дня', '1']);
            break;
          case '4':
            await notificationStatus.accept(['За 4 дня', '1']);
            break;
          case '5':
            await notificationStatus.accept(['За 5 дней', '1']);
            break;
          case '7':
            await notificationStatus.accept(['За неделю', '1']);
            break;
        }
      } else {
        await notificationStatus.accept(['', (reminders.length).toString()]);
      }
      await currentRemindes.accept([...reminders]);
      if (shouldPop) {
        Keys.mainContentNav.currentState!.pop();
      }
      showDefaultNotification(
        title: 'Данные успешно обновлены',
        success: true,
      );
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка обновления',
        success: true,
      );
      debugPrint(e.toString());
    }
  }

  Future loadLensesReminders() async {
    try {
      final reminders = <String>[];
      for (final element in await myLensesRequester.loadLensesReminders()) {
        reminders.add(element.toString());
      }
      await currentRemindes.accept([...reminders]);
    } catch (e) {
      debugPrint('loadLensesReminders $e');
    }
  }

  Future loadLensesPair() async {
    try {
      await lensesPairModel
          .accept(await myLensesRequester.loadChosenLensesInfo());
      // await lensesPairModel.accept(null);
      await currentProduct.accept(lensesPairModel.value?.product);
    } catch (e) {
      debugPrint('loadLensesPair $e');
    }
  }

  Future loadLensesDates() async {
    try {
      final lensesDates = await myLensesRequester.loadLensesDates();
      await rightLensDate.accept(lensesDates.right);
      await leftLensDate.accept(lensesDates.left);
    } catch (e) {
      debugPrint('loadLensesDates $e');
    }
  }

  Future loadWornHistory() async {
    try {
      // TODO(pavlov): по нажатию кнопки ранее делать тру
      await wornHistoryList.accept(
        (await myLensesRequester.loadLensesWornHistory(showAll: false))
            .wornHistory,
      );
    } catch (e) {
      debugPrint('loadWornHistory $e');
    }
  }

  Future loadProductsHistory() async {
    try {
      await productHistoryList.accept(
        (await myLensesRequester.loadLensesProductHistory()).productHistory,
      );
    } catch (e) {
      debugPrint('loadProductsHistory $e');
    }
  }

  Future updateLensesDates({
    required DateTime? leftDate,
    required DateTime? rightDate,
  }) async {
    try {
      await myLensesRequester.putOnLensesPair(
        leftDate: leftDate,
        rightDate: rightDate,
      );
      await loadLensesDates();
      // TODO(pavlov): думаю это тут не надо
      // await updateNotifications(notifications: [...notificationsList]);
      await loadWornHistory();
    } catch (e) {
      debugPrint('updateLensesDates $e');
    }
  }

  Future putOffLenses({required BuildContext context}) async {
    if (rightLensDate.value == null || leftLensDate.value == null) {
      await updateLensesDates(leftDate: null, rightDate: null);
    } else {
      await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return PutOnEndSheet(
            onLeftConfirmed: () {
              updateLensesDates(
                leftDate: null,
                rightDate: rightLensDate.value!.dateStart,
              );
              Navigator.of(context).pop();
            },
            onRightConfirmed: () {
              updateLensesDates(
                leftDate: leftLensDate.value!.dateStart,
                rightDate: null,
              );
              Navigator.of(context).pop();
            },
            onBothConfirmed: () async {
              Navigator.of(context).pop();
              await updateLensesDates(
                leftDate: null,
                rightDate: null,
              );
            },
          );
        },
      );
    }
  }

  Future<List<RecommendedProductModel>> loadRecommendedProducts({
    required int? productId,
  }) async {
    try {
      final products =
          await myLensesRequester.loadRecommendedProducts(productId: productId);
      return products.products;
    } catch (e) {
      debugPrint('loadLensesDates $e');
      return [];
    }
  }

  void _switchPage(MyLensesPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }
}

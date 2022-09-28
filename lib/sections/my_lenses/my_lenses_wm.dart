// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/models/my_lenses/reminders_buy_model.dart';
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
  final switchAction = StreamedAction<MyLensesPage>();
  final leftLensDate = StreamedState<LensDateModel?>(null);
  final rightLensDate = StreamedState<LensDateModel?>(null);
  final wornHistoryList = StreamedState<List<LensesWornHistoryModel>>([]);
  final oldWornHistoryList = StreamedState<List<LensesWornHistoryModel>>([]);
  final productHistoryList = StreamedState<List<LensesPairModel>>([]);
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);
  final notificationStatus = StreamedState<List<String>>(['Нет', '1']);
  final multiRemindes = StreamedState<List<String>>([]);
  final dailyReminders = StreamedState<RemindersBuyModel?>(null);
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

  Future loadAllData() async {
    await loadingInProgress.accept(true);
    await loadLensesPair();
    if (lensesPairModel.value != null) {
      await recommendedProducts.accept(
        await loadRecommendedProducts(productId: currentProduct.value?.id),
      );
      await loadLensesDates();
      await loadWornHistory(showAll: false, isOld: false);
      await _loadProductsHistory();
      await _loadLensesReminders(isDaily: currentProduct.value!.lifeTime == 1);
    }
    await loadingInProgress.accept(false);
  }

  Future updateMultiReminders({
    required List<String> reminders,
    bool shouldPop = false,
  }) async {
    try {
      await myLensesRequester.updateReminders(reminders: reminders);
      await multiRemindes.accept([...reminders]);
      _setMultiRemindersStatus(reminders: reminders);
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

  Future activateOldLenses({required int pairId}) async {
    try {
      await myLensesRequester.activateOldLenses(pairId: pairId);
      await switchAction(MyLensesPage.currentLenses);
      // TODO(pavlov): проверить надо ли
      // await loadAllData();
    } catch (e) {
      debugPrint('activateOldLenses $e');
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

  Future loadWornHistory({
    required bool showAll,
    required bool isOld,
    int? pairId,
  }) async {
    try {
      if (isOld) {
        await oldWornHistoryList.accept(
          (await myLensesRequester.loadOldLensesWornHistory(
            showAll: showAll,
            pairId: pairId!,
          ))
              .wornHistory,
        );
      } else {
        await wornHistoryList.accept(
          (await myLensesRequester.loadLensesWornHistory(showAll: showAll))
              .wornHistory,
        );
      }
    } catch (e) {
      debugPrint('loadWornHistory $e');
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
      await loadWornHistory(showAll: false, isOld: false);
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

  Future updateRemindersBuy({
    required bool defaultValue,
    required bool isSubscribed,
    required String? date,
    required String? replay,
    required List<String>? reminders,
    BuildContext? context,
  }) async {
    try {
      if (isSubscribed) {
        if (defaultValue) {
          await myLensesRequester.setDefaultRemindersBuy();
        } else {
          await myLensesRequester.updateRemindersBuy(
            date: date!,
            replay: replay!,
            reminders: reminders!,
          );
        }
        await _loadDailyReminders();
        if (context != null) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      } else {
        await myLensesRequester.deleteRemindersBuy();
        await dailyReminders.accept(null);
      }
    } catch (e) {
      debugPrint('setReminders $e');
    }
  }

  Future _loadLensesReminders({required bool isDaily}) async {
    try {
      if (isDaily) {
        await _loadDailyReminders();
      } else {
        final reminders = <String>[];
        for (final element in await myLensesRequester.loadLensesReminders()) {
          reminders.add(element.toString());
        }
        await multiRemindes.accept([...reminders]);
        _setMultiRemindersStatus(reminders: reminders);
      }
    } catch (e) {
      debugPrint('loadLensesReminders $e');
    }
  }

  Future _loadDailyReminders() async {
    await dailyReminders
        .accept(await myLensesRequester.loadLensesRemindersBuy());
    if (dailyReminders.value != null &&
        dailyReminders.value!.reminders.length == 1) {
      switch (dailyReminders.value!.reminders[0]) {
        case '0':
          await notificationStatus.accept(['В день покупки', '1']);
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
      await notificationStatus
          .accept(['', (dailyReminders.value!.reminders.length).toString()]);
    }
  }

  void _setMultiRemindersStatus({required List<String> reminders}) {
    if (reminders.isEmpty) {
      notificationStatus.accept(['Нет', '1']);
    } else if (reminders.length == 1) {
      switch (reminders[0]) {
        case '0':
          notificationStatus.accept(['В день замены', '1']);
          break;
        case '1':
          notificationStatus.accept(['За 1 день', '1']);
          break;
        case '2':
          notificationStatus.accept(['За 2 дня', '1']);
          break;
        case '3':
          notificationStatus.accept(['За 3 дня', '1']);
          break;
        case '4':
          notificationStatus.accept(['За 4 дня', '1']);
          break;
        case '5':
          notificationStatus.accept(['За 5 дней', '1']);
          break;
        case '7':
          notificationStatus.accept(['За неделю', '1']);
          break;
      }
    } else {
      notificationStatus.accept(['', (reminders.length).toString()]);
    }
  }

  Future _loadProductsHistory() async {
    try {
      await productHistoryList.accept(
        (await myLensesRequester.loadLensesProductHistory()).productHistory,
      );
    } catch (e) {
      debugPrint('loadProductsHistory $e');
    }
  }

  void _switchPage(MyLensesPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }
}

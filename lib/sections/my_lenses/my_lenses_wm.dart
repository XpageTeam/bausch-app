// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/models/my_lenses/reminders_buy_model.dart';
import 'package:bausch/sections/my_lenses/requesters/my_lenses_requester.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_end_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum MyLensesPage { currentLenses, oldLenses }

extension ShopsContentTypeAsString on MyLensesPage {
  String get asString =>
      this == MyLensesPage.currentLenses ? 'Ношу' : 'Были раньше';
}

class MyLensesWM extends WidgetModel {
  final switchAction = StreamedAction<MyLensesPage>();
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);
  final leftLensDate = StreamedState<LensDateModel?>(null);
  final rightLensDate = StreamedState<LensDateModel?>(null);
  final wornHistoryList = StreamedState<List<LensesWornHistoryModel>>([]);
  final oldWornHistoryList = StreamedState<List<LensesWornHistoryModel>>([]);
  final productHistoryList = StreamedState<List<LensesPairModel>>([]);
  final remindersShowWidget = StreamedState<List<String>>(['Нет', '1']);
  final multiRemindes = StreamedState<List<String>>([]);
  final dailyReminders = StreamedState<RemindersBuyModel?>(null);
  final StreamedState<LensesPairModel?> lensesPairModel =
      StreamedState<LensesPairModel?>(null);
  final currentProduct = StreamedState<LensProductModel?>(null);
  final MyLensesRequester myLensesRequester = MyLensesRequester();
  final recommendedProducts = StreamedState<List<RecommendedProductModel>>([]);
  final loadingInProgress = StreamedState(false);
  final remindersLoading = StreamedState(false);

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
    unawaited(loadingInProgress.accept(true));
    await _loadCurrentLensesInfo();
    if (lensesPairModel.value != null) {
      await Future.wait<void>([
        recommendedProducts.accept(
          await loadRecommendedProducts(productId: currentProduct.value!.id),
        ),
        _loadLensesDates(),
        loadWornHistory(showAll: false, isOld: false),
        _loadProductsHistory(),
        _loadLensesReminders(isDaily: currentProduct.value!.lifeTime == 1),
      ]);
    }
    unawaited(loadingInProgress.accept(false));
  }

  Future activateOldLenses({
    required int pairId,
    BuildContext? context,
  }) async {
    unawaited(loadingInProgress.accept(true));
    if (context != null) {
      Navigator.of(context).pop();
    }
    unawaited(switchAction(MyLensesPage.currentLenses));
    try {
      await myLensesRequester.putOffLenses(
        leftDate: DateTime.now(),
        rightDate: DateTime.now(),
      );
      await myLensesRequester.activateOldLenses(pairId: pairId);
      await loadAllData();
    } catch (e) {
      debugPrint('activateOldLenses $e');
    }
    unawaited(loadingInProgress.accept(false));
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

  Future<List<RecommendedProductModel>> loadRecommendedProducts({
    required int productId,
  }) async {
    try {
      final products =
          await myLensesRequester.loadRecommendedProducts(productId: productId);
      return products.products;
    } catch (e) {
      debugPrint('loadRecommendedProducts $e');
      return [];
    }
  }

  Future updateMultiReminders({
    required List<String> reminders,
    bool shouldPop = false,
  }) async {
    unawaited(remindersLoading.accept(true));
    if (shouldPop) {
      Keys.mainContentNav.currentState!.pop();
    }
    try {
      await myLensesRequester.updateMultiReminders(reminders: reminders);
      unawaited(multiRemindes.accept([...reminders]));
      _setMultiRemindersStatus(reminders: reminders);
      showDefaultNotification(
        title: 'Данные успешно обновлены',
        success: true,
      );
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка обновления',
      );
      debugPrint(e.toString());
    }
    unawaited(remindersLoading.accept(false));
  }

  Future updateDailyReminders({
    required bool defaultValue,
    required bool subscribe,
    required String? date,
    required String? replay,
    required List<String>? reminders,
    BuildContext? context,
  }) async {
    unawaited(remindersLoading.accept(true));
    if (context != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
    try {
      if (subscribe) {
        if (defaultValue) {
          await myLensesRequester.setDefaultDailyReminders();
        } else {
          await myLensesRequester.updateDailyReminders(
            date: date!,
            replay: replay!,
            reminders: reminders!,
          );
        }
        await _loadDailyReminders();
      } else {
        await myLensesRequester.deleteDailyReminders();
        unawaited(dailyReminders.accept(null));
      }
      showDefaultNotification(
        title: 'Данные успешно обновлены',
        success: true,
      );
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка обновления',
      );
      debugPrint('updateDailyReminders $e');
    }
    unawaited(remindersLoading.accept(false));
  }

  Future putOnLensesPair({
    required DateTime? leftDate,
    required DateTime? rightDate,
    bool updateLeft = false,
    bool updateRight = false,
  }) async {
    unawaited(loadingInProgress.accept(true));
    try {
      await myLensesRequester.putOffLenses(
        leftDate: updateLeft ? DateTime.now() : null,
        rightDate: updateRight ? DateTime.now() : null,
      );
      await myLensesRequester.putOnLensesPair(
        leftDate: leftDate,
        rightDate: rightDate,
      );
      await Future.wait<void>([
        _loadLensesDates(),
        loadWornHistory(showAll: false, isOld: false),
      ]);
      showDefaultNotification(
        title: 'Данные успешно обновлены',
        success: true,
      );
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка обновления',
      );
      debugPrint('putOnLensesPair $e');
    }
    unawaited(loadingInProgress.accept(false));
  }

  Future updateLensesPair({
    required DateTime? leftDate,
    required DateTime? rightDate,
  }) async {
    unawaited(loadingInProgress.accept(true));
    var leftChanged = false;
    var rightChanged = false;
    if (leftDate != null) {
      leftChanged = !leftLensDate.value!.dateStart.isSameDate(leftDate);
    }
    if (rightDate != null) {
      rightChanged = !rightLensDate.value!.dateStart.isSameDate(rightDate);
    }
    try {
      await myLensesRequester.updateLensesPair(
        leftDate: leftChanged ? leftDate : null,
        rightDate: rightChanged ? rightDate : null,
      );
      await Future.wait<void>([
        _loadLensesDates(),
        loadWornHistory(showAll: false, isOld: false),
      ]);
      showDefaultNotification(
        title: 'Данные успешно обновлены',
        success: true,
      );
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка обновления',
      );
      debugPrint('updateLensesPair $e');
    }
    unawaited(loadingInProgress.accept(false));
  }

  Future putOffLensesSheet({required BuildContext context}) async {
    if (rightLensDate.value == null || leftLensDate.value == null) {
      await _putOffLensesPair(left: true, right: true);
    } else {
      await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return PutOnEndSheet(
            onLeftConfirmed: () async {
              Navigator.of(context).pop();
              await _putOffLensesPair(left: true, right: false);
            },
            onRightConfirmed: () async {
              Navigator.of(context).pop();
              await _putOffLensesPair(left: false, right: true);
            },
            onBothConfirmed: () async {
              Navigator.of(context).pop();
              await _putOffLensesPair(left: true, right: true);
            },
          );
        },
      );
    }
  }

  Future _putOffLensesPair({required bool left, required bool right}) async {
    unawaited(loadingInProgress.accept(true));
    try {
      await myLensesRequester.putOffLenses(
        leftDate: left ? DateTime.now() : null,
        rightDate: right ? DateTime.now() : null,
      );
      await Future.wait<void>([
        _loadLensesDates(),
        loadWornHistory(showAll: false, isOld: false),
      ]);
      showDefaultNotification(
        title: 'Данные успешно обновлены',
        success: true,
      );
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка обновления',
      );
      debugPrint('putOffLensesPair $e');
    }
    unawaited(loadingInProgress.accept(false));
  }

  Future _loadCurrentLensesInfo() async {
    try {
      await lensesPairModel
          .accept(await myLensesRequester.loadChosenLensesInfo());
      // await lensesPairModel.accept(null);
      unawaited(currentProduct.accept(lensesPairModel.value?.product));
    } catch (e) {
      debugPrint('_loadCurrentLensesInfo $e');
    }
  }

  Future _loadLensesDates() async {
    try {
      final lensesDates = await myLensesRequester.loadLensesDates();
      unawaited(rightLensDate.accept(lensesDates.right));
      unawaited(leftLensDate.accept(lensesDates.left));
    } catch (e) {
      debugPrint('loadLensesDates $e');
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
        unawaited(multiRemindes.accept([...reminders]));
        _setMultiRemindersStatus(reminders: reminders);
      }
    } catch (e) {
      debugPrint('loadLensesReminders $e');
    }
  }

  Future _loadDailyReminders() async {
    await dailyReminders
        .accept(await myLensesRequester.loadLensesRemindersBuy());
    if (dailyReminders.value!.reminders.isEmpty) {
      unawaited(remindersShowWidget.accept(['Нет', '1']));
    } else if (dailyReminders.value!.reminders.length == 1) {
      switch (dailyReminders.value!.reminders[0]) {
        case '0':
          unawaited(remindersShowWidget.accept(['В день покупки', '1']));
          break;
        case '1':
          unawaited(remindersShowWidget.accept(['За неделю', '1']));
          break;
      }
    } else {
      unawaited(remindersShowWidget
          .accept(['', (dailyReminders.value!.reminders.length).toString()]));
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

  void _setMultiRemindersStatus({required List<String> reminders}) {
    if (reminders.isEmpty) {
      remindersShowWidget.accept(['Нет', '1']);
    } else if (reminders.length == 1) {
      switch (reminders[0]) {
        case '0':
          remindersShowWidget.accept(['В день замены', '1']);
          break;
        case '1':
          remindersShowWidget.accept(['За неделю', '1']);
          break;
      }
    } else {
      remindersShowWidget.accept(['', (reminders.length).toString()]);
    }
  }

  void _switchPage(MyLensesPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }
}

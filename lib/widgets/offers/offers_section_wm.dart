import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/repositories/offers/offers_repository.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OffersSectionWM extends WidgetModel {
  final OfferType type;
  final int? goodID;
  final offersStreamed = EntityStreamedState<List<Offer>>();
  final removeOfferAction = StreamedAction<Offer>();
  final loadDataAction = VoidAction();
  final changeAppLifecycleStateAction = StreamedAction<AppLifecycleState>();

  final BuildContext context;
  final OffersRepository? loadedRepository;
  late final userWM = Provider.of<UserWM>(context, listen: false);

  late SharedPreferences preferences;

  Timer? updateTimer;

  bool canUpdate = true;

  OffersSectionWM({
    required this.type,
    required this.context,
    this.loadedRepository,
    this.goodID,
  }) : super(const WidgetModelDependencies());

  @override
  Future<void> onLoad() async {
    preferences = await SharedPreferences.getInstance();

    if (loadedRepository == null) {
      loadDataAction.bind((_) {
        loadData();
      });

      updateTimer = Timer.periodic(const Duration(minutes: 3), (_) {
        if (canUpdate) {
          loadDataAction();
        }
      });

      unawaited(loadDataAction());
    } else {
      unawaited(offersStreamed.content(
        await _filterOffers(
          loadedRepository!.offerList,
        ),
      ));
    }

    subscribe<AppLifecycleState>(
      changeAppLifecycleStateAction.stream,
      _changeAppLifecycleState,
    );

    super.onLoad();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  @override
  void onBind() {
    removeOfferAction.bind(
      (offer) {
        if (offer != null) {
          _writeRemovedOfferId(offer.id);

          offersStreamed.value.data?.remove(offer);
          offersStreamed.accept(offersStreamed.value);
        }
      },
    );

    super.onBind();
  }

  Future<void> loadData() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    await userWM.updateUserDataAction();

    if (offersStreamed.value.isLoading) return;

    unawaited(offersStreamed.loading(offersStreamed.value.data));

    try {
      final repository = await OffersRepositoryDownloader.load(
        type: type.asString,
        goodID: goodID,
      );

      final filteredOffers = _filterOffers(
        repository.offerList,
      );

      unawaited(offersStreamed.content(await filteredOffers));
    } on DioError catch (e) {
      unawaited(
        offersStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        offersStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        offersStreamed.error(
          CustomException(
            title: e.toString(),
          ),
        ),
      );
    }
  }

  void _changeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        canUpdate = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        canUpdate = false;
        break;
    }
  }

  Future<List<Offer>> _filterOffers(List<Offer> offers) async {
    final closedOffersIds = (await _readRemovedOffersIds()).map(
      int.parse,
    );
    return offers
      ..removeWhere(
        (offer) => closedOffersIds.any(
          (id) => id == offer.id,
        ),
      );
  }

  Future<List<String>> _readRemovedOffersIds() async {
    return preferences.getStringList(
          'type[${type.asString}]user[${userWM.userData.value.data?.user.id}]${StaticData.removedOffersKey}',
        ) ??
        <String>[];
  }

  Future<void> _writeRemovedOfferId(int id) async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    final removedOffersIds = (await _readRemovedOffersIds())
      ..add(
        id.toString(),
      );

    await preferences.setStringList(
      'type[${type.asString}]user[${userWM.userData.value.data?.user.id}]${StaticData.removedOffersKey}',
      removedOffersIds
          .map(
            (e) => e.toString(),
          )
          .toList(),
    );
  }
}

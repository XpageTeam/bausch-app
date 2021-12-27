import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/repositories/offers/offers_repository.dart';
import 'package:bausch/sections/home/sections/offers/offer_type.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OffersSectionWM extends WidgetModel {
  final OfferType type;
  final int? goodID;
  final offersStreamed = EntityStreamedState<List<Offer>>();
  final removeOfferAction = StreamedAction<Offer>();

  late SharedPreferences preferences;

  OffersSectionWM({
    required this.type,
    this.goodID,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  Future<void> onLoad() async {
    preferences = await SharedPreferences.getInstance();
    unawaited(_loadData());
    super.onLoad();
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

  Future<void> _loadData() async {
    unawaited(offersStreamed.loading());

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
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
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
    return preferences.getStringList(StaticData.removedOffersKey) ?? <String>[];
  }

  Future<void> _writeRemovedOfferId(int id) async {
    final removedOffersIds = (await _readRemovedOffersIds())
      ..add(
        id.toString(),
      );

    await preferences.setStringList(
      StaticData.removedOffersKey,
      removedOffersIds
          .map(
            (e) => e.toString(),
          )
          .toList(),
    );
  }
}
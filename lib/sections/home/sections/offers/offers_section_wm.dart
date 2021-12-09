import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/repositories/offers/offers_repository.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:dio/dio.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OffersSectionWM extends WidgetModel {
  final OfferType type;
  final int? goodID;
  final offersStreamed = EntityStreamedState<List<Offer>>();

  OffersSectionWM({
    required this.type,
    this.goodID,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _loadData();
    super.onLoad();
  }

  Future<void> _loadData() async {
    unawaited(offersStreamed.loading());

    try {
      final repository = await OffersRepositoryDownloader.load(
        type: _convertEnumToString(type),
        goodID: goodID,
      );
      unawaited(
        offersStreamed.content(repository.offerList),
      );
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

  String _convertEnumToString(OfferType type) {
    switch (type) {
      case OfferType.homeScreen:
        return 'index';
      case OfferType.notificationsScreen:
        return 'notifications';
      case OfferType.offline:
        return 'offline';
      case OfferType.promoCodeImmediately:
        return 'promo_code_immediately';
      case OfferType.freeProduct:
        return 'free_product';
      case OfferType.onlineShop:
        return 'onlineShop';
      case OfferType.promoCodeVideo:
        return 'promo_code_video';
      case OfferType.onlineConsultation:
        return 'online_consultation';
      case OfferType.good:
        return 'good';

      default:
        return 'index';
    }
  }
}

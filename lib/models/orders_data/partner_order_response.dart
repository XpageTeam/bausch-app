// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/orders_data/order_data.dart';

class PartnerOrderResponse extends OrderData {
  PartnerOrderResponse({
    required int id,
    required String? promoCode,
    String? title,
    String? subtitle,
  }) : super(
          orderID: id,
          title: title,
          subtitle: subtitle,
          promoCode: promoCode,
        );

  factory PartnerOrderResponse.fromMap(Map<String, dynamic> map) {
    try {
      return PartnerOrderResponse(
        id: map['orderId'] as int,
        title: map['title'] as String?,
        subtitle: map['subtitle'] as String?,
        promoCode: map['promoCode'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('PartnerOrderResponse: $e');
    }
  }
}

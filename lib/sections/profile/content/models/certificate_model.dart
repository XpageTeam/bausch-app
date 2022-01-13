// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';

class CertificateOrderModel extends BaseOrderModel {
  final Coupon coupon;

  CertificateOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required this.coupon,
  }) : super(
          id: id,
          category: category,
          date: date,
          price: price,
          status: status,
          title: title,
        );

  factory CertificateOrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return CertificateOrderModel(
        id: map['id'] as int,
        category: map['category'] as String,
        date: DateTime.parse(map['date'] as String),
        price: map['price'] as int,
        status: map['status'] as String,
        title: map['title'] as String,
        coupon: Coupon.fromMap(map['coupon'] as Map<String, dynamic>),
      );
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

class Coupon {
  final String code;

  const Coupon({
    required this.code,
  });

  factory Coupon.fromMap(Map<String, dynamic> map) {
    try {
      return Coupon(code: map['code'] as String);
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

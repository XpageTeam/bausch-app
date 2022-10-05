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
    String? promocodeDate,
  }) : super(
          id: id,
          category: category,
          date: date,
          price: price,
          status: status,
          title: title,
          promocodeDate: promocodeDate,
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
        promocodeDate: map['promocodeData'] as String?,
      );
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

class Coupon {
  final String? code;
  final String? title;
  final String? warning;

  const Coupon({
    required this.code,
    this.title,
    this.warning,
  });

  factory Coupon.fromMap(Map<String, dynamic> map) {
    try {
      return Coupon(
        code: map['code'] as String? ?? '',
        title: map['title'] as String?,
        warning: map['warning'] as String?,
      );
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

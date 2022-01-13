import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/certificate_model.dart';

class PartnerOrderModel extends BaseOrderModel {
  final OrderProductModel product;
  final Coupon coupon;

  PartnerOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required this.product,
    required this.coupon,
  }) : super(
          id: id,
          category: category,
          date: date,
          price: price,
          status: status,
          title: title,
        );

  factory PartnerOrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return PartnerOrderModel(
        id: map['id'] as int,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        price: map['price'] as int,
        status: map['status'] as String,
        category: map['category'] as String,
        product:
            OrderProductModel.fromMap(map['product'] as Map<String, dynamic>),
        coupon: Coupon.fromMap(map['coupon'] as Map<String, dynamic>),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

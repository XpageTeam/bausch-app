import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';

class ProductOrderModel extends BaseOrderModel {
  final String? deliveryText;

  const ProductOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required OrderProductModel product,
    this.deliveryText,
  }) : super(
          id: id,
          category: category,
          date: date,
          price: price,
          product: product,
          status: status,
          title: title,
        );

  factory ProductOrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return ProductOrderModel(
        id: map['id'] as int,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        price: map['price'] as int,
        status: map['status'] as String,
        category: map['category'] as String,
        product:
            OrderProductModel.fromMap(map['product'] as Map<String, dynamic>),
        deliveryText: map['delivery'] as String?,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

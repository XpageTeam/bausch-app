// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';

class ConsultationOrderModel extends BaseOrderModel {
  final OrderProductModel product;

  ConsultationOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required this.product,
  }) : super(
          id: id,
          category: category,
          date: date,
          price: price,
          status: status,
          title: title,
        );

  factory ConsultationOrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return ConsultationOrderModel(
        id: map['id'] as int,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        price: map['price'] as int,
        status: map['status'] as String,
        category: map['category'] as String,
        product:
            OrderProductModel.fromMap(map['product'] as Map<String, dynamic>),
      );
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

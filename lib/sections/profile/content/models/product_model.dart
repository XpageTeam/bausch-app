import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';

class ProductOrderModel extends BaseOrderModel {
  final String? deliveryText;
  final OrderProductModel product;

  const ProductOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required this.product,
    String? promocodeDate,
    this.deliveryText,
  }) : super(
          id: id,
          category: category,
          date: date,
          price: price,
          status: status,
          title: title,
          promocodeDate: promocodeDate,
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
        promocodeDate: map['promocodeData'] as String?,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('ProductOrderModel: ${e.toString()}');
    }
  }
}

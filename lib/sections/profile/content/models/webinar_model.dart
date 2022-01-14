import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';

class WebinarOrderModel extends BaseOrderModel {
  final List<String> videoList;
  final OrderProductModel product;

  WebinarOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required this.product,
    required this.videoList,
  }) : super(
          id: id,
          title: title,
          date: date,
          price: price,
          status: status,
          category: category,
        );

  factory WebinarOrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return WebinarOrderModel(
        id: map['id'] as int,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        price: map['price'] as int,
        status: map['status'] as String,
        category: map['category'] as String,
        product:
            OrderProductModel.fromMap(map['product'] as Map<String, dynamic>),
        // ignore: avoid_annotating_with_dynamic
        videoList: (map['videoIds'] as List<dynamic>).map((dynamic item) {
          return item as String;
        }).toList(),
      );
    } on ResponseParseException {
      rethrow;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('WebinarOrderModel: ${e.toString()}');
    }
  }
}

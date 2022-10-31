import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/certificate_model.dart';
import 'package:intl/intl.dart';

class OfflineOrderModel extends BaseOrderModel {
  final Coupon coupon;
  final OrderProductModel product;
  final String? link;

  DateTime? get promocodeDateTime => promocodeDate != null
      ? DateFormat('dd.MM.yyyy').parse(promocodeDate!)
      : null;

  const OfflineOrderModel({
    required int id,
    required String title,
    required DateTime date,
    required int price,
    required String status,
    required String category,
    required this.product,
    required this.coupon,
    required this.link,
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

  factory OfflineOrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return OfflineOrderModel(
        id: map['id'] as int,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        price: map['price'] as int,
        status: map['status'] as String,
        category: map['category'] as String,
        product:
            OrderProductModel.fromMap(map['product'] as Map<String, dynamic>),
        coupon: Coupon.fromMap(map['coupon'] as Map<String, dynamic>),
        promocodeDate: map['promocodeData'] as String?,
        link: map['link'] as String?,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('OfflineOrderModel: ${e.toString()}');
    }
  }
}

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:intl/intl.dart';

abstract class BaseOrderModel {
  final int id;
  final String title;
  final DateTime date;
  final int price;
  final String status;
  final String category;
  // final DateTime endDate;

  String get formatedDate => DateFormat('dd.MM.yyyy').format(date);

  //  String get formatedEndDate => DateFormat('dd.MM.yyyy').format(endDate);

  const BaseOrderModel({
    required this.id,
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.category,
    // required this.endDate,
  });
}

class OrderProductModel {
  final int id;
  final String? imageLink;

  const OrderProductModel({
    required this.id,
    this.imageLink,
  });

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    try {
      return OrderProductModel(
        id: map['id'] as int,
        imageLink: map['pic'] as String?,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('OrderProductModel: ${e.toString()}');
    }
  }
}

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';

class LensesHistoryListModel {
  final List<LensesHistoryModel> lensesHistory;

  LensesHistoryListModel({
    required this.lensesHistory,
  });

  factory LensesHistoryListModel.fromMap(List<dynamic> parsedJson) {
    final historyList = parsedJson
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic i) =>
            LensesHistoryModel.fromMap(i as Map<String, dynamic>))
        .toList();

    return LensesHistoryListModel(
      lensesHistory: historyList,
    );
  }
}

class LensesHistoryModel {
  final int productId;
  final int pairId;
  final DateTime startDate;
  final DateTime endDate;
  final PairModel? left;
  final PairModel? right;

  LensesHistoryModel({
    required this.productId,
    required this.pairId,
    required this.startDate,
    required this.endDate,
    required this.left,
    required this.right,
  });

  factory LensesHistoryModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensesHistoryModel(
        productId: map['product_id'] as int,
        pairId: map['pair_id'] as int,
        startDate: map['start_date'] as DateTime,
        endDate: map['end_date'] as DateTime,
        left: map['left'] as PairModel?,
        right: map['right'] as PairModel?,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesHistoryModel: $e');
    }
  }
}

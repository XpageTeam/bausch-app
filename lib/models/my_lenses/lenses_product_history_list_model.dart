import 'package:bausch/models/my_lenses/lenses_pair_model.dart';

class LensesProductHistoryListModel {
  final List<LensesPairModel> productHistory;

  LensesProductHistoryListModel({
    required this.productHistory,
  });

  factory LensesProductHistoryListModel.fromMap(List<dynamic> parsedJson) {
    final historyList = parsedJson
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic i) =>
            LensesPairModel.fromMap(i as Map<String, dynamic>))
        .toList();

    return LensesProductHistoryListModel(productHistory: historyList);
  }
}


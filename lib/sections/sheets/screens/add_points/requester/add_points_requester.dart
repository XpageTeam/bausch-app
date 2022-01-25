// ignore_for_file: avoid_catches_without_on_clauses, avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class AddPointsRequester {
  final _rh = RequestHandler();

  Future<List<AddPointsModel>> loadAddMore() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>('/user/points/more/')).data!,
    );

    try {
      return (parsedData.data as List<dynamic>).map((dynamic item) {
        if ((item as Map<String, dynamic>).containsValue('quiz')) {
          return QuizModel.fromMap(item);
        } else {
          return AddPointsModel.fromMap(item);
        }
      }).toList();
    } on ResponseParseException{
      rethrow;
    } catch (e) {
      throw ResponseParseException('loadAddMore: $e');
    }
  }
}

import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/models/add_points/detail_model.dart';
import 'package:bausch/models/add_points/preview_model.dart';
import 'package:bausch/models/add_points/quiz/other_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_content_model.dart';
import 'package:bausch/models/mappable_object.dart';

class QuizModel extends AddPointsModel {
  final List<QuizContentModel> content;

  QuizModel({
    required int id,
    required String type,
    required String reward,
    required PreviewModel previewModel,
    required DetailModel detailModel,
    required this.content,
  }) : super(
          id: id,
          type: type,
          reward: reward,
          previewModel: previewModel,
          detailModel: detailModel,
        );

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] as int,
      reward: map['reward'] as String,
      type: map['type'] as String,
      previewModel:
          PreviewModel.fromMap(map['preview'] as Map<String, dynamic>),
      detailModel: DetailModel.fromMap(map['detail'] as Map<String, dynamic>),
      content: (map['quiz'] as List<dynamic>)
          .map((dynamic cont) =>
              QuizContentModel.fromMap(cont as Map<String, dynamic>))
          .toList(),
    );
  }
}

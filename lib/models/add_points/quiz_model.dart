import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/models/add_points/detail_model.dart';
import 'package:bausch/models/add_points/preview_model.dart';
import 'package:bausch/models/mappable_object.dart';

class QuizModel extends AddPointsModel {
  QuizModel({
    required int id,
    required String type,
    required String reward,
    required PreviewModel previewModel,
    required DetailModel detailModel,
  }) : super(
          id: id,
          type: type,
          reward: reward,
          previewModel: previewModel,
          detailModel: detailModel,
        );
}

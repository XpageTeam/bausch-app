import 'package:bausch/models/add_points/detail_model.dart';
import 'package:bausch/models/add_points/preview_model.dart';

class AddPointsModel {
  final int id;

  final String reward;

  final String type;

  final PreviewModel previewModel;

  final DetailModel detailModel;

  AddPointsModel({
    required this.id,
    required this.reward,
    required this.type,
    required this.previewModel,
    required this.detailModel,
  });

  factory AddPointsModel.fromMap(Map<String, dynamic> map) {
    return AddPointsModel(
      id: map['id'] as int,
      reward: map['reward'] as String,
      type: map['type'] as String,
      previewModel:
          PreviewModel.fromMap(map['preview'] as Map<String, dynamic>),
      detailModel: DetailModel.fromMap(map['detail'] as Map<String, dynamic>),
    );
  }
}

// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/add_points/detail_model.dart';
import 'package:bausch/models/add_points/preview_model.dart';

class AddPointsModel {
  final int id;

  final String reward;

  final String type;

  final String? url;

  final PreviewModel previewModel;

  final DetailModel detailModel;

  AddPointsModel({
    required this.id,
    required this.reward,
    required this.type,
    required this.previewModel,
    required this.detailModel,
    this.url,
  });

  factory AddPointsModel.fromMap(Map<String, dynamic> map) {
    try {
      return AddPointsModel(
        id: map['id'] as int,
        reward: map['reward'] as String,
        type: map['type'] as String,
        previewModel:
            PreviewModel.fromMap(map['preview'] as Map<String, dynamic>),
        detailModel: DetailModel.fromMap(map['detail'] as Map<String, dynamic>),
        url: map['url'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('AddPointsModel: $e');
    }
  }
}

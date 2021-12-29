import 'package:bausch/models/mappable_object.dart';

class PreviewModel implements MappableInterface<PreviewModel> {
  final String title;

  final String description;

  PreviewModel({
    required this.title,
    required this.description,
  });

  factory PreviewModel.fromMap(Map<String, dynamic> map) {
    return PreviewModel(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO(all): implement toMap
    throw UnimplementedError();
  }
}

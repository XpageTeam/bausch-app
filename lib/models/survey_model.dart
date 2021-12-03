import 'package:bausch/models/mappable_object.dart';

class SurveyModel implements MappableInterface<SurveyModel> {
  final String text;

  SurveyModel({
    required this.text,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

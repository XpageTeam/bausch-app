import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/mappable_object.dart';

class TopicModel implements MappableInterface<TopicModel> {
  final int id;
  final String title;
  final List<QuestionModel> questions;

  TopicModel({required this.id, required this.title, required this.questions});

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      id: map['id'] as int,
      title: map['title'] as String,
      questions: (map['questions'] as List<dynamic>)
          .map((dynamic e) => QuestionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

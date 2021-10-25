import 'package:bausch/models/mappable_object.dart';

class QuestionModel implements MappableInterface<QuestionModel> {
  final int id;
  final String title;
  final String answer;

  QuestionModel({required this.id, required this.title, required this.answer});

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      answer: map['answer'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

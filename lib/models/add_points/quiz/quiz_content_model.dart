import 'package:bausch/models/add_points/quiz/other_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_answer_model.dart';

class QuizContentModel {
  final String title;
  final String id;
  final bool isRequired;
  final String type;
  final List<QuizAnswerModel> answers;
  final OtherModel? other;

  QuizContentModel({
    required this.title,
    required this.id,
    required this.isRequired,
    required this.type,
    required this.answers,
    this.other,
  });

  factory QuizContentModel.fromMap(Map<String, dynamic> map) {
    return QuizContentModel(
      title: map['title'] as String,
      id: map['id'] as String,
      isRequired: map['required'] as bool,
      type: map['type'] as String,
      answers: (map['answers'] as List<dynamic>)
          .map(
            (dynamic answer) =>
                QuizAnswerModel.fromMap(answer as Map<String, dynamic>),
          )
          .toList(),
      other: map['other'] != null
          ? OtherModel.fromMap(map['other'] as Map<String, dynamic>)
          : null,
    );
  }
}

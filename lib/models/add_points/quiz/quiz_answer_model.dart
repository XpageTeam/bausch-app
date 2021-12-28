class QuizAnswerModel {
  final String id;
  final String title;

  QuizAnswerModel({
    required this.id,
    required this.title,
  });

  factory QuizAnswerModel.fromMap(Map<String, dynamic> map) {
    return QuizAnswerModel(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }
}

class QuizAnswerModel {
  final String id;
  final String title;
  final String type;

  QuizAnswerModel({
    required this.id,
    required this.title,
    required this.type,
  });

  factory QuizAnswerModel.fromMap(Map<String, dynamic> map, String type) {
    return QuizAnswerModel(
      id: map['id'] as String,
      title: map['title'] as String,
      type: type,
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

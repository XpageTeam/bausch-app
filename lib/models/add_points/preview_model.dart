

class PreviewModel{
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

}

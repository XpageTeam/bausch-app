class OtherModel {
  final String id;
  final String title;

  OtherModel({
    required this.id,
    required this.title,
  });

  factory OtherModel.fromMap(Map<String, dynamic> map) {
    return OtherModel(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }
}

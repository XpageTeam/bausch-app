class SpecificationModel {
  final String title;
  final String value;

  SpecificationModel({
    required this.title,
    required this.value,
  });

  factory SpecificationModel.fromMap(Map<String, dynamic> map) {
    return SpecificationModel(
      title: map['title'] as String,
      value: map['value'] as String,
    );
  }
}

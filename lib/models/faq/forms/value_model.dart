class ValueModel {
  final int id;
  final String name;

  ValueModel({
    required this.id,
    required this.name,
  });

  factory ValueModel.fromMap(Map<String, dynamic> map) {
    return ValueModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}

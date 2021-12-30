

class ProductCodeModel  {
  final int id;
  final String title;
  final String code;

  ProductCodeModel({
    required this.id,
    required this.title,
    required this.code,
  });

  factory ProductCodeModel.fromMap(Map<String, dynamic> map) {
    return ProductCodeModel(
      id: map['id'] as int,
      title: map['title'] as String,
      code: map['code'] as String,
    );
  }


}

class ProductModel {
  final String title;
  final String picture;

  ProductModel({
    required this.title,
    required this.picture,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] as String,
      picture: map['picture'] as String,
    );
  }
}

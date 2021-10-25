import 'package:bausch/models/mappable_object.dart';

class StoryContentModel implements MappableInterface<StoryContentModel> {
  final String title;
  final String file;

  StoryContentModel({required this.title, required this.file});

  factory StoryContentModel.fromMap(Map<String, dynamic> map) {
    return StoryContentModel(
      title: (map['title'] ?? 'kek') as String,
      file:
          ('https://baush-app.xpager.ru/upload/uf/e0e/ge4ml2lkuiwovx8yyclujb9l7pda3jm1.jpg')
              as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

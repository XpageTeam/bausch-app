import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class StoryContentModel implements MappableInterface<StoryContentModel> {
  //* Текст(отображается на главном экране)
  final String title;

  //* Ссылка на картинку или видео
  final String file;

  StoryContentModel({required this.title, required this.file});

  factory StoryContentModel.fromMap(Map<String, dynamic> map) {
    if (map['title'] == null) {
      throw ResponseParseExeption('Не передано название истории');
    }

    if (map['file'] == null) {
      throw ResponseParseExeption('Не передана ссылка на файл');
    }

    return StoryContentModel(
      title: (map['title'] ?? 'kek') as String,
      file: (map['file'] ??
              'https://baush-app.xpager.ru/upload/uf/e0e/ge4ml2lkuiwovx8yyclujb9l7pda3jm1.jpg')
          as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'file': file,
    };
  }
}

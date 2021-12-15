import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/story_model.dart';

class StoryContentModel implements MappableInterface<StoryContentModel> {
  //* Текст(отображается на главном экране)
  final String title;

  //* Ссылка на картинку или видео
  final String file;

  final Duration duration;

  //* Картинка или видео
  final MediaType media;

  StoryContentModel({
    required this.title,
    required this.file,
    this.duration = const Duration(seconds: 3),
    this.media = MediaType.image,
  });

  factory StoryContentModel.fromMap(Map<String, dynamic> map) {
    if (map['title'] == null) {
      throw ResponseParseException('Не передано название истории');
    }

    if (map['file'] == null) {
      throw ResponseParseException('Не передана ссылка на файл');
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

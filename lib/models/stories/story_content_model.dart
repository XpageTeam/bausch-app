import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/story_model.dart';

class StoryContentModel implements MappableInterface<StoryContentModel> {
  //* Текст(отображается на главном экране)
  final String title;

  //* Ссылка на картинку или видео
  final String file;

  final String preview;

  final Duration duration;

  final String textBtn;

  final String link;

  final bool isVideo;

  StoryContentModel({
    required this.title,
    required this.file,
    required this.preview,
    required this.textBtn,
    required this.link,
    required this.isVideo,
    this.duration = const Duration(seconds: 3),
  });

  factory StoryContentModel.fromMap(Map<String, dynamic> map) {
    if (map['title'] == null) {
      throw ResponseParseException('Не передано название истории');
    }

    if (map['file'] == null) {
      throw ResponseParseException('Не передана ссылка на файл');
    }

    if (map['textBtn'] == null) {
      throw ResponseParseException('Не передан текст кнопки');
    }

    if (map['link'] == null) {
      throw ResponseParseException('Не передана ссылка для кнопки');
    }

    return StoryContentModel(
      title: (map['title'] ?? 'Title') as String,
      file: map['file'] as String,
      preview: map['preview'] as String,
      link: map['link'] as String,
      textBtn: map['textBtn'] as String,
      isVideo: map['isVideo'] as bool,
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

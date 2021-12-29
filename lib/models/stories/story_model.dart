// ignore_for_file: avoid_annotating_with_dynamic, unused_import

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';

enum MediaType {
  image,
  video,
}

class StoryModel implements MappableInterface<StoryModel> {
  //* Идентификатр истории
  final int id;

  //* Название и ссылка на картинку
  final List<StoryContentModel> content;

  final int views;

  const StoryModel({
    //required this.url,
    //required this.media,
    //required this.duration,
    required this.id,
    required this.content,
    required this.views,
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['id'] is! int) {
      throw ResponseParseException('Не передан идентификатор истории');
    }

    return StoryModel(
      content: (map['content'] as List<dynamic>)
          .map((dynamic story) =>
              StoryContentModel.fromMap(story as Map<String, dynamic>))
          .toList(),
      //media: MediaType.image,
      id: map['id'] as int,
      views: map['views'] as int,
      //duration: const Duration(seconds: 5),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
    };
  }
}

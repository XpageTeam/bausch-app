// ignore_for_file: avoid_annotating_with_dynamic, unused_import, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class StoryWM extends WidgetModel {
  final int id;
  final StreamedState<int> viewsConunt;

  StoryWM({
    required this.id,
    required int views,
  })  : viewsConunt = StreamedState(views),
        super(const WidgetModelDependencies());
}

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

  final StoryWM wm;

  StoryModel({
    required this.id,
    required this.content,
    required this.views,
  }) : wm = StoryWM(
          id: id,
          views: views,
        );

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['id'] is! int) {
      throw ResponseParseException('Не передан идентификатор истории');
    }

    try {
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
    } catch (e) {
      throw ResponseParseException('StoryModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
    };
  }
}

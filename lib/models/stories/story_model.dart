// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';

enum MediaType {
  image,
  video,
}

class StoryModel implements MappableInterface<StoryModel> {
  //final String url;
  final MediaType media;
  final Duration duration;
  final int id;
  final StoryContentModel content;
  final String? buttonTitle;
  final String? mainText;
  final String? secondText;

  const StoryModel({
    //required this.url,
    required this.media,
    required this.duration,
    required this.id,
    required this.content,
    this.buttonTitle,
    this.mainText,
    this.secondText,
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      content: StoryContentModel.fromMap(
        map['content'] as Map<String, dynamic>,
      ),
      media: MediaType.image,
      id: map['id'] as int,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

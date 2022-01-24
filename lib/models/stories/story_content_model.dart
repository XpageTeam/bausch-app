// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/product_model.dart';

class StoryContentModel implements MappableInterface<StoryContentModel> {
  //final int id;

  //* Текст(отображается на главном экране)
  final String title;

  final String? description;

  final ProductModel? productModel;

  //* Ссылка на картинку или видео
  final String? file;

  final String preview;

  final Duration duration;

  final String? textBtn;

  final String? link;

  final String? textAfter;

  final bool isVideo;

  StoryContentModel({
    //required this.id,
    required this.isVideo,
    required this.preview,
    required this.title,
    this.productModel,
    this.file,
    this.textBtn,
    this.link,
    this.description,
    this.textAfter,
    this.duration = const Duration(seconds: 5),
  });

  factory StoryContentModel.fromMap(Map<String, dynamic> map) {
    if (map['title'] == null) {
      throw ResponseParseException('Не передано название истории');
    }

    try {
      return StoryContentModel(
        //id: map['id'] as int,
        title: (map['title'] ?? 'Title') as String,
        description: map['description'] as String,
        productModel: map['product'] != null
            ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
            : null,
        file: map['file'] as String,
        preview: map['preview'] as String,
        link: map['link'] as String,
        textBtn: map['text_btn'] as String,
        textAfter: map['text_after'] as String,
        isVideo: map['is_video'] as bool,
      );
    } catch (e) {
      throw ResponseParseException('StoryContentModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'file': file,
    };
  }
}

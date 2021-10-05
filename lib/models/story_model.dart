import 'package:bausch/models/mappable_object.dart';

class StoryModel implements MappableInterface<StoryModel> {
  final int number;
  final String title;
  final String? img;

  StoryModel({required this.number, required this.title, this.img});

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

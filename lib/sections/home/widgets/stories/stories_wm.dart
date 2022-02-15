import 'package:bausch/models/stories/story_model.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class StoriesWM extends WidgetModel {
  final List<StoryModel> stories;
  StoriesWM({
    required this.stories,
  }) : super(const WidgetModelDependencies());
}

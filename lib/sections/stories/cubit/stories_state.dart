part of 'stories_cubit.dart';

@immutable
abstract class StoriesState {
  final List<StoryModel?>? stories;

  const StoriesState({this.stories});
}

class StoriesInitial extends StoriesState {}

class StoriesFailed extends StoriesState {
  final String title;
  final String? subtitle;

  const StoriesFailed({required this.title, this.subtitle});
}

class StoriesLoading extends StoriesState {
  const StoriesLoading({List<StoryModel?>? stories}) : super(stories: stories);
}

class StoriesSuccess extends StoriesState {
  const StoriesSuccess({required List<StoryModel?>? stories})
      : super(stories: stories);
}

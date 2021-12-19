part of 'stories_cubit.dart';

@immutable
abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesFailed extends StoriesState {
  final String title;
  final String? subtitle;

  StoriesFailed({required this.title, this.subtitle});
}

class StoriesLoading extends StoriesState {}

class StoriesSuccess extends StoriesState {
  final List<StoryModel?> stories;

  StoriesSuccess({required this.stories});
}

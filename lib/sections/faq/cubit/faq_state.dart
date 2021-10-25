part of 'faq_cubit.dart';

@immutable
abstract class FaqState {}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqSuccess extends FaqState {
  final List<TopicModel> topics;

  FaqSuccess({required this.topics});
}

class FaqFailed extends FaqState {
  final String title;
  final String? subtitle;

  FaqFailed({required this.title, this.subtitle});
}

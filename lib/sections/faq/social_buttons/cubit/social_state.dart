part of 'social_cubit.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialSuccess extends SocialState {
  final List<SocialModel> models;

  SocialSuccess({required this.models});
}

class SocialFailed extends SocialState {
  final String title;
  final String? subtitle;

  SocialFailed({required this.title, this.subtitle});
}

part of 'add_points_bloc.dart';

@immutable
abstract class AddPointsState {}

class AddPointsInitial extends AddPointsState {}

class AddPointsLoading extends AddPointsState {}

class AddPointsFailed extends AddPointsState {
  final String title;
  final String? subtitle;

  AddPointsFailed({
    required this.title,
    this.subtitle,
  });
}

class AddPointsGetSuccess extends AddPointsState {
  final List<AddPointsModel> models;

  AddPointsGetSuccess({required this.models});
}

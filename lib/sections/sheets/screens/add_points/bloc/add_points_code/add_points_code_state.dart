part of 'add_points_code_bloc.dart';

@immutable
abstract class AddPointsCodeState {}

class AddPointsCodeInitial extends AddPointsCodeState {}

class AddPointsCodeLoading extends AddPointsCodeState {}

class AddPointsCodeGetSuccess extends AddPointsCodeState {
  final List<ProductCodeModel> models;

  AddPointsCodeGetSuccess({
    required this.models,
  });
}

class AddPointsCodeFailed extends AddPointsCodeState {
  final String title;
  final String? subtitle;

  AddPointsCodeFailed({
    required this.title,
    this.subtitle,
  });
}

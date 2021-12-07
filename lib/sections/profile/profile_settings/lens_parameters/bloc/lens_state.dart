part of 'lens_bloc.dart';

@immutable
abstract class LensState {}

class LensInitial extends LensState {}

class LensGotten extends LensState {
  final LensParametersModel model;

  LensGotten({
    required this.model,
  });
}

class LensFailed extends LensState {
  final String title;
  final String? subtitle;

  LensFailed({
    required this.title,
    this.subtitle,
  });
}

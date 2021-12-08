part of 'get_lens_cubit.dart';

@immutable
abstract class GetLensState {}

class GetLensInitial extends GetLensState {}

class GetLensGetting extends GetLensState {}

class GetLensSuccess extends GetLensState {
  final LensParametersModel model;

  GetLensSuccess({required this.model});
}

class GetLensFailed extends GetLensState {
  final String title;
  final String? subtitle;

  GetLensFailed({
    required this.title,
    this.subtitle,
  });
}

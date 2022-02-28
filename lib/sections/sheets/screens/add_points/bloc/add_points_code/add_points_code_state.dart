part of 'add_points_code_bloc.dart';

@immutable
abstract class AddPointsCodeState {
  final List<ProductCodeModel> models;
  final String code;
  final String product;

  const AddPointsCodeState({
    required this.models,
    required this.code,
    required this.product,
  });
}

class AddPointsCodeInitial extends AddPointsCodeState {
  AddPointsCodeInitial()
      : super(
          models: [],
          code: '',
          product: '',
        );
}

class AddPointsCodeLoading extends AddPointsCodeState {
  const AddPointsCodeLoading({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
  }) : super(
          models: models,
          code: code,
          product: product,
        );
}

class AddPointsCodeGetSuccess extends AddPointsCodeState {
  const AddPointsCodeGetSuccess({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
  }) : super(
          models: models,
          code: code,
          product: product,
        );
}

class AddPointsCodeUpdated extends AddPointsCodeState {
  const AddPointsCodeUpdated({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
  }) : super(
          models: models,
          code: code,
          product: product,
        );
}

class AddPointsCodeSendSuccess extends AddPointsCodeState {
  final int points;

  const AddPointsCodeSendSuccess({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required this.points,
  }) : super(
          models: models,
          code: code,
          product: product,
        );
}

class AddPointsCodeFailed extends AddPointsCodeState {
  final String title;
  final String? subtitle;

  const AddPointsCodeFailed({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required this.title,
    this.subtitle,
  }) : super(
          models: models,
          code: code,
          product: product,
        );
}

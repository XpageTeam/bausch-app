part of 'add_points_code_bloc.dart';

@immutable
abstract class AddPointsCodeState {
  final List<ProductCodeModel> models;
  final String code;
  final String product;
  final String productName;

  const AddPointsCodeState({
    required this.models,
    required this.code,
    required this.product,
    required this.productName,
  });
}

class AddPointsCodeInitial extends AddPointsCodeState {
  AddPointsCodeInitial()
      : super(
          models: [],
          code: '',
          product: '',
          productName: '',
        );
}

class AddPointsCodeLoading extends AddPointsCodeState {
  const AddPointsCodeLoading({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required String productName,
  }) : super(
          models: models,
          code: code,
          product: product,
          productName: productName,
        );
}

class AddPointsCodeGetSuccess extends AddPointsCodeState {
  const AddPointsCodeGetSuccess({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required String productName,
  }) : super(
          models: models,
          code: code,
          product: product,
          productName: productName,
        );
}

class AddPointsCodeUpdated extends AddPointsCodeState {
  const AddPointsCodeUpdated({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required String productName,
  }) : super(
          models: models,
          code: code,
          product: product,
          productName: productName,
        );
}

class AddPointsCodeSendSuccess extends AddPointsCodeState {
  final int points;

  const AddPointsCodeSendSuccess({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required this.points,
    required String productName,
  }) : super(
          models: models,
          code: code,
          product: product,
          productName: productName,
        );
}

class AddPointsCodeFailed extends AddPointsCodeState {
  final String title;
  final String? subtitle;

  const AddPointsCodeFailed({
    required List<ProductCodeModel> models,
    required String code,
    required String product,
    required String productName,
    required this.title,
    this.subtitle,
  }) : super(
          models: models,
          code: code,
          product: product,
          productName: productName,
        );
}

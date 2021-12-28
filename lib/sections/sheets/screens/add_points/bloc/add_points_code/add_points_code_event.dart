part of 'add_points_code_bloc.dart';

@immutable
abstract class AddPointsCodeEvent {}

class AddPointsCodeGet extends AddPointsCodeEvent {}

class AddPointsCodeUpdateCode extends AddPointsCodeEvent {
  final String code;

  AddPointsCodeUpdateCode({required this.code});
}

class AddPointsCodeUpdateProduct extends AddPointsCodeEvent {
  final String product;

  AddPointsCodeUpdateProduct({required this.product});
}

class AddPointsCodeSend extends AddPointsCodeEvent {
  final String code;
  final String productId;

  AddPointsCodeSend({
    required this.code,
    required this.productId,
  });
}

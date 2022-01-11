part of 'add_points_code_bloc.dart';

@immutable
abstract class AddPointsCodeEvent {
  const AddPointsCodeEvent();
}

class AddPointsCodeGet extends AddPointsCodeEvent {}

class AddPointsCodeUpdateCode extends AddPointsCodeEvent {
  final String code;

  const AddPointsCodeUpdateCode({required this.code});
}

class AddPointsCodeUpdateProduct extends AddPointsCodeEvent {
  final String product;

  const AddPointsCodeUpdateProduct({required this.product});
}

class AddPointsCodeSend extends AddPointsCodeEvent {
  final String code;
  final String productId;

  const AddPointsCodeSend({
    required this.code,
    required this.productId,
  });
}

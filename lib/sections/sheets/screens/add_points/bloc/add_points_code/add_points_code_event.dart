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
  final String productName;

  const AddPointsCodeUpdateProduct({
    required this.product,
    required this.productName,
  });
}

class AddPointsCodeSend extends AddPointsCodeEvent {
  final String code;
  final String productId;
  final String productName;

  const AddPointsCodeSend({
    required this.code,
    required this.productId,
    required this.productName,
  });
}

part of 'lens_bloc.dart';

@immutable
abstract class LensEvent {}

class LensSend extends LensEvent {
  final LensParametersModel model;

  LensSend({required this.model});
}

class LensUpdate extends LensEvent {
  final LensParametersModel model;

  LensUpdate({required this.model});
}

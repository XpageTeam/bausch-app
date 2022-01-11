part of 'lens_bloc.dart';

@immutable
abstract class LensEvent {
  const LensEvent();
}

class LensSend extends LensEvent {
  final LensParametersModel model;

  const LensSend({required this.model});
}

class LensGet extends LensEvent {}

class LensUpdate extends LensEvent {
  final LensParametersModel model;

  const LensUpdate({required this.model});
}

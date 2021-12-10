part of 'lens_bloc.dart';

@immutable
abstract class LensState {
  final LensParametersModel model;

  const LensState({required this.model});
}

class LensInitial extends LensState {
  LensInitial()
      : super(
          model: LensParametersModel(
            cylinder: 0,
            diopter: 0,
            axis: 0,
            addict: 0,
          ),
        );
}

class LensLoading extends LensState {
  const LensLoading({required LensParametersModel model})
      : super(
          model: model,
        );
}

class LensGetting extends LensState {
  const LensGetting({required LensParametersModel model})
      : super(
          model: model,
        );
}

class LensGetSuccess extends LensState {
  const LensGetSuccess({required LensParametersModel model})
      : super(
          model: model,
        );
}

class LensGetFailed extends LensState {
  final String title;
  final String? subtitle;
  LensGetFailed({
    required this.title,
    this.subtitle,
  }) : super(
          model: LensParametersModel(
            cylinder: 0,
            diopter: 0,
            axis: 0,
            addict: 0,
          ),
        );
}

class LensSuccess extends LensState {
  const LensSuccess({
    required LensParametersModel model,
  }) : super(
          model: model,
        );
}

class LensUpdated extends LensState {
  const LensUpdated({
    required LensParametersModel model,
  }) : super(
          model: model,
        );
}

// class LensSended extends LensState {
//   final LensParametersModel model;

//   LensSended({
//     required this.model,
//   });
// }

class LensFailed extends LensState {
  final String title;
  final String? subtitle;

  LensFailed({
    required this.title,
    this.subtitle,
  }) : super(
          model: LensParametersModel(
            cylinder: 0,
            diopter: 0,
            axis: 0,
            addict: 0,
          ),
        );
}

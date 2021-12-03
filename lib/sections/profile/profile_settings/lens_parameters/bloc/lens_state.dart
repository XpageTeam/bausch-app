part of 'lens_bloc.dart';

@immutable
abstract class LensState {
  final int diopter;
  final int cylinder;
  final int axis;
  final int addict;

  const LensState({
    required this.diopter,
    required this.cylinder,
    required this.axis,
    required this.addict,
  });
}

class LensInitial extends LensState {
  const LensInitial()
      : super(
          diopter: 0,
          cylinder: 0,
          axis: 0,
          addict: 0,
        );
}

class LensLoading extends LensState {
  const LensLoading({
    required int diopter,
    required int cylinder,
    required int axis,
    required int addict,
  }) : super(
          diopter: diopter,
          cylinder: cylinder,
          axis: axis,
          addict: addict,
        );
}

class LensGotten extends LensState {
  const LensGotten({
    required int diopter,
    required int cylinder,
    required int axis,
    required int addict,
  }) : super(
          diopter: diopter,
          cylinder: cylinder,
          axis: axis,
          addict: addict,
        );
}

class LensSended extends LensState {
  const LensSended({
    required int diopter,
    required int cylinder,
    required int axis,
    required int addict,
  }) : super(
          diopter: diopter,
          cylinder: cylinder,
          axis: axis,
          addict: addict,
        );
}

class LensFailed extends LensState {
  final String title;
  final String? subtitle;

  const LensFailed({
    required int diopter,
    required int cylinder,
    required int axis,
    required int addict,
    required this.title,
    this.subtitle,
  }) : super(
          diopter: diopter,
          cylinder: cylinder,
          axis: axis,
          addict: addict,
        );
}

part of 'forms_extra_bloc.dart';

@immutable
abstract class FormsExtraState {}

class FormsExtraInitial extends FormsExtraState {}

class FormsExtraLoading extends FormsExtraState {}

class FormsExtraSuccess extends FormsExtraState {
  final List<FieldModel> fields;

  FormsExtraSuccess({required this.fields});
}

class FormsExtraFailed extends FormsExtraState {
  final String title;
  final String? subtitle;

  FormsExtraFailed({
    required this.title,
    this.subtitle,
  });
}

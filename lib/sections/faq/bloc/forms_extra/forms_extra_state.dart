part of 'forms_extra_bloc.dart';

@immutable
abstract class FormsExtraState {
  const FormsExtraState();
}

class FormsExtraInitial extends FormsExtraState {}

class FormsExtraLoading extends FormsExtraState {}

class FormsExtraSuccess extends FormsExtraState {
  final List<FieldModel> fields;

  const FormsExtraSuccess({required this.fields});
}

class FormsExtraFailed extends FormsExtraState {
  final String title;
  final String? subtitle;

  const FormsExtraFailed({
    required this.title,
    this.subtitle,
  });
}

part of 'forms_cubit.dart';

@immutable
abstract class FormsState {}

class FormsInitial extends FormsState {}

class FormsLoading extends FormsState {}

class FormsSuccess extends FormsState {
  final List<FieldModel> fields;

  FormsSuccess({required this.fields});
}

class FormsFailed extends FormsState {
  final String title;
  final String? subtitle;

  FormsFailed({
    required this.title,
    required this.subtitle,
  });
}

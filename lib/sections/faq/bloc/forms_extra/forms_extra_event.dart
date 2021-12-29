part of 'forms_extra_bloc.dart';

@immutable
abstract class FormsExtraEvent {}

class FormsExtraChangeId extends FormsExtraEvent {
  final int id;

  FormsExtraChangeId({required this.id});
}

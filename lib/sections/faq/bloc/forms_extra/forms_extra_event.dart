part of 'forms_extra_bloc.dart';

@immutable
abstract class FormsExtraEvent {
  const FormsExtraEvent();
}

class FormsExtraChangeId extends FormsExtraEvent {
  final int id;

  const FormsExtraChangeId({required this.id});
}

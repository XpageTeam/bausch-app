part of 'fields_bloc.dart';

@immutable
abstract class FieldsEvent {}

class FieldsSetField extends FieldsEvent {}

class FieldsSend extends FieldsEvent {}

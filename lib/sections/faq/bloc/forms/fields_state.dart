part of 'fields_bloc.dart';

@immutable
abstract class FieldsState {}

class FieldsInitial extends FieldsState {}

class FieldsSending extends FieldsState {}

class FieldsSended extends FieldsState {}

class FieldsSetted extends FieldsState {}

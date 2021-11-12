part of 'fields_bloc.dart';

@immutable
abstract class FieldsState {
  final String email;
  final int topic;
  final int question;

  const FieldsState({
    required this.email,
    required this.topic,
    required this.question,
  });
}

class FieldsInitial extends FieldsState {
  const FieldsInitial()
      : super(
          email: '',
          topic: 0,
          question: 0,
        );
}

class FieldsSending extends FieldsState {
  const FieldsSending({
    required String email,
    required int topic,
    required int question,
  }) : super(
          email: email,
          topic: topic,
          question: question,
        );
}

class FieldsSended extends FieldsState {
  const FieldsSended({
    required String email,
    required int topic,
    required int question,
  }) : super(
          email: email,
          topic: topic,
          question: question,
        );
}

class FieldsSetted extends FieldsState {
  const FieldsSetted({
    required String email,
    required int topic,
    required int question,
  }) : super(
          email: email,
          topic: topic,
          question: question,
        );
}

class FieldsUpdated extends FieldsState {
  const FieldsUpdated({
    required String email,
    required int topic,
    required int question,
  }) : super(
          email: email,
          topic: topic,
          question: question,
        );
}

class FieldsFailed extends FieldsState {
  final String title;
  final String? subtitle;

  const FieldsFailed({
    required this.title,
    required String email,
    required int topic,
    required int question,
    this.subtitle,
  }) : super(
          email: email,
          topic: topic,
          question: question,
        );
}

part of 'fields_bloc.dart';

@immutable
abstract class FieldsState {
  final String email;
  final int topic;
  final int question;
  final List<File> files;
  final Map<String, dynamic> extra;

  const FieldsState({
    required this.email,
    required this.topic,
    required this.question,
    required this.files,
    required this.extra,
  });
}

class FieldsInitial extends FieldsState {
  FieldsInitial()
      : super(
          email: '',
          topic: 0,
          question: 0,
          files: [],
          extra: <String, dynamic>{},
        );
}

class FieldsSending extends FieldsState {
  const FieldsSending({
    required String email,
    required int topic,
    required int question,
    required List<File> files,
    required Map<String, dynamic> extra,
  }) : super(
          email: email,
          topic: topic,
          question: question,
          files: files,
          extra: extra,
        );
}

class FieldsSended extends FieldsState {
  const FieldsSended({
    required String email,
    required int topic,
    required int question,
    required List<File> files,
    required Map<String, dynamic> extra,
  }) : super(
          email: email,
          topic: topic,
          question: question,
          files: files,
          extra: extra,
        );
}

class FieldsSetted extends FieldsState {
  const FieldsSetted({
    required String email,
    required int topic,
    required int question,
    required List<File> files,
    required Map<String, dynamic> extra,
  }) : super(
          email: email,
          topic: topic,
          question: question,
          files: files,
          extra: extra,
        );
}

class FieldsUpdated extends FieldsState {
  const FieldsUpdated({
    required String email,
    required int topic,
    required int question,
    required List<File> files,
    required Map<String, dynamic> extra,
  }) : super(
          email: email,
          topic: topic,
          question: question,
          files: files,
          extra: extra,
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
    required List<File> files,
    required Map<String, dynamic> extra,
    this.subtitle,
  }) : super(
          email: email,
          topic: topic,
          question: question,
          files: files,
          extra: extra,
        );
}

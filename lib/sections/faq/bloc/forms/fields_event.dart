part of 'fields_bloc.dart';

@immutable
abstract class FieldsEvent {}

class FormsSetText extends FieldsEvent {
  final String txt;

  FormsSetText({
    required this.txt,
  });
}

class FormsSetInt extends FieldsEvent {
  final int number;

  FormsSetInt({
    required this.number,
  });
}

class FieldsSetEmail extends FormsSetText {
  FieldsSetEmail(String email)
      : super(
          txt: email,
        );
}

class FieldsSetTopic extends FormsSetInt {
  FieldsSetTopic(int topic)
      : super(
          number: topic,
        );
}

class FieldsSetQuestion extends FormsSetInt {
  FieldsSetQuestion(int question)
      : super(
          number: question,
        );
}

class FieldsAddExtra extends FieldsEvent {
  final Map<String, dynamic> extra;

  FieldsAddExtra({required this.extra});
}

class FieldsRemoveExtra extends FieldsEvent {
  final Map<String, dynamic> extra;

  FieldsRemoveExtra({required this.extra});
}

class FieldsAddFiles extends FieldsEvent {
  final List<File> files;

  FieldsAddFiles({required this.files});
}

class FieldsSend extends FieldsEvent {
  final String email;
  final int topic;
  final int question;
  final List<File> files;
  final Map<String, dynamic> extra;

  FieldsSend({
    required this.email,
    required this.topic,
    required this.question,
    required this.extra,
    required this.files,
  });
}

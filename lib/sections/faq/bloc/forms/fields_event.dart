part of 'fields_bloc.dart';

@immutable
abstract class FieldsEvent {
  const FieldsEvent();
}

class FormsSetText extends FieldsEvent {
  final String txt;

  const FormsSetText({
    required this.txt,
  });
}

class FormsSetInt extends FieldsEvent {
  final int number;

  const FormsSetInt({
    required this.number,
  });
}

class FieldsSetEmail extends FormsSetText {
  const FieldsSetEmail(String email)
      : super(
          txt: email,
        );
}

class FieldsSetTopic extends FormsSetInt {
  const FieldsSetTopic(int topic)
      : super(
          number: topic,
        );
}

class FieldsSetQuestion extends FormsSetInt {
  const FieldsSetQuestion(int question)
      : super(
          number: question,
        );
}

class FieldsAddExtra extends FieldsEvent {
  final Map<String, dynamic> extra;

  const FieldsAddExtra({required this.extra});
}

class FieldsRemoveExtra extends FieldsEvent {
  final Map<String, dynamic> extra;

  const FieldsRemoveExtra({required this.extra});
}

class FieldsAddFiles extends FieldsEvent {
  final List<File> files;

  const FieldsAddFiles({required this.files});
}

class FieldsSend extends FieldsEvent {
  final String email;
  final int topic;
  final int question;
  final List<File> files;
  final Map<String, dynamic> extra;

  const FieldsSend({
    required this.email,
    required this.topic,
    required this.question,
    required this.extra,
    required this.files,
  });
}

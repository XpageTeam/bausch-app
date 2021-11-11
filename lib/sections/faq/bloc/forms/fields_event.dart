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

class FieldsSetField extends FieldsEvent {}

class FieldsSend extends FieldsEvent {
  final String email;
  final int topic;
  final int question;

  FieldsSend({
    required this.email,
    required this.topic,
    required this.question,
  });
}

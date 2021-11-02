part of 'code_resend_counter_bloc.dart';

@immutable
abstract class CodeResendCounterEvent {}

class CodeResendCounterStart extends CodeResendCounterEvent {}

class CodeResendCounterUpdate extends CodeResendCounterEvent {
  final int seconds;

  CodeResendCounterUpdate(this.seconds);
}

class CodeResendCounterFinish extends CodeResendCounterEvent {}
part of 'code_resend_counter_bloc.dart';

@immutable
abstract class CodeResendCounterState {}

class CodeResendCounterInitial extends CodeResendCounterState {}

class CodeResendCounterCount extends CodeResendCounterState {
  final int counter;

  CodeResendCounterCount(this.counter);
}

class CodeResendCounterUpdated extends CodeResendCounterState {
  final int counter;

  CodeResendCounterUpdated(this.counter);
}

class CodeResendCounterFinished extends CodeResendCounterState {}
part of 'program_cubit.dart';

@immutable
abstract class ProgramState {}

class ProgramInitial extends ProgramState {}

class ProgramLoading extends ProgramState {}

class ProgramSuccess extends ProgramState {}

class ProgramFailed extends ProgramState {
  final String title;
  final String? subtitle;

  ProgramFailed({
    required this.title,
    this.subtitle,
  });
}

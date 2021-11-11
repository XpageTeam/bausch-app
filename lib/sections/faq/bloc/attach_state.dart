part of 'attach_bloc.dart';

@immutable
abstract class AttachState {}

class AttachInitial extends AttachState {}

class AttachAdding extends AttachState {}

class AttachAdded extends AttachState {
  final List<String> files;

  AttachAdded({required this.files});
}

class AttachStopped extends AttachState {}

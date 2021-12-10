part of 'attach_bloc.dart';

@immutable
abstract class AttachEvent {}

class AttachAdd extends AttachEvent {}

class AttachAddFromOutside extends AttachEvent {
  final List<File> files;

  AttachAddFromOutside({required this.files});
}

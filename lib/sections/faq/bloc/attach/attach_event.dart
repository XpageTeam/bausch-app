part of 'attach_bloc.dart';

@immutable
abstract class AttachEvent {
  const AttachEvent();
}

class AttachAdd extends AttachEvent {}

class AttachAddFromOutside extends AttachEvent {
  final List<PlatformFile> files;

  const AttachAddFromOutside({required this.files});
}

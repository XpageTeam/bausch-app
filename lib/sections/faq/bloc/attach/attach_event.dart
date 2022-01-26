part of 'attach_bloc.dart';

@immutable
abstract class AttachEvent {
  const AttachEvent();
}

class AttachAdd extends AttachEvent {}

class AttachRemove extends AttachEvent {
  final int index;

  const AttachRemove({required this.index});
}

class AttachAddFromOutside extends AttachEvent {
  final List<PlatformFile> files;

  const AttachAddFromOutside({required this.files});
}

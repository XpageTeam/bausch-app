part of 'attach_bloc.dart';

@immutable
abstract class AttachState {
  final List<PlatformFile> files;

  const AttachState({required this.files});
}

class AttachInitial extends AttachState {
  AttachInitial() : super(files: []);
}

class AttachAdding extends AttachState {
  AttachAdding() : super(files: []);
}

class AttachAdded extends AttachState {
  const AttachAdded({required List<PlatformFile> files}) : super(files: files);
}

class AttachRemoved extends AttachState {
  const AttachRemoved({required List<PlatformFile> files})
      : super(files: files);
}

class AttachStopped extends AttachState {
  AttachStopped() : super(files: []);
}

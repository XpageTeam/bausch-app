import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'attach_event.dart';
part 'attach_state.dart';

class AttachBloc extends Bloc<AttachEvent, AttachState> {
  AttachBloc() : super(AttachInitial()) {
    on<AttachEvent>((event, emit) async {
      if (event is AttachAdd) {
        emit(await _attachFile());
      }

      if (event is AttachAddFromOutside) {
        emit(AttachAdded(files: event.files));
      }
    });
  }
  Future<AttachState> _attachFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      state.files.addAll(result.files.map((e) => File(e.path!)).toList());

      //* Убираю дубликаты
      final files = LinkedHashSet<File>.from(state.files).toList();

      return AttachAdded(files: files);
    } else {
      return AttachStopped();
    }
  }
}

// class AttachBloc extends Bloc<AttachEvent, AttachState> {
//   AttachBloc() : super(AttachInitial());

//   @override
//   Stream<AttachState> mapEventToState(
//     AttachEvent event,
//   ) async* {
//     if (event is AttachAdd) {
//       yield await _attachFile();
//     }

//     if (event is AttachAddFromOutside) {
//       yield AttachAdded(files: event.files);
//     }
//   }

//   Future<AttachState> _attachFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);

//     if (result != null) {
//       state.files.addAll(result.files.map((e) => File(e.path!)).toList());

//       //* Убираю дубликаты
//       final files = LinkedHashSet<File>.from(state.files).toList();

//       return AttachAdded(files: files);
//     } else {
//       return AttachStopped();
//     }
//   }
// }

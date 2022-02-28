import 'dart:io';

import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'attach_event.dart';
part 'attach_state.dart';

class AttachBloc extends Bloc<AttachEvent, AttachState> {
  AttachBloc() : super(AttachInitial()) {
    on<AttachEvent>(
      (event, emit) async {
        if (event is AttachAdd) {
          emit(await _attachFile());
        }

        if (event is AttachAddFromOutside) {
          emit(AttachAdded(files: event.files));
        }

        if (event is AttachRemove) {
          emit(await _removeFile(event.index));
        }
      },
    );
  }
  Future<AttachState> _attachFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: Platform.isAndroid ? FileType.custom : FileType.image,
      allowedExtensions: Platform.isAndroid ? StaticData.fileTypes : null,
    );

    if (result != null) {
      //state.files.addAll(result.files.map((e)  => await dio.MultipartFile.fromFile(File(e.path!).path)).toList());

      final files = <PlatformFile>[...state.files];

      // await Future.forEach(
      //   result.files,
      //   (PlatformFile element) async {
      //     state.files.add(await dio.MultipartFile.fromFile(
      //       File(element.path!).path,
      //     ));
      //   },
      // );

      for (final file in result.files) {
        if (file.size <= StaticData.maxFileSize) {
          files.add(file);
        }
      }

      if (files.length != result.files.length + state.files.length) {
        showDefaultNotification(title: StaticData.maxFilesSizeText);
      }

      //* Убираю дубликаты
      // final files = LinkedHashSet<dio.MultipartFile>.from(state.files).toList();

      return AttachAdded(files: files);
    } else {
      return AttachStopped();
    }
  }

  Future<AttachState> _removeFile(int i) async {
    state.files.removeAt(i);
    debugPrint(state.files.length.toString());
    return AttachRemoved(files: state.files);
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

// ignore_for_file: override_on_non_overriding_member

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'attach_event.dart';
part 'attach_state.dart';

class AttachBloc extends Bloc<AttachEvent, AttachState> {
  AttachBloc() : super(AttachInitial());

  @override
  Stream<AttachState> mapEventToState(
    AttachEvent event,
  ) async* {
    if (event is AttachAdd) {
      yield await _attachFile();
    }
  }

  Future<AttachState> _attachFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      return AttachAdded(files: result.files.map((e) => e.name).toList());
    } else {
      return AttachStopped();
    }
  }
}

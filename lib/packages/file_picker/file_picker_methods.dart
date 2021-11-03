// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class FilePickerMethods {
  static void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final File file = File(result.files.single.path!);
      debugPrint(result.names.first);
    } else {
      // User canceled the picker
    }
  }
}

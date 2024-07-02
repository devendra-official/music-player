import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> pickImage() async {
  FilePickerResult? file =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (file == null) {
    return null;
  }
  return File(file.files.first.xFile.path);
}

Future<Map<String, dynamic>?> pickFile() async {
  FilePickerResult? file =
      await FilePicker.platform.pickFiles(type: FileType.audio);
  if (file == null) {
    return null;
  }
  return {
    "name": File(file.files.first.name).toString(),
    "file": File(file.files.first.xFile.path)
  };
}

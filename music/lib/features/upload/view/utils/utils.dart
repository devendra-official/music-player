import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';

String colorToString(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

Color stringToColor(String colorString) {
  final buffer = StringBuffer();
  if (colorString.length == 6 || colorString.length == 7) buffer.write('ff');
  buffer.write(colorString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

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

import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<File>> pickImages() async {
  List<File> images = [];

  final result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg', 'jpeg'],
  );

  if (result == null) return images;

  return result.paths.map((path) => File(path!)).toList();
}

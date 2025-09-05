import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

String formatDate(String isoString) {
  DateTime dateTime = DateTime.parse(
    isoString,
  ).toLocal(); // parse & convert to local
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}

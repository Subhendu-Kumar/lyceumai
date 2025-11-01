import 'dart:io';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

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
  DateTime dateTime = DateTime.parse(isoString).toLocal();
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}

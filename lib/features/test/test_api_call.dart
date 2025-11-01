import 'dart:convert';
import 'dart:io';
// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/features/test/test_response.dart';

Future<TestResponse?> fetchFeedback(File selectedAudio) async {
  try {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${ServerConstant.serverURL}/voice/eval"),
    );
    request
      ..files.addAll([
        await http.MultipartFile.fromPath("audio_ans", selectedAudio.path),
      ])
      ..headers.addAll({"content-type": "multipart/form-data"});
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return TestResponse.fromMap(data);
    } else {
      throw Exception("Failed to fetch feedback");
    }
  } catch (e) {
    return null;
  }
}

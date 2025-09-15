import 'dart:convert';
import "package:http/http.dart" as http;

import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/core/services/sp_service.dart';
import 'package:lyceumai/core/constants/constants.dart';

class MiscellaneousRemoteRepository {
  final SpService spService = SpService();

  Future<AssignmentModel> fetchAssignment(String id) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/assignment/s/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return AssignmentModel.fromMap(jsonDecode(res.body)['assignment']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> submitTextAssignment(String id, String ans) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/assignment/$id/submit/text'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'content': ans.trim()}),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['detail'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> submitVoiceAssignment(String id, String filePath) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final request =
          http.MultipartRequest(
              "POST",
              Uri.parse(
                '${ServerConstant.serverURL}/assignment/$id/submit/voice',
              ),
            )
            ..headers.addAll({'Authorization': 'Bearer $token'})
            ..files.add(
              await http.MultipartFile.fromPath(
                "voice_ans",
                filePath,
                filename: "recorded_audio.aac",
              ),
            );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode != 201) {
        throw jsonDecode(responseBody)['detail'];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

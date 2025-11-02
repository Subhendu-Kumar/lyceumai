// lib/features/meetings/repository/meetings_remote_repository.dart

import 'dart:convert';
import "package:http/http.dart" as http;

import 'package:lyceumai/models/call_model.dart';
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';
import 'package:lyceumai/models/call_details_model.dart';

class MeetingsRemoteRepository {
  final SpService spService = SpService();

  Future<List<CallModel>> getMeetings(String classId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/meeting/list/$classId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return (jsonDecode(res.body)['meetings'] as List)
          .map((e) => CallModel.fromMap(e))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CallDetailsModel> getMeetingDetails(String meetId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/meeting/$meetId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return CallDetailsModel.fromMap(jsonDecode(res.body)['meeting']);
    } catch (e) {
      throw e.toString();
    }
  }
}

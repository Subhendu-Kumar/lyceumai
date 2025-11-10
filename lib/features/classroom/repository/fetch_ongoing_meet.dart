import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:lyceumai/models/call_model.dart';
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';

Future<CallModel?> fetchOngoingMeet(String classroomId) async {
  try {
    final token = await SpService().getToken();
    if (token == null) {
      throw "No Token Found";
    }
    final res = await http.get(
      Uri.parse('${ServerConstant.serverURL}/meeting/$classroomId/ongoing'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      return null;
    }
    return CallModel.fromMap(jsonDecode(res.body)['meeting']);
  } catch (e) {
    return null;
  }
}

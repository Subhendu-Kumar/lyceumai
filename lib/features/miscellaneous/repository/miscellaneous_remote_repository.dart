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
}

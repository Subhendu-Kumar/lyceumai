import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lyceumai/models/home_class_model.dart';
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';

class HomeClassRemoteRepository {
  final SpService spService = SpService();

  Future<List<HomeClassModel>> fetEnrolledClasses() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/classes/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return (jsonDecode(res.body)['classes'] as List)
          .map((e) => HomeClassModel.fromMap(e))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> joinClass(String code) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found ";
      }
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/class/enroll/s/$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body)['detail'];
      } else {
        throw jsonDecode(res.body)['detail'];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

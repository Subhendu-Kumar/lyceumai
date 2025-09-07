import "dart:convert";
import "package:http/http.dart" as http;
import "package:lyceumai/models/classroom_model.dart";
import "package:lyceumai/core/constants/constants.dart";
import 'package:lyceumai/core/services/sp_service.dart';

class ClassroomRemoteRepository {
  final SpService spService = SpService();

  Future<ClassroomModel> getClassroom(String classId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/classes/$classId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return ClassroomModel.fromMap(jsonDecode(res.body)['class']);
    } catch (e) {
      throw e.toString();
    }
  }
}

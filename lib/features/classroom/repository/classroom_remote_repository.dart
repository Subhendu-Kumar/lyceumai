import "dart:convert";
import "package:http/http.dart" as http;

import "package:lyceumai/models/classroom_model.dart";
import "package:lyceumai/models/class_quiz_model.dart";
import "package:lyceumai/core/constants/constants.dart";
import 'package:lyceumai/core/services/sp_service.dart';
import "package:lyceumai/models/class_materials_model.dart";
import "package:lyceumai/models/class_assignment_model.dart";

class ClassroomRemoteRepository {
  final SpService spService = SpService();

  Future<ClassroomModel> getClassroom(String classId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/class/$classId'),
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

  Future<List<ClassMaterialsModel>> getClassMaterials(String classId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/class/materials/$classId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return (jsonDecode(res.body)['materials'] as List)
          .map((e) => ClassMaterialsModel.fromMap(e))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ClassQuizModel>> getClassQuizzes(String classId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/class/quizzes/$classId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return (jsonDecode(res.body)['quizzes'] as List)
          .map((e) => ClassQuizModel.fromMap(e))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ClassAssignmentModel>> getClassAssignments(String classId) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/assignment/$classId/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return (jsonDecode(res.body)['assignments'] as List)
          .map((e) => ClassAssignmentModel.fromMap(e))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }
}

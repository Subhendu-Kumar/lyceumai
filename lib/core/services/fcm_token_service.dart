// lib/core/services/fcm_token_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';

class FcmTokenService {
  final _spService = SpService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    try {
      // Get initial token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token);
      }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await _sendTokenToServer(newToken);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to get FCM token: $e");
      }
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final userToken = await _spService.getToken();
      if (userToken == null) {
        return;
      }
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/fcm/add-token'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({'token': token}),
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to send FCM token to server: $e");
      }
    }
  }
}

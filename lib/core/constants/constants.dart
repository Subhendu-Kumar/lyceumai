import 'dart:io';
import 'package:flutter/foundation.dart';

class ServerConstant {
  static String get serverURL {
    if (kReleaseMode) {
      return "https://lyceumai-be.onrender.com";
    } else {
      return Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';
    }
  }

  static String get meetingBaseURL {
    if (kReleaseMode) {
      return "https://lyceumai-meet.vercel.app";
    } else {
      return Platform.isAndroid
          ? 'http://10.0.2.2:5000'
          : 'http://127.0.0.1:5000';
    }
  }
}

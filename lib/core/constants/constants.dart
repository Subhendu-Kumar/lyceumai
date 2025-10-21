import 'dart:io';

class ServerConstant {
  // static String serverURL = "https://lyceumai-be.onrender.com";

  // static String meetingBaseURL = "https://lyceumai-meet.vercel.app";

  static String serverURL = Platform.isAndroid
      ? 'http://10.0.2.2:8000'
      : 'http://127.0.0.1:8000';

  static String meetingBaseURL = Platform.isAndroid
      ? 'http://10.0.2.2:5000'
      : 'http://127.0.0.1:5000';
}

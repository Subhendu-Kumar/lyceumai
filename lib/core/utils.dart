// lib/core/utils.dart

import 'package:intl/intl.dart';
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';
import 'package:url_launcher/url_launcher.dart';

String formatDate(String isoString) {
  DateTime dateTime = DateTime.parse(isoString).toLocal();
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}

Future<void> openInBrowser(String meetId) async {
  final token = await SpService().getToken();
  if (token == null || meetId.isEmpty) {
    throw "Invalid token or meeting ID";
  }

  final Uri url = Uri.parse(
    "${ServerConstant.meetingBaseURL}?meet_id=$meetId&auth_token=$token",
  );

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

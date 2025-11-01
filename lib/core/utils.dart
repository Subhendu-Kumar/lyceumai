import 'package:intl/intl.dart';

String formatDate(String isoString) {
  DateTime dateTime = DateTime.parse(isoString).toLocal();
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}

import 'package:flutter/material.dart';

import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/call_model.dart';

class MeetingCard extends StatelessWidget {
  final String type;
  final CallModel call;
  const MeetingCard({super.key, required this.type, required this.call});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Icon(
          type == "ended" ? Icons.check_circle_outline : Icons.schedule,
          color: type == "ended" ? Colors.grey : Colors.blue,
        ),
        title: Text(
          call.description,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          formatDate(call.startTime),
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

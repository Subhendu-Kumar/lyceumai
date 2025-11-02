import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/call_model.dart';

class MeetingCard extends StatelessWidget {
  final String type;
  final CallModel call;
  const MeetingCard({super.key, required this.type, required this.call});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == "ended") {
          context.push("/meeting/d/${call.meetId}");
        } else {
          return;
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          leading: Icon(
            type == "ended" ? Icons.check_circle_outline : Icons.schedule,
            color: type == "ended" ? Colors.grey : Colors.blue,
          ),
          title: Text(
            call.description,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            formatDate(call.meetingTime),
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: call.meetStatus == CallStatus.ongoing
                  ? Colors.green.withValues(alpha: 0.1)
                  : call.meetStatus == CallStatus.canceled
                  ? Colors.red.withValues(alpha: 0.1)
                  : call.meetStatus == CallStatus.scheduled
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              call.meetStatus,
              style: TextStyle(
                color: call.meetStatus == CallStatus.ongoing
                    ? Colors.green
                    : call.meetStatus == CallStatus.canceled
                    ? Colors.red
                    : call.meetStatus == CallStatus.scheduled
                    ? Colors.blue
                    : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

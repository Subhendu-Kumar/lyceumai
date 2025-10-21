import 'package:flutter/material.dart';
import 'package:lyceumai/features/meetings/widgets/meeting_card.dart';
import 'package:lyceumai/models/call_model.dart';

class MeetingTypeList extends StatelessWidget {
  final String type;
  final List<CallModel> calls;
  const MeetingTypeList({super.key, required this.calls, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: calls.isEmpty
          ? const Center(
              child: Text(
                'No calls found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: calls.length,
              itemBuilder: (context, index) {
                final call = calls[index];
                return MeetingCard(call: call, type: type);
              },
            ),
    );
  }
}

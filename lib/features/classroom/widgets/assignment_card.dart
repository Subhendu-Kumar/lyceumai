import 'package:flutter/material.dart';

import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/class_assignment_model.dart';

class AssignmentCard extends StatefulWidget {
  final bool isVoice;
  final ClassAssignmentModel assignment;
  const AssignmentCard({
    super.key,
    required this.isVoice,
    required this.assignment,
  });

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          widget.assignment.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("Due: ${formatDate(widget.assignment.dueDate)}"),
            const SizedBox(height: 4),
            Text("Question: ${widget.assignment.question}"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: widget.isVoice
                    ? Colors.deepPurple.shade100
                    : Colors.teal.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.assignment.type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.isVoice
                      ? Colors.deepPurple
                      : Colors.teal.shade800,
                ),
              ),
            ),
          ],
        ),
        trailing: widget.assignment.isSubmitted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.info, color: Colors.orange),
      ),
    );
  }
}

// lib/features/miscellaneous/widgets/assignment_detail_card.dart

import 'package:flutter/material.dart';

import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/assignment_model.dart';

class AssignmentDetailCard extends StatefulWidget {
  final AssignmentModel assignment;
  const AssignmentDetailCard({super.key, required this.assignment});

  @override
  State<AssignmentDetailCard> createState() => _AssignmentDetailCardState();
}

class _AssignmentDetailCardState extends State<AssignmentDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.assignment.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.category, size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  widget.assignment.type,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  formatDate(widget.assignment.dueDate),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.help_outline, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.assignment.question,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// lib/features/miscellaneous/widgets/submission_text_item.dart

import 'package:flutter/material.dart';

class SubmissionTextItem extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;

  const SubmissionTextItem({
    super.key,
    required this.title,
    required this.value,
    this.backgroundColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

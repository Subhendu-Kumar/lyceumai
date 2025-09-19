import 'package:flutter/material.dart';
import 'package:lyceumai/features/miscellaneous/widgets/submission_text_item.dart';

class SubmissionListItem extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color backgroundColor;

  const SubmissionListItem({
    super.key,
    required this.title,
    required this.items,
    this.backgroundColor = const Color(0xFFE8F5E9),
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SubmissionTextItem(
        title: title,
        value: "No data",
        backgroundColor: backgroundColor,
      );
    }
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
              ...items.map(
                (e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 15)),
                    Expanded(
                      child: Text(e, style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/meetings/widgets/tab_text_view_for_transcript_or_summary.dart

import 'package:flutter/material.dart';

class TabTextViewForTranscriptOrSummary extends StatelessWidget {
  final String type;
  final String? text;
  const TabTextViewForTranscriptOrSummary({
    super.key,
    required this.type,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Text(
              text ?? "No $type available.",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

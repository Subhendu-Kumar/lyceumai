import 'package:flutter/material.dart';

class TextAssignmentSubmissionPage extends StatefulWidget {
  const TextAssignmentSubmissionPage({super.key});

  @override
  State<TextAssignmentSubmissionPage> createState() =>
      _TextAssignmentSubmissionPageState();
}

class _TextAssignmentSubmissionPageState
    extends State<TextAssignmentSubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Text Assignment Submission Page')),
    );
  }
}

import 'package:flutter/material.dart';

class AssignmentSubmissionViewPage extends StatefulWidget {
  final String assignmentId;
  const AssignmentSubmissionViewPage({super.key, required this.assignmentId});

  @override
  State<AssignmentSubmissionViewPage> createState() =>
      _AssignmentSubmissionViewPageState();
}

class _AssignmentSubmissionViewPageState
    extends State<AssignmentSubmissionViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Assignment Submission: ${widget.assignmentId}'),
      ),
      body: Center(
        child: Text(
          'Display submission details for assignment ID: ${widget.assignmentId}',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class VoiceAssignmentSubmissionPage extends StatefulWidget {
  const VoiceAssignmentSubmissionPage({super.key});

  @override
  State<VoiceAssignmentSubmissionPage> createState() =>
      _VoiceAssignmentSubmissionPageState();
}

class _VoiceAssignmentSubmissionPageState
    extends State<VoiceAssignmentSubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Voice Assignment Submission Page')),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/core/services/sp_service.dart';

class VoiceAssignmentSubmissionPage extends StatefulWidget {
  final String assignmentId;
  const VoiceAssignmentSubmissionPage({super.key, required this.assignmentId});

  @override
  State<VoiceAssignmentSubmissionPage> createState() =>
      _VoiceAssignmentSubmissionPageState();
}

class _VoiceAssignmentSubmissionPageState
    extends State<VoiceAssignmentSubmissionPage> {
  String errorMessage = '';
  AssignmentModel? assignment;
  final SpService spService = SpService();

  @override
  void initState() {
    super.initState();
    fetchAssignment(widget.assignmentId);
  }

  Future<void> fetchAssignment(String id) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        setState(() {
          errorMessage = "No Token Found";
        });
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/assignment/s/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode != 200) {
        setState(() {
          errorMessage = jsonDecode(res.body)['detail'];
        });
      }
      setState(() {
        assignment = AssignmentModel.fromMap(
          jsonDecode(res.body)['assignment'],
        );
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Voice Assignment Submission'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (assignment == null && errorMessage.isEmpty)
                const Center(child: CircularProgressIndicator()),
              if (assignment != null) ...[
                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment?.title ?? '',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.category,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              assignment?.type ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
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
                              formatDate(assignment?.dueDate ?? ''),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.help_outline,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                assignment?.question ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

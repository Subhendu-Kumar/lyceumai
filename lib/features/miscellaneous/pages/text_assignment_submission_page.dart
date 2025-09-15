// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:http/http.dart" as http;
import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_load_cubit.dart';
import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';

class TextAssignmentSubmissionPage extends StatefulWidget {
  final String assignmentId;
  const TextAssignmentSubmissionPage({super.key, required this.assignmentId});

  @override
  State<TextAssignmentSubmissionPage> createState() =>
      _TextAssignmentSubmissionPageState();
}

class _TextAssignmentSubmissionPageState
    extends State<TextAssignmentSubmissionPage> {
  final SpService spService = SpService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ansController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AssignmentLoadCubit>().loadAssignment(widget.assignmentId);
  }

  @override
  void dispose() {
    _ansController.dispose();
    super.dispose();
  }

  Future<void> submitAnswer() async {
    if (_formKey.currentState!.validate()) {
      try {
        final token = await spService.getToken();
        if (token == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No Token Found")));
          return;
        }
        final res = await http.post(
          Uri.parse(
            '${ServerConstant.serverURL}/assignment/${widget.assignmentId}/submit/text',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'content': _ansController.text.trim()}),
        );
        if (res.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(res.body)['detail'])),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answer submitted successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Answer field is invalid!")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Text Assignment Submission'),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<AssignmentLoadCubit, AssignmentLoadState>(
        builder: (context, state) {
          AssignmentModel? assignment;
          if (state is AssignmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AssignmentLoadingFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is AssignmentLoaded) {
            assignment = state.assignment;
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Answer", style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _ansController,
                          decoration: const InputDecoration(
                            hintText: 'Type your answer here...',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          minLines: 5,
                          maxLines: 15,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Answer field is invalid!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: submitAnswer,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 52),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 5,
                            shadowColor: Colors.blueAccent,
                          ),
                          child: const Text(
                            'Submit Answer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

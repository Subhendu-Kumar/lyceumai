import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_load_cubit.dart';
import 'package:lyceumai/features/miscellaneous/widgets/assignment_detail_card.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_submission_cubit.dart';

class TextAssignmentSubmissionPage extends StatefulWidget {
  final String assignmentId;
  const TextAssignmentSubmissionPage({super.key, required this.assignmentId});

  @override
  State<TextAssignmentSubmissionPage> createState() =>
      _TextAssignmentSubmissionPageState();
}

class _TextAssignmentSubmissionPageState
    extends State<TextAssignmentSubmissionPage> {
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
            return const Center(child: CircularProgressIndicator());
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

          return BlocListener<
            AssignmentSubmissionCubit,
            AssignmentSubmissionState
          >(
            listener: (context, subState) {
              if (subState is AssignmentSubmissionSuccess) {
                Future.delayed(Duration(milliseconds: 100), () {
                  // ignore: use_build_context_synchronously
                  context.pop();
                });
              } else if (subState is AssignmentSubmissionFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(subState.error)));
              }
            },
            child:
                BlocBuilder<
                  AssignmentSubmissionCubit,
                  AssignmentSubmissionState
                >(
                  builder: (context, subState) {
                    void submitAnswer() {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AssignmentSubmissionCubit>()
                            .textAssignmentSubmission(
                              widget.assignmentId,
                              _ansController.text.trim(),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Answer field is invalid!"),
                          ),
                        );
                        return;
                      }
                    }

                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AssignmentDetailCard(assignment: assignment!),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Your Answer",
                                        style: TextStyle(fontSize: 16),
                                      ),
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
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Answer field is invalid!";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed:
                                            subState
                                                is AssignmentSubmissionInProgress
                                            ? null
                                            : submitAnswer,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(
                                            double.infinity,
                                            52,
                                          ),
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          elevation: 5,
                                          shadowColor: Colors.blueAccent,
                                        ),
                                        child:
                                            subState
                                                is AssignmentSubmissionInProgress
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : const Text(
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
                        ),
                      ],
                    );
                  },
                ),
          );
        },
      ),
    );
  }
}

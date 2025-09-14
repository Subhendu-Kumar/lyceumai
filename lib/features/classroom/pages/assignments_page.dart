import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyceumai/core/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/models/class_assignment_model.dart';
import 'package:lyceumai/features/classroom/cubit/assignment_cubit.dart';

class AssignmentsPage extends StatefulWidget {
  final String id;
  const AssignmentsPage({super.key, required this.id});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AssignmentCubit>().getClassAssignments(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AssignmentCubit, AssignmentState>(
        builder: (context, state) {
          if (state is AssignmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AssignmentError) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is AssignmentLoaded) {
            final List<ClassAssignmentModel> assignments = state.assignments;
            if (assignments.isEmpty) {
              return const Center(child: Text("No materials uploaded yet."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final isVoice = assignment.type == AssignmentType.voice;
                return GestureDetector(
                  onTap: () {
                    if (assignment.isSubmitted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Assignment already submitted."),
                        ),
                      );
                      return;
                    } else if (isVoice) {
                      context.push("/submission/${assignment.id}/voice");
                    } else {
                      context.push("/submission/${assignment.id}/text");
                    }
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        assignment.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text("Due: ${formatDate(assignment.dueDate)}"),
                          const SizedBox(height: 4),
                          Text("Question: ${assignment.question}"),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isVoice
                                  ? Colors.deepPurple.shade100
                                  : Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              assignment.type,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isVoice
                                    ? Colors.deepPurple
                                    : Colors.teal.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: assignment.isSubmitted
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.info, color: Colors.orange),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

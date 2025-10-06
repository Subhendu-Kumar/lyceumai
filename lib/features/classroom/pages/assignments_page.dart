import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/class_assignment_model.dart';
import 'package:lyceumai/features/classroom/cubit/assignment_cubit.dart';
import 'package:lyceumai/features/classroom/widgets/assignment_card.dart';

class AssignmentsPage extends StatefulWidget {
  final String id;
  const AssignmentsPage({super.key, required this.id});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<AssignmentCubit>().getClassAssignments(widget.id);
  // }

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
                      context.push("/submission/${assignment.id}");
                      return;
                    } else if (isVoice) {
                      context.push("/submission/${assignment.id}/voice");
                    } else {
                      context.push("/submission/${assignment.id}/text");
                    }
                  },
                  child: AssignmentCard(
                    assignment: assignment,
                    isVoice: isVoice,
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

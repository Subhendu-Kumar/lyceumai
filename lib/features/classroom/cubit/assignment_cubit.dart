// lib/features/classroom/cubit/assignment_cubit.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/class_assignment_model.dart';
import 'package:lyceumai/features/classroom/repository/classroom_remote_repository.dart';

part 'assignment_state.dart';

class AssignmentCubit extends Cubit<AssignmentState> {
  AssignmentCubit() : super(AssignmentInitial());

  final classroomRemoteRepository = ClassroomRemoteRepository();

  Future<void> getClassAssignments(String classId) async {
    emit(AssignmentLoading());
    try {
      final assignments = await classroomRemoteRepository.getClassAssignments(
        classId,
      );
      emit(AssignmentLoaded(assignments));
    } catch (e) {
      emit(AssignmentError(e.toString()));
    }
  }
}

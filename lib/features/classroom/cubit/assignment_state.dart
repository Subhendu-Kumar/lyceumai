// lib/features/classroom/cubit/assignment_state.dart

part of 'assignment_cubit.dart';

@immutable
sealed class AssignmentState {}

final class AssignmentInitial extends AssignmentState {}

final class AssignmentLoading extends AssignmentState {}

final class AssignmentLoaded extends AssignmentState {
  final List<ClassAssignmentModel> assignments;

  AssignmentLoaded(this.assignments);
}

final class AssignmentError extends AssignmentState {
  final String error;

  AssignmentError(this.error);
}

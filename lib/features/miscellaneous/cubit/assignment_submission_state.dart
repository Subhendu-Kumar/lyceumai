// lib/features/miscellaneous/cubit/assignment_submission_state.dart

part of 'assignment_submission_cubit.dart';

@immutable
sealed class AssignmentSubmissionState {}

final class AssignmentSubmissionInitial extends AssignmentSubmissionState {}

final class AssignmentSubmissionInProgress extends AssignmentSubmissionState {}

final class AssignmentSubmissionSuccess extends AssignmentSubmissionState {}

final class AssignmentSubmissionFailure extends AssignmentSubmissionState {
  final String error;
  AssignmentSubmissionFailure(this.error);
}

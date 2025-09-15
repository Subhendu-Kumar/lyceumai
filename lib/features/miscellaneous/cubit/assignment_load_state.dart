part of 'assignment_load_cubit.dart';

@immutable
sealed class AssignmentLoadState {}

final class AssignmentLoadInitial extends AssignmentLoadState {}

final class AssignmentLoading extends AssignmentLoadState {}

final class AssignmentLoaded extends AssignmentLoadState {
  final AssignmentModel assignment;
  AssignmentLoaded(this.assignment);
}

final class AssignmentLoadingFailure extends AssignmentLoadState {
  final String error;
  AssignmentLoadingFailure(this.error);
}

// lib/features/classroom/cubit/classroom_state.dart

part of 'classroom_cubit.dart';

@immutable
sealed class ClassroomState {}

final class ClassroomInitial extends ClassroomState {}

final class ClassroomLoading extends ClassroomState {}

final class ClassroomLoaded extends ClassroomState {
  final ClassroomModel classrooms;

  ClassroomLoaded(this.classrooms);
}

final class ClassroomError extends ClassroomState {
  final String error;

  ClassroomError(this.error);
}

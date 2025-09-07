part of 'classroom_cubit.dart';

@immutable
sealed class ClassroomState {}

final class ClassroomInitial extends ClassroomState {}

final class ClassroomLoading extends ClassroomState {}

final class ClassroomMaterialsLoading extends ClassroomState {}

final class ClassroomLoaded extends ClassroomState {
  final ClassroomModel classrooms;
  final List<ClassMaterialsModel> materials;
  final List<ClassQuizModel> quizzes;

  ClassroomLoaded(this.classrooms, this.materials, this.quizzes);
}

final class ClassroomError extends ClassroomState {
  final String error;

  ClassroomError(this.error);
}

part of 'quizzes_cubit.dart';

@immutable
sealed class QuizzesState {}

final class QuizzesInitial extends QuizzesState {}

final class QuizzesLoading extends QuizzesState {}

final class QuizzesLoaded extends QuizzesState {
  final List<ClassQuizModel> quizzes;

  QuizzesLoaded(this.quizzes);
}

final class QuizzesError extends QuizzesState {
  final String error;

  QuizzesError(this.error);
}

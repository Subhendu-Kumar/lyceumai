import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/class_quiz_model.dart';
import 'package:lyceumai/features/classroom/repository/classroom_remote_repository.dart';

part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  QuizzesCubit() : super(QuizzesInitial());

  final classroomRemoteRepository = ClassroomRemoteRepository();

  Future<void> getClassQuizzes(String classId) async {
    emit(QuizzesLoading());
    try {
      final quizzes = await classroomRemoteRepository.getClassQuizzes(classId);
      emit(QuizzesLoaded(quizzes));
    } catch (e) {
      emit(QuizzesError(e.toString()));
    }
  }
}

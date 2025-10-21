import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/classroom_model.dart';
import 'package:lyceumai/features/classroom/repository/classroom_remote_repository.dart';

part 'classroom_state.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  ClassroomCubit() : super(ClassroomInitial());

  final classroomRemoteRepository = ClassroomRemoteRepository();

  Future<void> getClassroom(String classId) async {
    emit(ClassroomLoading());
    try {
      final classroom = await classroomRemoteRepository.getClassroom(classId);
      emit(ClassroomLoaded(classroom));
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/models/home_class_model.dart';
import 'package:lyceumai/features/home/repository/home_class_remote_repository.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit() : super(ClassInitial());
  final homeClassRemoteRepository = HomeClassRemoteRepository();

  void getEnrolledClasses() async {
    try {
      emit(ClassLoading());
      final classes = await homeClassRemoteRepository.fetEnrolledClasses();
      if (classes.isEmpty) {
        emit(ClassEmpty());
      } else {
        emit(ClassLoaded(classes));
      }
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  void joinClass(String code) async {
    try {
      emit(ClassJoining());
      final message = await homeClassRemoteRepository.joinClass(code);
      emit(ClassJoined(message));
      getEnrolledClasses();
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }
}

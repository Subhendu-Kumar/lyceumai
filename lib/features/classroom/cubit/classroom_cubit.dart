import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'classroom_state.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  ClassroomCubit() : super(ClassroomInitial());
}

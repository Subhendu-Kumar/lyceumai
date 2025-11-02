// lib/features/classroom/cubit/materials_cubit.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/class_materials_model.dart';
import 'package:lyceumai/features/classroom/repository/classroom_remote_repository.dart';

part 'materials_state.dart';

class MaterialsCubit extends Cubit<MaterialsState> {
  MaterialsCubit() : super(MaterialsInitial());
  final classroomRemoteRepository = ClassroomRemoteRepository();

  Future<void> getClassMaterials(String classId) async {
    emit(MaterialsLoading());
    try {
      final materials = await classroomRemoteRepository.getClassMaterials(
        classId,
      );
      emit(MaterialsLoaded(materials));
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }
}

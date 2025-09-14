part of 'materials_cubit.dart';

@immutable
sealed class MaterialsState {}

final class MaterialsInitial extends MaterialsState {}

final class MaterialsLoading extends MaterialsState {}

final class MaterialsLoaded extends MaterialsState {
  final List<ClassMaterialsModel> materials;

  MaterialsLoaded(this.materials);
}

final class MaterialsError extends MaterialsState {
  final String error;

  MaterialsError(this.error);
}

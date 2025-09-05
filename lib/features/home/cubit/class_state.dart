part of 'class_cubit.dart';

@immutable
sealed class ClassState {}

final class ClassInitial extends ClassState {}

final class ClassLoading extends ClassState {}

final class ClassEmpty extends ClassState {}

final class ClassLoaded extends ClassState {
  final List<HomeClassModel> classes;
  ClassLoaded(this.classes);
}

final class ClassError extends ClassState {
  final String error;
  ClassError(this.error);
}

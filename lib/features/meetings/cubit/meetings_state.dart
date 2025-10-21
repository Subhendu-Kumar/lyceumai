part of 'meetings_cubit.dart';

@immutable
sealed class MeetingsState {}

final class MeetingsInitial extends MeetingsState {}

final class CallsLoading extends MeetingsState {}

final class CallsLoaded extends MeetingsState {
  final List<CallModel> endedCalls;
  final List<CallModel> upcomingCalls;

  CallsLoaded({required this.endedCalls, required this.upcomingCalls});
}

final class CallsError extends MeetingsState {
  final String message;

  CallsError(this.message);
}

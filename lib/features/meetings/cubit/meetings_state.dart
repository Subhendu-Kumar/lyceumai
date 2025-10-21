part of 'meetings_cubit.dart';

@immutable
sealed class MeetingsState {}

final class MeetingsInitial extends MeetingsState {}

class CallsLoading extends MeetingsState {}

class CallsLoaded extends MeetingsState {
  final List<CallModel> endedCalls;
  final List<CallModel> upcomingCalls;

  CallsLoaded({required this.endedCalls, required this.upcomingCalls});
}

class CallsError extends MeetingsState {
  final String message;

  CallsError(this.message);
}

// lib/features/meetings/cubit/meeting_details_state.dart

part of 'meeting_details_cubit.dart';

@immutable
sealed class MeetingDetailsState {}

final class MeetingDetailsInitial extends MeetingDetailsState {}

final class MeetingDetailsLoading extends MeetingDetailsState {}

final class MeetingDetailsLoaded extends MeetingDetailsState {
  final CallDetailsModel callDetails;

  MeetingDetailsLoaded({required this.callDetails});
}

final class MeetingDetailsError extends MeetingDetailsState {
  final String message;

  MeetingDetailsError(this.message);
}

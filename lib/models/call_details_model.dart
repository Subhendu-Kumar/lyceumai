// lib/models/call_details_model.dart

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lyceumai/models/call_rec_model.dart';

class CallDetailsModel {
  final String meetId;
  final String meetStatus;
  final String classroomId;
  final String meetingTime;
  final String description;
  final List<CallRecModel> recordings;

  CallDetailsModel({
    required this.meetId,
    required this.meetStatus,
    required this.classroomId,
    required this.meetingTime,
    required this.description,
    required this.recordings,
  });

  CallDetailsModel copyWith({
    String? meetId,
    String? meetStatus,
    String? classroomId,
    String? meetingTime,
    String? description,
    List<CallRecModel>? recordings,
  }) {
    return CallDetailsModel(
      meetId: meetId ?? this.meetId,
      meetStatus: meetStatus ?? this.meetStatus,
      classroomId: classroomId ?? this.classroomId,
      meetingTime: meetingTime ?? this.meetingTime,
      description: description ?? this.description,
      recordings: recordings ?? this.recordings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meetId': meetId,
      'meetStatus': meetStatus,
      'classroomId': classroomId,
      'meetingTime': meetingTime,
      'description': description,
      'recordings': recordings.map((x) => x.toMap()).toList(),
    };
  }

  factory CallDetailsModel.fromMap(Map<String, dynamic> map) {
    return CallDetailsModel(
      meetId: map['meetId'] ?? "",
      meetStatus: map['meetStatus'] ?? "",
      classroomId: map['classroomId'] ?? "",
      meetingTime: map['meetingTime'] ?? "",
      description: map['description'] ?? "",
      recordings: List<CallRecModel>.from(
        (map['recordings'] as List<dynamic>).map<CallRecModel>(
          (x) => CallRecModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CallDetailsModel.fromJson(String source) =>
      CallDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallDetailsModel(meetId: $meetId, meetStatus: $meetStatus, classroomId: $classroomId, meetingTime: $meetingTime, description: $description, recordings: $recordings)';
  }

  @override
  bool operator ==(covariant CallDetailsModel other) {
    if (identical(this, other)) return true;

    return other.meetId == meetId &&
        other.meetStatus == meetStatus &&
        other.classroomId == classroomId &&
        other.meetingTime == meetingTime &&
        other.description == description &&
        listEquals(other.recordings, recordings);
  }

  @override
  int get hashCode {
    return meetId.hashCode ^
        meetStatus.hashCode ^
        classroomId.hashCode ^
        meetingTime.hashCode ^
        description.hashCode ^
        recordings.hashCode;
  }
}

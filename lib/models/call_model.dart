// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CallStatus {
  static const String ongoing = "ONGOING";
  static const String canceled = "CANCELED";
  static const String scheduled = "SCHEDULED";
  static const String completed = "COMPLETED";
}

class CallModel {
  final String meetId;
  final String meetStatus;
  final String classroomId;
  final String meetingTime;
  final String description;

  CallModel({
    required this.meetId,
    required this.meetStatus,
    required this.classroomId,
    required this.meetingTime,
    required this.description,
  });

  CallModel copyWith({
    String? meetId,
    String? meetStatus,
    String? classroomId,
    String? meetingTime,
    String? description,
  }) {
    return CallModel(
      meetId: meetId ?? this.meetId,
      meetStatus: meetStatus ?? this.meetStatus,
      classroomId: classroomId ?? this.classroomId,
      meetingTime: meetingTime ?? this.meetingTime,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meetId': meetId,
      'meetStatus': meetStatus,
      'classroomId': classroomId,
      'MeetingTime': meetingTime,
      'description': description,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      meetId: map['meetId'] ?? "",
      meetStatus: map['meetStatus'] ?? "",
      classroomId: map['classroomId'] ?? "",
      meetingTime: map['MeetingTime'] ?? "",
      description: map['description'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CallModel.fromJson(String source) =>
      CallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallModel(meetId: $meetId, meetStatus: $meetStatus, classroomId: $classroomId, meetingTime: $meetingTime, description: $description)';
  }

  @override
  bool operator ==(covariant CallModel other) {
    if (identical(this, other)) return true;

    return other.meetId == meetId &&
        other.meetStatus == meetStatus &&
        other.classroomId == classroomId &&
        other.meetingTime == meetingTime &&
        other.description == description;
  }

  @override
  int get hashCode {
    return meetId.hashCode ^
        meetStatus.hashCode ^
        classroomId.hashCode ^
        meetingTime.hashCode ^
        description.hashCode;
  }
}

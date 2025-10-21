// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CallModel {
  final String id;
  final String classId;
  final String? endTime;
  final String startTime;
  final String description;

  CallModel({
    required this.id,
    required this.classId,
    this.endTime,
    required this.startTime,
    required this.description,
  });

  CallModel copyWith({
    String? id,
    String? classId,
    String? endTime,
    String? startTime,
    String? description,
  }) {
    return CallModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'classId': classId,
      'end_time': endTime,
      'start_time': startTime,
      'description': description,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      id: map['id'] ?? "",
      classId: map['classId'] ?? "",
      endTime: map['end_time'] != null ? map['end_time'] ?? "" : null,
      startTime: map['start_time'] ?? "",
      description: map['description'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CallModel.fromJson(String source) =>
      CallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallModel(id: $id, classId: $classId, endTime: $endTime, startTime: $startTime, description: $description)';
  }

  @override
  bool operator ==(covariant CallModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.classId == classId &&
        other.endTime == endTime &&
        other.startTime == startTime &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        classId.hashCode ^
        endTime.hashCode ^
        startTime.hashCode ^
        description.hashCode;
  }
}

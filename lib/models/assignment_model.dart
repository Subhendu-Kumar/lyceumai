// lib/models/assignment_model.dart

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignmentModel {
  final String id;
  final String type;
  final String title;
  final String dueDate;
  final String question;
  final String classroomId;

  AssignmentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.dueDate,
    required this.question,
    required this.classroomId,
  });

  AssignmentModel copyWith({
    String? id,
    String? type,
    String? title,
    String? dueDate,
    String? question,
    String? classroomId,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      question: question ?? this.question,
      classroomId: classroomId ?? this.classroomId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'dueDate': dueDate,
      'question': question,
      'classroomId': classroomId,
    };
  }

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'] ?? "",
      type: map['type'] ?? "",
      title: map['title'] ?? "",
      dueDate: map['dueDate'] ?? "",
      question: map['question'] ?? "",
      classroomId: map['classroomId'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignmentModel.fromJson(String source) =>
      AssignmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AssignmentModel(id: $id, type: $type, title: $title, dueDate: $dueDate, question: $question, classroomId: $classroomId)';
  }

  @override
  bool operator ==(covariant AssignmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.title == title &&
        other.dueDate == dueDate &&
        other.question == question &&
        other.classroomId == classroomId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        title.hashCode ^
        dueDate.hashCode ^
        question.hashCode ^
        classroomId.hashCode;
  }
}

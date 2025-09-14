// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignmentType {
  static const String voice = "VOICE";
  static const String text = "TEXT";
}

class ClassAssignmentModel {
  final String id;
  final String title;
  final String dueDate;
  final String question;
  final String createdAt;
  final bool isSubmitted;
  final String type;

  ClassAssignmentModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.question,
    required this.createdAt,
    required this.isSubmitted,
    required this.type,
  });

  ClassAssignmentModel copyWith({
    String? id,
    String? title,
    String? dueDate,
    String? question,
    String? createdAt,
    bool? isSubmitted,
    String? type,
  }) {
    return ClassAssignmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      question: question ?? this.question,
      createdAt: createdAt ?? this.createdAt,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'dueDate': dueDate,
      'question': question,
      'createdAt': createdAt,
      'isSubmitted': isSubmitted,
      'type': type,
    };
  }

  factory ClassAssignmentModel.fromMap(Map<String, dynamic> map) {
    return ClassAssignmentModel(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      dueDate: map['dueDate'] ?? "",
      question: map['question'] ?? "",
      createdAt: map['createdAt'] ?? "",
      isSubmitted: map['isSubmitted'] ?? false,
      type: map['type'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassAssignmentModel.fromJson(String source) =>
      ClassAssignmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassAssignmentModel(id: $id, title: $title, dueDate: $dueDate, question: $question, createdAt: $createdAt, isSubmitted: $isSubmitted, type: $type)';
  }

  @override
  bool operator ==(covariant ClassAssignmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.dueDate == dueDate &&
        other.question == question &&
        other.createdAt == createdAt &&
        other.isSubmitted == isSubmitted &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        dueDate.hashCode ^
        question.hashCode ^
        createdAt.hashCode ^
        isSubmitted.hashCode ^
        type.hashCode;
  }
}

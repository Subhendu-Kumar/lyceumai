// lib/models/class_quiz_model.dart

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClassQuizModel {
  final String id;
  final String title;
  final String updatedAt;
  final String description;

  ClassQuizModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.description,
  });

  ClassQuizModel copyWith({
    String? id,
    String? title,
    String? updatedAt,
    String? description,
  }) {
    return ClassQuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'updatedAt': updatedAt,
      'description': description,
    };
  }

  factory ClassQuizModel.fromMap(Map<String, dynamic> map) {
    return ClassQuizModel(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      updatedAt: map['updatedAt'] ?? "",
      description: map['description'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassQuizModel.fromJson(String source) =>
      ClassQuizModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassQuizModel(id: $id, title: $title, updatedAt: $updatedAt, description: $description)';
  }

  @override
  bool operator ==(covariant ClassQuizModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.updatedAt == updatedAt &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        updatedAt.hashCode ^
        description.hashCode;
  }
}

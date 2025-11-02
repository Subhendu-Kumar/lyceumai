// lib/models/classroom_model.dart

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClassroomModel {
  final String id;
  final String name;
  final String code;
  final String updatedAt;
  final String syllabusUrl;
  final String description;

  ClassroomModel({
    required this.id,
    required this.name,
    required this.code,
    required this.updatedAt,
    required this.syllabusUrl,
    required this.description,
  });

  ClassroomModel copyWith({
    String? id,
    String? name,
    String? code,
    String? updatedAt,
    String? syllabusUrl,
    String? description,
  }) {
    return ClassroomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      updatedAt: updatedAt ?? this.updatedAt,
      syllabusUrl: syllabusUrl ?? this.syllabusUrl,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'updatedAt': updatedAt,
      'syllabusUrl': syllabusUrl,
      'description': description,
    };
  }

  factory ClassroomModel.fromMap(Map<String, dynamic> map) {
    return ClassroomModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      code: map['code'] ?? "",
      updatedAt: map['updatedAt'] ?? "",
      syllabusUrl: map['syllabusUrl'] ?? "",
      description: map['description'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassroomModel.fromJson(String source) =>
      ClassroomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassroomModel(id: $id, name: $name, code: $code, updatedAt: $updatedAt, syllabusUrl: $syllabusUrl, description: $description)';
  }

  @override
  bool operator ==(covariant ClassroomModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        other.updatedAt == updatedAt &&
        other.syllabusUrl == syllabusUrl &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        updatedAt.hashCode ^
        syllabusUrl.hashCode ^
        description.hashCode;
  }
}

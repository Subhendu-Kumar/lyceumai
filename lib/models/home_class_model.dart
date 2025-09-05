// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HomeClassModel {
  final String id;
  final String name;
  final String code;
  final String updatedAt;
  final String description;

  HomeClassModel({
    required this.id,
    required this.name,
    required this.code,
    required this.updatedAt,
    required this.description,
  });

  HomeClassModel copyWith({
    String? id,
    String? name,
    String? code,
    String? updatedAt,
    String? description,
  }) {
    return HomeClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'updatedAt': updatedAt,
      'description': description,
    };
  }

  factory HomeClassModel.fromMap(Map<String, dynamic> map) {
    return HomeClassModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      code: map['code'] ?? "",
      updatedAt: map['updatedAt'] ?? "",
      description: map['description'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeClassModel.fromJson(String source) =>
      HomeClassModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomeClassModel(id: $id, name: $name, code: $code, updatedAt: $updatedAt, description: $description)';
  }

  @override
  bool operator ==(covariant HomeClassModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        other.updatedAt == updatedAt &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        updatedAt.hashCode ^
        description.hashCode;
  }
}

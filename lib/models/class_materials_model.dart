// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClassMaterialsModel {
  final String id;
  final String title;
  final String fileUrl;
  final String uploadedAt;

  ClassMaterialsModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.uploadedAt,
  });

  ClassMaterialsModel copyWith({
    String? id,
    String? title,
    String? fileUrl,
    String? uploadedAt,
  }) {
    return ClassMaterialsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'fileUrl': fileUrl,
      'uploadedAt': uploadedAt,
    };
  }

  factory ClassMaterialsModel.fromMap(Map<String, dynamic> map) {
    return ClassMaterialsModel(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      fileUrl: map['fileUrl'] ?? "",
      uploadedAt: map['uploadedAt'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassMaterialsModel.fromJson(String source) =>
      ClassMaterialsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassMaterialsModel(id: $id, title: $title, fileUrl: $fileUrl, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(covariant ClassMaterialsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.fileUrl == fileUrl &&
        other.uploadedAt == uploadedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        fileUrl.hashCode ^
        uploadedAt.hashCode;
  }
}

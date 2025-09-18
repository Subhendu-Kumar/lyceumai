// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:flutter/foundation.dart';

class TextSubmissionModel {
  final String id;
  final int score;
  final String content;
  final String feedback;
  final List<String> strengths;
  final List<String> improvements;

  TextSubmissionModel({
    required this.id,
    required this.score,
    required this.content,
    required this.feedback,
    required this.strengths,
    required this.improvements,
  });

  TextSubmissionModel copyWith({
    String? id,
    int? score,
    String? content,
    String? feedback,
    List<String>? strengths,
    List<String>? improvements,
  }) {
    return TextSubmissionModel(
      id: id ?? this.id,
      score: score ?? this.score,
      content: content ?? this.content,
      feedback: feedback ?? this.feedback,
      strengths: strengths ?? this.strengths,
      improvements: improvements ?? this.improvements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'score': score,
      'content': content,
      'feedback': feedback,
      'strengths': strengths,
      'improvements': improvements,
    };
  }

  factory TextSubmissionModel.fromMap(Map<String, dynamic> map) {
    return TextSubmissionModel(
      id: map['id'] ?? "",
      score: map['score'] ?? 0,
      content: map['content'] ?? "",
      feedback: map['feedback'] ?? "",
      strengths: List<String>.from(map['strengths'] ?? []),
      improvements: List<String>.from(map['improvements'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory TextSubmissionModel.fromJson(String source) =>
      TextSubmissionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TextSubmissionModel(id: $id, score: $score, content: $content, feedback: $feedback, strengths: $strengths, improvements: $improvements)';
  }

  @override
  bool operator ==(covariant TextSubmissionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.score == score &&
        other.content == content &&
        other.feedback == feedback &&
        listEquals(other.strengths, strengths) &&
        listEquals(other.improvements, improvements);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        score.hashCode ^
        content.hashCode ^
        feedback.hashCode ^
        strengths.hashCode ^
        improvements.hashCode;
  }
}

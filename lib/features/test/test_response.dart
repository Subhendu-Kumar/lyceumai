// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class TestResponse {
  final int score;
  final String feedback;
  final List<String> strengths;
  final List<String> areasForImprovement;

  TestResponse({
    required this.score,
    required this.feedback,
    required this.strengths,
    required this.areasForImprovement,
  });

  TestResponse copyWith({
    int? score,
    String? feedback,
    List<String>? strengths,
    List<String>? areasForImprovement,
  }) {
    return TestResponse(
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      strengths: strengths ?? this.strengths,
      areasForImprovement: areasForImprovement ?? this.areasForImprovement,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'score': score,
      'feedback': feedback,
      'strengths': strengths,
      'areas_for_improvement': areasForImprovement,
    };
  }

  factory TestResponse.fromMap(Map<String, dynamic> map) {
    return TestResponse(
      score: map['score'] ?? 0,
      feedback: map['feedback'] ?? "",
      strengths: List<String>.from((map['strengths'] ?? [])),
      areasForImprovement: List<String>.from(
        (map['areas_for_improvement'] ?? []),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TestResponse.fromJson(String source) =>
      TestResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestResponse(score: $score, feedback: $feedback, strengths: $strengths, areasForImprovement: $areasForImprovement)';
  }

  @override
  bool operator ==(covariant TestResponse other) {
    if (identical(this, other)) return true;

    return other.score == score &&
        other.feedback == feedback &&
        listEquals(other.strengths, strengths) &&
        listEquals(other.areasForImprovement, areasForImprovement);
  }

  @override
  int get hashCode {
    return score.hashCode ^
        feedback.hashCode ^
        strengths.hashCode ^
        areasForImprovement.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:flutter/foundation.dart';

class VoiceSubmissionModel {
  final String id;
  final int score;
  final String fileUrl;
  final String feedback;
  final String transcript;
  final List<String> strengths;
  final List<String> improvements;

  VoiceSubmissionModel({
    required this.id,
    required this.score,
    required this.fileUrl,
    required this.feedback,
    required this.transcript,
    required this.strengths,
    required this.improvements,
  });

  VoiceSubmissionModel copyWith({
    String? id,
    int? score,
    String? fileUrl,
    String? feedback,
    String? transcript,
    List<String>? strengths,
    List<String>? improvements,
  }) {
    return VoiceSubmissionModel(
      id: id ?? this.id,
      score: score ?? this.score,
      fileUrl: fileUrl ?? this.fileUrl,
      feedback: feedback ?? this.feedback,
      transcript: transcript ?? this.transcript,
      strengths: strengths ?? this.strengths,
      improvements: improvements ?? this.improvements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'score': score,
      'fileUrl': fileUrl,
      'feedback': feedback,
      'transcript': transcript,
      'strengths': strengths,
      'improvements': improvements,
    };
  }

  factory VoiceSubmissionModel.fromMap(Map<String, dynamic> map) {
    return VoiceSubmissionModel(
      id: map['id'] ?? "",
      score: map['score'] ?? 0,
      fileUrl: map['fileUrl'] ?? "",
      feedback: map['feedback'] ?? "",
      transcript: map['transcript'] ?? "",
      strengths: List<String>.from(map['strengths'] ?? []),
      improvements: List<String>.from(map['improvements'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory VoiceSubmissionModel.fromJson(String source) =>
      VoiceSubmissionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VoiceSubmissionModel(id: $id, score: $score, fileUrl: $fileUrl, feedback: $feedback, transcript: $transcript, strengths: $strengths, improvements: $improvements)';
  }

  @override
  bool operator ==(covariant VoiceSubmissionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.score == score &&
        other.fileUrl == fileUrl &&
        other.feedback == feedback &&
        other.transcript == transcript &&
        listEquals(other.strengths, strengths) &&
        listEquals(other.improvements, improvements);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        score.hashCode ^
        fileUrl.hashCode ^
        feedback.hashCode ^
        transcript.hashCode ^
        strengths.hashCode ^
        improvements.hashCode;
  }
}

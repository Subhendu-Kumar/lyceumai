// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:lyceumai/models/text_submission_model.dart';
import 'package:lyceumai/models/voice_submission_model.dart';

class SubmissionModel {
  final String id;
  final String submittedAt;
  final TextSubmissionModel? textSubmission;
  final VoiceSubmissionModel? voiceSubmission;

  SubmissionModel({
    required this.id,
    required this.submittedAt,
    this.textSubmission,
    this.voiceSubmission,
  });

  SubmissionModel copyWith({
    String? id,
    String? submittedAt,
    TextSubmissionModel? textSubmission,
    VoiceSubmissionModel? voiceSubmission,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      submittedAt: submittedAt ?? this.submittedAt,
      textSubmission: textSubmission ?? this.textSubmission,
      voiceSubmission: voiceSubmission ?? this.voiceSubmission,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'submittedAt': submittedAt,
      'textSubmission': textSubmission?.toMap(),
      'voiceSubmission': voiceSubmission?.toMap(),
    };
  }

  factory SubmissionModel.fromMap(Map<String, dynamic> map) {
    return SubmissionModel(
      id: map['id'] ?? "",
      submittedAt: map['submittedAt'] ?? "",
      textSubmission: map['textSubmission'] != null
          ? TextSubmissionModel.fromMap(
              map['textSubmission'] ?? <String, dynamic>{},
            )
          : null,
      voiceSubmission: map['voiceSubmission'] != null
          ? VoiceSubmissionModel.fromMap(
              map['voiceSubmission'] ?? <String, dynamic>{},
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmissionModel.fromJson(String source) =>
      SubmissionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubmissionModel(id: $id, submittedAt: $submittedAt, textSubmission: $textSubmission, voiceSubmission: $voiceSubmission)';
  }

  @override
  bool operator ==(covariant SubmissionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.submittedAt == submittedAt &&
        other.textSubmission == textSubmission &&
        other.voiceSubmission == voiceSubmission;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        submittedAt.hashCode ^
        textSubmission.hashCode ^
        voiceSubmission.hashCode;
  }
}

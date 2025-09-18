// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:lyceumai/models/text_submission_model.dart';
import 'package:lyceumai/models/voice_submission_model.dart';

class SubmissionModel {
  final String id;
  final TextSubmissionModel? textSubmission;
  final VoiceSubmissionModel? voiceSubmission;
  final DateTime submittedAt;

  SubmissionModel({
    required this.id,
    this.textSubmission,
    this.voiceSubmission,
    required this.submittedAt,
  });

  SubmissionModel copyWith({
    String? id,
    TextSubmissionModel? textSubmission,
    VoiceSubmissionModel? voiceSubmission,
    DateTime? submittedAt,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      textSubmission: textSubmission ?? this.textSubmission,
      voiceSubmission: voiceSubmission ?? this.voiceSubmission,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'textSubmission': textSubmission?.toMap(),
      'voiceSubmission': voiceSubmission?.toMap(),
      'submittedAt': submittedAt.millisecondsSinceEpoch,
    };
  }

  factory SubmissionModel.fromMap(Map<String, dynamic> map) {
    return SubmissionModel(
      id: map['id'] as String,
      textSubmission: map['textSubmission'] != null
          ? TextSubmissionModel.fromMap(
              map['textSubmission'] as Map<String, dynamic>,
            )
          : null,
      voiceSubmission: map['voiceSubmission'] != null
          ? VoiceSubmissionModel.fromMap(
              map['voiceSubmission'] as Map<String, dynamic>,
            )
          : null,
      submittedAt: DateTime.fromMillisecondsSinceEpoch(
        map['submittedAt'] as int,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmissionModel.fromJson(String source) =>
      SubmissionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubmissionModel(id: $id, textSubmission: $textSubmission, voiceSubmission: $voiceSubmission, submittedAt: $submittedAt)';
  }

  @override
  bool operator ==(covariant SubmissionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.textSubmission == textSubmission &&
        other.voiceSubmission == voiceSubmission &&
        other.submittedAt == submittedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        textSubmission.hashCode ^
        voiceSubmission.hashCode ^
        submittedAt.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/models/submission_model.dart';

class ClassAssignmentSubmissionModel {
  final AssignmentModel assignment;
  final SubmissionModel submission;

  ClassAssignmentSubmissionModel({
    required this.assignment,
    required this.submission,
  });

  ClassAssignmentSubmissionModel copyWith({
    AssignmentModel? assignment,
    SubmissionModel? submission,
  }) {
    return ClassAssignmentSubmissionModel(
      assignment: assignment ?? this.assignment,
      submission: submission ?? this.submission,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'assignment': assignment.toMap(),
      'submission': submission.toMap(),
    };
  }

  factory ClassAssignmentSubmissionModel.fromMap(Map<String, dynamic> map) {
    return ClassAssignmentSubmissionModel(
      assignment: AssignmentModel.fromMap(
        map['assignment'] ?? <String, dynamic>{},
      ),
      submission: SubmissionModel.fromMap(
        map['submission'] ?? <String, dynamic>{},
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassAssignmentSubmissionModel.fromJson(String source) =>
      ClassAssignmentSubmissionModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'ClassAssignmentSubmissionModel(assignment: $assignment, submission: $submission)';

  @override
  bool operator ==(covariant ClassAssignmentSubmissionModel other) {
    if (identical(this, other)) return true;

    return other.assignment == assignment && other.submission == submission;
  }

  @override
  int get hashCode => assignment.hashCode ^ submission.hashCode;
}

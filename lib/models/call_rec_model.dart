// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CallRecModel {
  final String url;
  final String? summary;
  final String meetDate;
  final String sessionId;
  final String? transcript;

  CallRecModel({
    required this.url,
    this.summary,
    required this.meetDate,
    required this.sessionId,
    this.transcript,
  });

  CallRecModel copyWith({
    String? url,
    String? summary,
    String? meetDate,
    String? sessionId,
    String? transcript,
  }) {
    return CallRecModel(
      url: url ?? this.url,
      summary: summary ?? this.summary,
      meetDate: meetDate ?? this.meetDate,
      sessionId: sessionId ?? this.sessionId,
      transcript: transcript ?? this.transcript,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'summary': summary,
      'meet_date': meetDate,
      'session_id': sessionId,
      'transcript': transcript,
    };
  }

  factory CallRecModel.fromMap(Map<String, dynamic> map) {
    return CallRecModel(
      url: map['url'] ?? "",
      summary: map['summary'] != null ? map['summary'] ?? "" : null,
      meetDate: map['meet_date'] ?? "",
      sessionId: map['session_id'] ?? "",
      transcript: map['transcript'] != null ? map['transcript'] ?? "" : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallRecModel.fromJson(String source) =>
      CallRecModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallRecModel(url: $url, summary: $summary, meetDate: $meetDate, sessionId: $sessionId, transcript: $transcript)';
  }

  @override
  bool operator ==(covariant CallRecModel other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.summary == summary &&
        other.meetDate == meetDate &&
        other.sessionId == sessionId &&
        other.transcript == transcript;
  }

  @override
  int get hashCode {
    return url.hashCode ^
        summary.hashCode ^
        meetDate.hashCode ^
        sessionId.hashCode ^
        transcript.hashCode;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PracticeSession _$PracticeSessionFromJson(Map<String, dynamic> json) =>
    _PracticeSession(
      meditationId: json['meditationId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      listenedSeconds: (json['listenedSeconds'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$PracticeSessionToJson(_PracticeSession instance) =>
    <String, dynamic>{
      'meditationId': instance.meditationId,
      'startedAt': instance.startedAt.toIso8601String(),
      'listenedSeconds': instance.listenedSeconds,
      'completed': instance.completed,
    };

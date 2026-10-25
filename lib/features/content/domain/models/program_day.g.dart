// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramDay _$ProgramDayFromJson(Map<String, dynamic> json) => _ProgramDay(
  dayNumber: (json['dayNumber'] as num).toInt(),
  meditationId: json['meditationId'] as String,
  note: LocalizedText.fromJson(json['note'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProgramDayToJson(_ProgramDay instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'meditationId': instance.meditationId,
      'note': instance.note.toJson(),
    };

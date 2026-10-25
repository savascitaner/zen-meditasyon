// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Program _$ProgramFromJson(Map<String, dynamic> json) => _Program(
  id: json['id'] as String,
  title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
  description: LocalizedText.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  totalDays: (json['totalDays'] as num?)?.toInt() ?? 30,
  days: (json['days'] as List<dynamic>)
      .map((e) => ProgramDay.fromJson(e as Map<String, dynamic>))
      .toList(),
  isPremium: json['isPremium'] as bool? ?? false,
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title.toJson(),
  'description': instance.description.toJson(),
  'totalDays': instance.totalDays,
  'days': instance.days.map((e) => e.toJson()).toList(),
  'isPremium': instance.isPremium,
};

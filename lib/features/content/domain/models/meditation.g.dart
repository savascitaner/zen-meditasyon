// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meditation _$MeditationFromJson(Map<String, dynamic> json) => _Meditation(
  id: json['id'] as String,
  title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
  description: LocalizedText.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  categoryIds: (json['categoryIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  audioSource: json['audioSource'] as String,
  coverImage: json['coverImage'] as String?,
  narrator: json['narrator'] as String,
  isPremium: json['isPremium'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$MeditationToJson(_Meditation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title.toJson(),
      'description': instance.description.toJson(),
      'categoryIds': instance.categoryIds,
      'durationMinutes': instance.durationMinutes,
      'audioSource': instance.audioSource,
      'coverImage': instance.coverImage,
      'narrator': instance.narrator,
      'isPremium': instance.isPremium,
      'tags': instance.tags,
    };

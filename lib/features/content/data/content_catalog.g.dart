// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentCatalog _$ContentCatalogFromJson(Map<String, dynamic> json) =>
    _ContentCatalog(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      meditations: (json['meditations'] as List<dynamic>)
          .map((e) => Meditation.fromJson(e as Map<String, dynamic>))
          .toList(),
      programs: (json['programs'] as List<dynamic>)
          .map((e) => Program.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContentCatalogToJson(_ContentCatalog instance) =>
    <String, dynamic>{
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'meditations': instance.meditations.map((e) => e.toJson()).toList(),
      'programs': instance.programs.map((e) => e.toJson()).toList(),
    };

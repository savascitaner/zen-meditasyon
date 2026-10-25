// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meditation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meditation {

 String get id; LocalizedText get title; LocalizedText get description; List<String> get categoryIds; int get durationMinutes;/// An asset path (`assets/...`) or a remote URL.
 String get audioSource;/// Null until real cover art exists; the UI shows a placeholder.
 String? get coverImage; String get narrator; bool get isPremium; List<String> get tags;
/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeditationCopyWith<Meditation> get copyWith => _$MeditationCopyWithImpl<Meditation>(this as Meditation, _$identity);

  /// Serializes this Meditation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Meditation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meditation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.categoryIds, _this.categoryIds)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.audioSource, _this.audioSource) || other.audioSource == _this.audioSource)&&(identical(other.coverImage, _this.coverImage) || other.coverImage == _this.coverImage)&&(identical(other.narrator, _this.narrator) || other.narrator == _this.narrator)&&(identical(other.isPremium, _this.isPremium) || other.isPremium == _this.isPremium)&&const DeepCollectionEquality().equals(other.tags, _this.tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Meditation;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,const DeepCollectionEquality().hash(_this.categoryIds),_this.durationMinutes,_this.audioSource,_this.coverImage,_this.narrator,_this.isPremium,const DeepCollectionEquality().hash(_this.tags));
}

@override
String toString() {
  final _this = this as Meditation;
  return 'Meditation(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, categoryIds: ${_this.categoryIds}, durationMinutes: ${_this.durationMinutes}, audioSource: ${_this.audioSource}, coverImage: ${_this.coverImage}, narrator: ${_this.narrator}, isPremium: ${_this.isPremium}, tags: ${_this.tags})';
}


}

/// @nodoc
abstract mixin class $MeditationCopyWith<$Res>  {
  factory $MeditationCopyWith(Meditation value, $Res Function(Meditation) _then) = _$MeditationCopyWithImpl;
@useResult
$Res call({
 String id, LocalizedText title, LocalizedText description, List<String> categoryIds, int durationMinutes, String audioSource, String? coverImage, String narrator, bool isPremium, List<String> tags
});


$LocalizedTextCopyWith<$Res> get title;$LocalizedTextCopyWith<$Res> get description;

}
/// @nodoc
class _$MeditationCopyWithImpl<$Res>
    implements $MeditationCopyWith<$Res> {
  _$MeditationCopyWithImpl(this._self, this._then);

  final Meditation _self;
  final $Res Function(Meditation) _then;

/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? categoryIds = null,Object? durationMinutes = null,Object? audioSource = null,Object? coverImage = freezed,Object? narrator = null,Object? isPremium = null,Object? tags = null,}) {
  return _then(Meditation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,audioSource: null == audioSource ? _self.audioSource : audioSource // ignore: cast_nullable_to_non_nullable
as String,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,narrator: null == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get title {
  
  return $LocalizedTextCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}
}


/// Adds pattern-matching-related methods to [Meditation].
extension MeditationPatterns on Meditation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meditation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meditation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meditation value)  $default,){
final _that = this;
switch (_that) {
case _Meditation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meditation value)?  $default,){
final _that = this;
switch (_that) {
case _Meditation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LocalizedText title,  LocalizedText description,  List<String> categoryIds,  int durationMinutes,  String audioSource,  String? coverImage,  String narrator,  bool isPremium,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meditation() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.categoryIds,_that.durationMinutes,_that.audioSource,_that.coverImage,_that.narrator,_that.isPremium,_that.tags);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LocalizedText title,  LocalizedText description,  List<String> categoryIds,  int durationMinutes,  String audioSource,  String? coverImage,  String narrator,  bool isPremium,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Meditation():
return $default(_that.id,_that.title,_that.description,_that.categoryIds,_that.durationMinutes,_that.audioSource,_that.coverImage,_that.narrator,_that.isPremium,_that.tags);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LocalizedText title,  LocalizedText description,  List<String> categoryIds,  int durationMinutes,  String audioSource,  String? coverImage,  String narrator,  bool isPremium,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Meditation() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.categoryIds,_that.durationMinutes,_that.audioSource,_that.coverImage,_that.narrator,_that.isPremium,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meditation implements Meditation {
  const _Meditation({required this.id, required this.title, required this.description, required  List<String> categoryIds, required this.durationMinutes, required this.audioSource, this.coverImage, required this.narrator, this.isPremium = false,  List<String> tags = const <String>[]}): _categoryIds = categoryIds,_tags = tags;
  factory _Meditation.fromJson(Map<String, dynamic> json) => _$MeditationFromJson(json);

@override final  String id;
@override final  LocalizedText title;
@override final  LocalizedText description;
 final  List<String> _categoryIds;
@override List<String> get categoryIds {
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryIds);
}

@override final  int durationMinutes;
/// An asset path (`assets/...`) or a remote URL.
@override final  String audioSource;
/// Null until real cover art exists; the UI shows a placeholder.
@override final  String? coverImage;
@override final  String narrator;
@override@JsonKey() final  bool isPremium;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeditationCopyWith<_Meditation> get copyWith => __$MeditationCopyWithImpl<_Meditation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeditationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meditation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.categoryIds, _categoryIds)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.audioSource, audioSource) || other.audioSource == audioSource)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other.tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_categoryIds),durationMinutes,audioSource,coverImage,narrator,isPremium,const DeepCollectionEquality().hash(_tags));
}

@override
String toString() {
    return 'Meditation(id: $id, title: $title, description: $description, categoryIds: $categoryIds, durationMinutes: $durationMinutes, audioSource: $audioSource, coverImage: $coverImage, narrator: $narrator, isPremium: $isPremium, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$MeditationCopyWith<$Res> implements $MeditationCopyWith<$Res> {
  factory _$MeditationCopyWith(_Meditation value, $Res Function(_Meditation) _then) = __$MeditationCopyWithImpl;
@override @useResult
$Res call({
 String id, LocalizedText title, LocalizedText description, List<String> categoryIds, int durationMinutes, String audioSource, String? coverImage, String narrator, bool isPremium, List<String> tags
});


@override $LocalizedTextCopyWith<$Res> get title;@override $LocalizedTextCopyWith<$Res> get description;

}
/// @nodoc
class __$MeditationCopyWithImpl<$Res>
    implements _$MeditationCopyWith<$Res> {
  __$MeditationCopyWithImpl(this._self, this._then);

  final _Meditation _self;
  final $Res Function(_Meditation) _then;

/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? categoryIds = null,Object? durationMinutes = null,Object? audioSource = null,Object? coverImage = freezed,Object? narrator = null,Object? isPremium = null,Object? tags = null,}) {
  return _then(_Meditation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,audioSource: null == audioSource ? _self.audioSource : audioSource // ignore: cast_nullable_to_non_nullable
as String,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,narrator: null == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get title {
  
  return $LocalizedTextCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of Meditation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}
}

// dart format on

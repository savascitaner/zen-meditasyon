// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meditation_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeditationFilter {

 String? get categoryId;/// Keeps meditations of at most this many minutes, see
/// `meditationDurationOptions`.
 int? get maxDuration; bool get includePremium;
/// Create a copy of MeditationFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeditationFilterCopyWith<MeditationFilter> get copyWith => _$MeditationFilterCopyWithImpl<MeditationFilter>(this as MeditationFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MeditationFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeditationFilter&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.maxDuration, _this.maxDuration) || other.maxDuration == _this.maxDuration)&&(identical(other.includePremium, _this.includePremium) || other.includePremium == _this.includePremium));
}


@override
int get hashCode {
  final _this = this as MeditationFilter;
  return Object.hash(runtimeType,_this.categoryId,_this.maxDuration,_this.includePremium);
}

@override
String toString() {
  final _this = this as MeditationFilter;
  return 'MeditationFilter(categoryId: ${_this.categoryId}, maxDuration: ${_this.maxDuration}, includePremium: ${_this.includePremium})';
}


}

/// @nodoc
abstract mixin class $MeditationFilterCopyWith<$Res>  {
  factory $MeditationFilterCopyWith(MeditationFilter value, $Res Function(MeditationFilter) _then) = _$MeditationFilterCopyWithImpl;
@useResult
$Res call({
 String? categoryId, int? maxDuration, bool includePremium
});




}
/// @nodoc
class _$MeditationFilterCopyWithImpl<$Res>
    implements $MeditationFilterCopyWith<$Res> {
  _$MeditationFilterCopyWithImpl(this._self, this._then);

  final MeditationFilter _self;
  final $Res Function(MeditationFilter) _then;

/// Create a copy of MeditationFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? maxDuration = freezed,Object? includePremium = null,}) {
  return _then(MeditationFilter(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,maxDuration: freezed == maxDuration ? _self.maxDuration : maxDuration // ignore: cast_nullable_to_non_nullable
as int?,includePremium: null == includePremium ? _self.includePremium : includePremium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeditationFilter].
extension MeditationFilterPatterns on MeditationFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeditationFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeditationFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeditationFilter value)  $default,){
final _that = this;
switch (_that) {
case _MeditationFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeditationFilter value)?  $default,){
final _that = this;
switch (_that) {
case _MeditationFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? categoryId,  int? maxDuration,  bool includePremium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeditationFilter() when $default != null:
return $default(_that.categoryId,_that.maxDuration,_that.includePremium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? categoryId,  int? maxDuration,  bool includePremium)  $default,) {final _that = this;
switch (_that) {
case _MeditationFilter():
return $default(_that.categoryId,_that.maxDuration,_that.includePremium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? categoryId,  int? maxDuration,  bool includePremium)?  $default,) {final _that = this;
switch (_that) {
case _MeditationFilter() when $default != null:
return $default(_that.categoryId,_that.maxDuration,_that.includePremium);case _:
  return null;

}
}

}

/// @nodoc


class _MeditationFilter implements MeditationFilter {
  const _MeditationFilter({this.categoryId, this.maxDuration, this.includePremium = true});
  

@override final  String? categoryId;
/// Keeps meditations of at most this many minutes, see
/// `meditationDurationOptions`.
@override final  int? maxDuration;
@override@JsonKey() final  bool includePremium;

/// Create a copy of MeditationFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeditationFilterCopyWith<_MeditationFilter> get copyWith => __$MeditationFilterCopyWithImpl<_MeditationFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeditationFilter&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.maxDuration, maxDuration) || other.maxDuration == maxDuration)&&(identical(other.includePremium, includePremium) || other.includePremium == includePremium));
}


@override
int get hashCode {
    return Object.hash(runtimeType,categoryId,maxDuration,includePremium);
}

@override
String toString() {
    return 'MeditationFilter(categoryId: $categoryId, maxDuration: $maxDuration, includePremium: $includePremium)';
}


}

/// @nodoc
abstract mixin class _$MeditationFilterCopyWith<$Res> implements $MeditationFilterCopyWith<$Res> {
  factory _$MeditationFilterCopyWith(_MeditationFilter value, $Res Function(_MeditationFilter) _then) = __$MeditationFilterCopyWithImpl;
@override @useResult
$Res call({
 String? categoryId, int? maxDuration, bool includePremium
});




}
/// @nodoc
class __$MeditationFilterCopyWithImpl<$Res>
    implements _$MeditationFilterCopyWith<$Res> {
  __$MeditationFilterCopyWithImpl(this._self, this._then);

  final _MeditationFilter _self;
  final $Res Function(_MeditationFilter) _then;

/// Create a copy of MeditationFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? maxDuration = freezed,Object? includePremium = null,}) {
  return _then(_MeditationFilter(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,maxDuration: freezed == maxDuration ? _self.maxDuration : maxDuration // ignore: cast_nullable_to_non_nullable
as int?,includePremium: null == includePremium ? _self.includePremium : includePremium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

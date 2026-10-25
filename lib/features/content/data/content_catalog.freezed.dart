// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentCatalog {

 List<Category> get categories; List<Meditation> get meditations; List<Program> get programs;
/// Create a copy of ContentCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentCatalogCopyWith<ContentCatalog> get copyWith => _$ContentCatalogCopyWithImpl<ContentCatalog>(this as ContentCatalog, _$identity);

  /// Serializes this ContentCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContentCatalog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentCatalog&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.meditations, _this.meditations)&&const DeepCollectionEquality().equals(other.programs, _this.programs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContentCatalog;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.meditations),const DeepCollectionEquality().hash(_this.programs));
}

@override
String toString() {
  final _this = this as ContentCatalog;
  return 'ContentCatalog(categories: ${_this.categories}, meditations: ${_this.meditations}, programs: ${_this.programs})';
}


}

/// @nodoc
abstract mixin class $ContentCatalogCopyWith<$Res>  {
  factory $ContentCatalogCopyWith(ContentCatalog value, $Res Function(ContentCatalog) _then) = _$ContentCatalogCopyWithImpl;
@useResult
$Res call({
 List<Category> categories, List<Meditation> meditations, List<Program> programs
});




}
/// @nodoc
class _$ContentCatalogCopyWithImpl<$Res>
    implements $ContentCatalogCopyWith<$Res> {
  _$ContentCatalogCopyWithImpl(this._self, this._then);

  final ContentCatalog _self;
  final $Res Function(ContentCatalog) _then;

/// Create a copy of ContentCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? meditations = null,Object? programs = null,}) {
  return _then(ContentCatalog(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,meditations: null == meditations ? _self.meditations : meditations // ignore: cast_nullable_to_non_nullable
as List<Meditation>,programs: null == programs ? _self.programs : programs // ignore: cast_nullable_to_non_nullable
as List<Program>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentCatalog].
extension ContentCatalogPatterns on ContentCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentCatalog value)  $default,){
final _that = this;
switch (_that) {
case _ContentCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _ContentCatalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Category> categories,  List<Meditation> meditations,  List<Program> programs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentCatalog() when $default != null:
return $default(_that.categories,_that.meditations,_that.programs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Category> categories,  List<Meditation> meditations,  List<Program> programs)  $default,) {final _that = this;
switch (_that) {
case _ContentCatalog():
return $default(_that.categories,_that.meditations,_that.programs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Category> categories,  List<Meditation> meditations,  List<Program> programs)?  $default,) {final _that = this;
switch (_that) {
case _ContentCatalog() when $default != null:
return $default(_that.categories,_that.meditations,_that.programs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContentCatalog implements ContentCatalog {
  const _ContentCatalog({required  List<Category> categories, required  List<Meditation> meditations, required  List<Program> programs}): _categories = categories,_meditations = meditations,_programs = programs;
  factory _ContentCatalog.fromJson(Map<String, dynamic> json) => _$ContentCatalogFromJson(json);

 final  List<Category> _categories;
@override List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Meditation> _meditations;
@override List<Meditation> get meditations {
  if (_meditations is EqualUnmodifiableListView) return _meditations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meditations);
}

 final  List<Program> _programs;
@override List<Program> get programs {
  if (_programs is EqualUnmodifiableListView) return _programs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_programs);
}


/// Create a copy of ContentCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentCatalogCopyWith<_ContentCatalog> get copyWith => __$ContentCatalogCopyWithImpl<_ContentCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentCatalog&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.meditations, _meditations)&&const DeepCollectionEquality().equals(other.programs, _programs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_meditations),const DeepCollectionEquality().hash(_programs));
}

@override
String toString() {
    return 'ContentCatalog(categories: $categories, meditations: $meditations, programs: $programs)';
}


}

/// @nodoc
abstract mixin class _$ContentCatalogCopyWith<$Res> implements $ContentCatalogCopyWith<$Res> {
  factory _$ContentCatalogCopyWith(_ContentCatalog value, $Res Function(_ContentCatalog) _then) = __$ContentCatalogCopyWithImpl;
@override @useResult
$Res call({
 List<Category> categories, List<Meditation> meditations, List<Program> programs
});




}
/// @nodoc
class __$ContentCatalogCopyWithImpl<$Res>
    implements _$ContentCatalogCopyWith<$Res> {
  __$ContentCatalogCopyWithImpl(this._self, this._then);

  final _ContentCatalog _self;
  final $Res Function(_ContentCatalog) _then;

/// Create a copy of ContentCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? meditations = null,Object? programs = null,}) {
  return _then(_ContentCatalog(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,meditations: null == meditations ? _self._meditations : meditations // ignore: cast_nullable_to_non_nullable
as List<Meditation>,programs: null == programs ? _self._programs : programs // ignore: cast_nullable_to_non_nullable
as List<Program>,
  ));
}


}

// dart format on

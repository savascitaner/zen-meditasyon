// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramDay {

 int get dayNumber; String get meditationId; LocalizedText get note;
/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramDayCopyWith<ProgramDay> get copyWith => _$ProgramDayCopyWithImpl<ProgramDay>(this as ProgramDay, _$identity);

  /// Serializes this ProgramDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramDay&&(identical(other.dayNumber, _this.dayNumber) || other.dayNumber == _this.dayNumber)&&(identical(other.meditationId, _this.meditationId) || other.meditationId == _this.meditationId)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramDay;
  return Object.hash(runtimeType,_this.dayNumber,_this.meditationId,_this.note);
}

@override
String toString() {
  final _this = this as ProgramDay;
  return 'ProgramDay(dayNumber: ${_this.dayNumber}, meditationId: ${_this.meditationId}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $ProgramDayCopyWith<$Res>  {
  factory $ProgramDayCopyWith(ProgramDay value, $Res Function(ProgramDay) _then) = _$ProgramDayCopyWithImpl;
@useResult
$Res call({
 int dayNumber, String meditationId, LocalizedText note
});


$LocalizedTextCopyWith<$Res> get note;

}
/// @nodoc
class _$ProgramDayCopyWithImpl<$Res>
    implements $ProgramDayCopyWith<$Res> {
  _$ProgramDayCopyWithImpl(this._self, this._then);

  final ProgramDay _self;
  final $Res Function(ProgramDay) _then;

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayNumber = null,Object? meditationId = null,Object? note = null,}) {
  return _then(ProgramDay(
dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,meditationId: null == meditationId ? _self.meditationId : meditationId // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}
/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get note {
  
  return $LocalizedTextCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgramDay].
extension ProgramDayPatterns on ProgramDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramDay value)  $default,){
final _that = this;
switch (_that) {
case _ProgramDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramDay value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayNumber,  String meditationId,  LocalizedText note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
return $default(_that.dayNumber,_that.meditationId,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayNumber,  String meditationId,  LocalizedText note)  $default,) {final _that = this;
switch (_that) {
case _ProgramDay():
return $default(_that.dayNumber,_that.meditationId,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayNumber,  String meditationId,  LocalizedText note)?  $default,) {final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
return $default(_that.dayNumber,_that.meditationId,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramDay implements ProgramDay {
  const _ProgramDay({required this.dayNumber, required this.meditationId, required this.note});
  factory _ProgramDay.fromJson(Map<String, dynamic> json) => _$ProgramDayFromJson(json);

@override final  int dayNumber;
@override final  String meditationId;
@override final  LocalizedText note;

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramDayCopyWith<_ProgramDay> get copyWith => __$ProgramDayCopyWithImpl<_ProgramDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramDay&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.meditationId, meditationId) || other.meditationId == meditationId)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dayNumber,meditationId,note);
}

@override
String toString() {
    return 'ProgramDay(dayNumber: $dayNumber, meditationId: $meditationId, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ProgramDayCopyWith<$Res> implements $ProgramDayCopyWith<$Res> {
  factory _$ProgramDayCopyWith(_ProgramDay value, $Res Function(_ProgramDay) _then) = __$ProgramDayCopyWithImpl;
@override @useResult
$Res call({
 int dayNumber, String meditationId, LocalizedText note
});


@override $LocalizedTextCopyWith<$Res> get note;

}
/// @nodoc
class __$ProgramDayCopyWithImpl<$Res>
    implements _$ProgramDayCopyWith<$Res> {
  __$ProgramDayCopyWithImpl(this._self, this._then);

  final _ProgramDay _self;
  final $Res Function(_ProgramDay) _then;

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayNumber = null,Object? meditationId = null,Object? note = null,}) {
  return _then(_ProgramDay(
dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,meditationId: null == meditationId ? _self.meditationId : meditationId // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get note {
  
  return $LocalizedTextCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerState {

 PlayerStatus get status; Duration get position; Duration get duration; Meditation? get meditation; PlayerError? get error;/// Set when the audio played to its end and the session counted as
/// completed; the screen shows the completion sheet for it.
 PracticeSession? get completedSession;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.meditation, _this.meditation) || other.meditation == _this.meditation)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.completedSession, _this.completedSession) || other.completedSession == _this.completedSession));
}


@override
int get hashCode {
  final _this = this as PlayerState;
  return Object.hash(runtimeType,_this.status,_this.position,_this.duration,_this.meditation,_this.error,_this.completedSession);
}

@override
String toString() {
  final _this = this as PlayerState;
  return 'PlayerState(status: ${_this.status}, position: ${_this.position}, duration: ${_this.duration}, meditation: ${_this.meditation}, error: ${_this.error}, completedSession: ${_this.completedSession})';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 PlayerStatus status, Duration position, Duration duration, Meditation? meditation, PlayerError? error, PracticeSession? completedSession
});


$MeditationCopyWith<$Res>? get meditation;$PracticeSessionCopyWith<$Res>? get completedSession;

}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? position = null,Object? duration = null,Object? meditation = freezed,Object? error = freezed,Object? completedSession = freezed,}) {
  return _then(PlayerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlayerStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,meditation: freezed == meditation ? _self.meditation : meditation // ignore: cast_nullable_to_non_nullable
as Meditation?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as PlayerError?,completedSession: freezed == completedSession ? _self.completedSession : completedSession // ignore: cast_nullable_to_non_nullable
as PracticeSession?,
  ));
}
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeditationCopyWith<$Res>? get meditation {
    if (_self.meditation == null) {
    return null;
  }

  return $MeditationCopyWith<$Res>(_self.meditation!, (value) {
    return _then(_self.copyWith(meditation: value));
  });
}/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PracticeSessionCopyWith<$Res>? get completedSession {
    if (_self.completedSession == null) {
    return null;
  }

  return $PracticeSessionCopyWith<$Res>(_self.completedSession!, (value) {
    return _then(_self.copyWith(completedSession: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayerStatus status,  Duration position,  Duration duration,  Meditation? meditation,  PlayerError? error,  PracticeSession? completedSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.status,_that.position,_that.duration,_that.meditation,_that.error,_that.completedSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayerStatus status,  Duration position,  Duration duration,  Meditation? meditation,  PlayerError? error,  PracticeSession? completedSession)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.status,_that.position,_that.duration,_that.meditation,_that.error,_that.completedSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayerStatus status,  Duration position,  Duration duration,  Meditation? meditation,  PlayerError? error,  PracticeSession? completedSession)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.status,_that.position,_that.duration,_that.meditation,_that.error,_that.completedSession);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState extends PlayerState {
  const _PlayerState({this.status = PlayerStatus.loading, this.position = Duration.zero, this.duration = Duration.zero, this.meditation, this.error, this.completedSession}): super._();
  

@override@JsonKey() final  PlayerStatus status;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration duration;
@override final  Meditation? meditation;
@override final  PlayerError? error;
/// Set when the audio played to its end and the session counted as
/// completed; the screen shows the completion sheet for it.
@override final  PracticeSession? completedSession;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.meditation, meditation) || other.meditation == meditation)&&(identical(other.error, error) || other.error == error)&&(identical(other.completedSession, completedSession) || other.completedSession == completedSession));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,position,duration,meditation,error,completedSession);
}

@override
String toString() {
    return 'PlayerState(status: $status, position: $position, duration: $duration, meditation: $meditation, error: $error, completedSession: $completedSession)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 PlayerStatus status, Duration position, Duration duration, Meditation? meditation, PlayerError? error, PracticeSession? completedSession
});


@override $MeditationCopyWith<$Res>? get meditation;@override $PracticeSessionCopyWith<$Res>? get completedSession;

}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? position = null,Object? duration = null,Object? meditation = freezed,Object? error = freezed,Object? completedSession = freezed,}) {
  return _then(_PlayerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlayerStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,meditation: freezed == meditation ? _self.meditation : meditation // ignore: cast_nullable_to_non_nullable
as Meditation?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as PlayerError?,completedSession: freezed == completedSession ? _self.completedSession : completedSession // ignore: cast_nullable_to_non_nullable
as PracticeSession?,
  ));
}

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeditationCopyWith<$Res>? get meditation {
    if (_self.meditation == null) {
    return null;
  }

  return $MeditationCopyWith<$Res>(_self.meditation!, (value) {
    return _then(_self.copyWith(meditation: value));
  });
}/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PracticeSessionCopyWith<$Res>? get completedSession {
    if (_self.completedSession == null) {
    return null;
  }

  return $PracticeSessionCopyWith<$Res>(_self.completedSession!, (value) {
    return _then(_self.copyWith(completedSession: value));
  });
}
}

// dart format on

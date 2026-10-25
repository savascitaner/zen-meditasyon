// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingProfile {

 StressLevel? get stressLevel; MeditationExperience? get experience; bool get completed;
/// Create a copy of OnboardingProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileCopyWith<OnboardingProfile> get copyWith => _$OnboardingProfileCopyWithImpl<OnboardingProfile>(this as OnboardingProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfile&&(identical(other.stressLevel, _this.stressLevel) || other.stressLevel == _this.stressLevel)&&(identical(other.experience, _this.experience) || other.experience == _this.experience)&&(identical(other.completed, _this.completed) || other.completed == _this.completed));
}


@override
int get hashCode {
  final _this = this as OnboardingProfile;
  return Object.hash(runtimeType,_this.stressLevel,_this.experience,_this.completed);
}

@override
String toString() {
  final _this = this as OnboardingProfile;
  return 'OnboardingProfile(stressLevel: ${_this.stressLevel}, experience: ${_this.experience}, completed: ${_this.completed})';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileCopyWith<$Res>  {
  factory $OnboardingProfileCopyWith(OnboardingProfile value, $Res Function(OnboardingProfile) _then) = _$OnboardingProfileCopyWithImpl;
@useResult
$Res call({
 StressLevel? stressLevel, MeditationExperience? experience, bool completed
});




}
/// @nodoc
class _$OnboardingProfileCopyWithImpl<$Res>
    implements $OnboardingProfileCopyWith<$Res> {
  _$OnboardingProfileCopyWithImpl(this._self, this._then);

  final OnboardingProfile _self;
  final $Res Function(OnboardingProfile) _then;

/// Create a copy of OnboardingProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stressLevel = freezed,Object? experience = freezed,Object? completed = null,}) {
  return _then(OnboardingProfile(
stressLevel: freezed == stressLevel ? _self.stressLevel : stressLevel // ignore: cast_nullable_to_non_nullable
as StressLevel?,experience: freezed == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as MeditationExperience?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingProfile].
extension OnboardingProfilePatterns on OnboardingProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfile value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfile value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StressLevel? stressLevel,  MeditationExperience? experience,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfile() when $default != null:
return $default(_that.stressLevel,_that.experience,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StressLevel? stressLevel,  MeditationExperience? experience,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfile():
return $default(_that.stressLevel,_that.experience,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StressLevel? stressLevel,  MeditationExperience? experience,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfile() when $default != null:
return $default(_that.stressLevel,_that.experience,_that.completed);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingProfile implements OnboardingProfile {
  const _OnboardingProfile({this.stressLevel, this.experience, this.completed = false});
  

@override final  StressLevel? stressLevel;
@override final  MeditationExperience? experience;
@override@JsonKey() final  bool completed;

/// Create a copy of OnboardingProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileCopyWith<_OnboardingProfile> get copyWith => __$OnboardingProfileCopyWithImpl<_OnboardingProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfile&&(identical(other.stressLevel, stressLevel) || other.stressLevel == stressLevel)&&(identical(other.experience, experience) || other.experience == experience)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stressLevel,experience,completed);
}

@override
String toString() {
    return 'OnboardingProfile(stressLevel: $stressLevel, experience: $experience, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileCopyWith<$Res> implements $OnboardingProfileCopyWith<$Res> {
  factory _$OnboardingProfileCopyWith(_OnboardingProfile value, $Res Function(_OnboardingProfile) _then) = __$OnboardingProfileCopyWithImpl;
@override @useResult
$Res call({
 StressLevel? stressLevel, MeditationExperience? experience, bool completed
});




}
/// @nodoc
class __$OnboardingProfileCopyWithImpl<$Res>
    implements _$OnboardingProfileCopyWith<$Res> {
  __$OnboardingProfileCopyWithImpl(this._self, this._then);

  final _OnboardingProfile _self;
  final $Res Function(_OnboardingProfile) _then;

/// Create a copy of OnboardingProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stressLevel = freezed,Object? experience = freezed,Object? completed = null,}) {
  return _then(_OnboardingProfile(
stressLevel: freezed == stressLevel ? _self.stressLevel : stressLevel // ignore: cast_nullable_to_non_nullable
as StressLevel?,experience: freezed == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as MeditationExperience?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

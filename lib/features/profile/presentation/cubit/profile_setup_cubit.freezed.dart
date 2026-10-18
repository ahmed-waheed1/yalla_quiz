// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_setup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSetupState {

 String get name; int get avatarSeed; int get shuffleCount; bool get saving; bool get failed;
/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSetupStateCopyWith<ProfileSetupState> get copyWith => _$ProfileSetupStateCopyWithImpl<ProfileSetupState>(this as ProfileSetupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileSetupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSetupState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatarSeed, _this.avatarSeed) || other.avatarSeed == _this.avatarSeed)&&(identical(other.shuffleCount, _this.shuffleCount) || other.shuffleCount == _this.shuffleCount)&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.failed, _this.failed) || other.failed == _this.failed));
}


@override
int get hashCode {
  final _this = this as ProfileSetupState;
  return Object.hash(runtimeType,_this.name,_this.avatarSeed,_this.shuffleCount,_this.saving,_this.failed);
}

@override
String toString() {
  final _this = this as ProfileSetupState;
  return 'ProfileSetupState(name: ${_this.name}, avatarSeed: ${_this.avatarSeed}, shuffleCount: ${_this.shuffleCount}, saving: ${_this.saving}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $ProfileSetupStateCopyWith<$Res>  {
  factory $ProfileSetupStateCopyWith(ProfileSetupState value, $Res Function(ProfileSetupState) _then) = _$ProfileSetupStateCopyWithImpl;
@useResult
$Res call({
 String name, int avatarSeed, int shuffleCount, bool saving, bool failed
});




}
/// @nodoc
class _$ProfileSetupStateCopyWithImpl<$Res>
    implements $ProfileSetupStateCopyWith<$Res> {
  _$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final ProfileSetupState _self;
  final $Res Function(ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatarSeed = null,Object? shuffleCount = null,Object? saving = null,Object? failed = null,}) {
  return _then(ProfileSetupState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarSeed: null == avatarSeed ? _self.avatarSeed : avatarSeed // ignore: cast_nullable_to_non_nullable
as int,shuffleCount: null == shuffleCount ? _self.shuffleCount : shuffleCount // ignore: cast_nullable_to_non_nullable
as int,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSetupState].
extension ProfileSetupStatePatterns on ProfileSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSetupState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int avatarSeed,  int shuffleCount,  bool saving,  bool failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.name,_that.avatarSeed,_that.shuffleCount,_that.saving,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int avatarSeed,  int shuffleCount,  bool saving,  bool failed)  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState():
return $default(_that.name,_that.avatarSeed,_that.shuffleCount,_that.saving,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int avatarSeed,  int shuffleCount,  bool saving,  bool failed)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.name,_that.avatarSeed,_that.shuffleCount,_that.saving,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileSetupState extends ProfileSetupState {
  const _ProfileSetupState({required this.name, required this.avatarSeed, this.shuffleCount = 0, this.saving = false, this.failed = false}): super._();
  

@override final  String name;
@override final  int avatarSeed;
@override@JsonKey() final  int shuffleCount;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool failed;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSetupStateCopyWith<_ProfileSetupState> get copyWith => __$ProfileSetupStateCopyWithImpl<_ProfileSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSetupState&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarSeed, avatarSeed) || other.avatarSeed == avatarSeed)&&(identical(other.shuffleCount, shuffleCount) || other.shuffleCount == shuffleCount)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,avatarSeed,shuffleCount,saving,failed);
}

@override
String toString() {
    return 'ProfileSetupState(name: $name, avatarSeed: $avatarSeed, shuffleCount: $shuffleCount, saving: $saving, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$ProfileSetupStateCopyWith<$Res> implements $ProfileSetupStateCopyWith<$Res> {
  factory _$ProfileSetupStateCopyWith(_ProfileSetupState value, $Res Function(_ProfileSetupState) _then) = __$ProfileSetupStateCopyWithImpl;
@override @useResult
$Res call({
 String name, int avatarSeed, int shuffleCount, bool saving, bool failed
});




}
/// @nodoc
class __$ProfileSetupStateCopyWithImpl<$Res>
    implements _$ProfileSetupStateCopyWith<$Res> {
  __$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final _ProfileSetupState _self;
  final $Res Function(_ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatarSeed = null,Object? shuffleCount = null,Object? saving = null,Object? failed = null,}) {
  return _then(_ProfileSetupState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarSeed: null == avatarSeed ? _self.avatarSeed : avatarSeed // ignore: cast_nullable_to_non_nullable
as int,shuffleCount: null == shuffleCount ? _self.shuffleCount : shuffleCount // ignore: cast_nullable_to_non_nullable
as int,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

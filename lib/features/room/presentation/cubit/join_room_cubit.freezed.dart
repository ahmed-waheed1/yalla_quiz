// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_room_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinRoomState {

 String get code; bool get submitting;/// Shown as the error card under the boxes (not found / full / started).
 Failure? get error;/// Bumped on every error so the boxes shake again.
 int get errorCount;/// Other failures (network, …) shown as a toast.
 Failure? get transientFailure; String? get joinedCode;
/// Create a copy of JoinRoomState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinRoomStateCopyWith<JoinRoomState> get copyWith => _$JoinRoomStateCopyWithImpl<JoinRoomState>(this as JoinRoomState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JoinRoomState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinRoomState&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.errorCount, _this.errorCount) || other.errorCount == _this.errorCount)&&(identical(other.transientFailure, _this.transientFailure) || other.transientFailure == _this.transientFailure)&&(identical(other.joinedCode, _this.joinedCode) || other.joinedCode == _this.joinedCode));
}


@override
int get hashCode {
  final _this = this as JoinRoomState;
  return Object.hash(runtimeType,_this.code,_this.submitting,_this.error,_this.errorCount,_this.transientFailure,_this.joinedCode);
}

@override
String toString() {
  final _this = this as JoinRoomState;
  return 'JoinRoomState(code: ${_this.code}, submitting: ${_this.submitting}, error: ${_this.error}, errorCount: ${_this.errorCount}, transientFailure: ${_this.transientFailure}, joinedCode: ${_this.joinedCode})';
}


}

/// @nodoc
abstract mixin class $JoinRoomStateCopyWith<$Res>  {
  factory $JoinRoomStateCopyWith(JoinRoomState value, $Res Function(JoinRoomState) _then) = _$JoinRoomStateCopyWithImpl;
@useResult
$Res call({
 String code, bool submitting, Failure? error, int errorCount, Failure? transientFailure, String? joinedCode
});




}
/// @nodoc
class _$JoinRoomStateCopyWithImpl<$Res>
    implements $JoinRoomStateCopyWith<$Res> {
  _$JoinRoomStateCopyWithImpl(this._self, this._then);

  final JoinRoomState _self;
  final $Res Function(JoinRoomState) _then;

/// Create a copy of JoinRoomState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? submitting = null,Object? error = freezed,Object? errorCount = null,Object? transientFailure = freezed,Object? joinedCode = freezed,}) {
  return _then(JoinRoomState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,joinedCode: freezed == joinedCode ? _self.joinedCode : joinedCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinRoomState].
extension JoinRoomStatePatterns on JoinRoomState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinRoomState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinRoomState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinRoomState value)  $default,){
final _that = this;
switch (_that) {
case _JoinRoomState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinRoomState value)?  $default,){
final _that = this;
switch (_that) {
case _JoinRoomState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  bool submitting,  Failure? error,  int errorCount,  Failure? transientFailure,  String? joinedCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinRoomState() when $default != null:
return $default(_that.code,_that.submitting,_that.error,_that.errorCount,_that.transientFailure,_that.joinedCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  bool submitting,  Failure? error,  int errorCount,  Failure? transientFailure,  String? joinedCode)  $default,) {final _that = this;
switch (_that) {
case _JoinRoomState():
return $default(_that.code,_that.submitting,_that.error,_that.errorCount,_that.transientFailure,_that.joinedCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  bool submitting,  Failure? error,  int errorCount,  Failure? transientFailure,  String? joinedCode)?  $default,) {final _that = this;
switch (_that) {
case _JoinRoomState() when $default != null:
return $default(_that.code,_that.submitting,_that.error,_that.errorCount,_that.transientFailure,_that.joinedCode);case _:
  return null;

}
}

}

/// @nodoc


class _JoinRoomState extends JoinRoomState {
  const _JoinRoomState({this.code = '', this.submitting = false, this.error, this.errorCount = 0, this.transientFailure, this.joinedCode}): super._();
  

@override@JsonKey() final  String code;
@override@JsonKey() final  bool submitting;
/// Shown as the error card under the boxes (not found / full / started).
@override final  Failure? error;
/// Bumped on every error so the boxes shake again.
@override@JsonKey() final  int errorCount;
/// Other failures (network, …) shown as a toast.
@override final  Failure? transientFailure;
@override final  String? joinedCode;

/// Create a copy of JoinRoomState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinRoomStateCopyWith<_JoinRoomState> get copyWith => __$JoinRoomStateCopyWithImpl<_JoinRoomState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinRoomState&&(identical(other.code, code) || other.code == code)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure)&&(identical(other.joinedCode, joinedCode) || other.joinedCode == joinedCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,submitting,error,errorCount,transientFailure,joinedCode);
}

@override
String toString() {
    return 'JoinRoomState(code: $code, submitting: $submitting, error: $error, errorCount: $errorCount, transientFailure: $transientFailure, joinedCode: $joinedCode)';
}


}

/// @nodoc
abstract mixin class _$JoinRoomStateCopyWith<$Res> implements $JoinRoomStateCopyWith<$Res> {
  factory _$JoinRoomStateCopyWith(_JoinRoomState value, $Res Function(_JoinRoomState) _then) = __$JoinRoomStateCopyWithImpl;
@override @useResult
$Res call({
 String code, bool submitting, Failure? error, int errorCount, Failure? transientFailure, String? joinedCode
});




}
/// @nodoc
class __$JoinRoomStateCopyWithImpl<$Res>
    implements _$JoinRoomStateCopyWith<$Res> {
  __$JoinRoomStateCopyWithImpl(this._self, this._then);

  final _JoinRoomState _self;
  final $Res Function(_JoinRoomState) _then;

/// Create a copy of JoinRoomState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? submitting = null,Object? error = freezed,Object? errorCount = null,Object? transientFailure = freezed,Object? joinedCode = freezed,}) {
  return _then(_JoinRoomState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,joinedCode: freezed == joinedCode ? _self.joinedCode : joinedCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

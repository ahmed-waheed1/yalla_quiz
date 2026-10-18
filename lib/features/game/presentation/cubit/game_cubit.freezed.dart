// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameState {

 Room? get room; String? get myUid;/// The room's category, by question id.
 Map<String, Question> get questions;/// My pick while its write is in flight, for question [pendingIndex].
 int? get pendingIndex; int? get pendingOption;/// Host is writing the start of the game.
 bool get starting;/// A player tapped "Play again" before the host did: show the lobby.
 bool get rematch;/// Last user-visible failure; [failureCount] changes with each one.
 Failure? get failure; int get failureCount;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GameState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.myUid, _this.myUid) || other.myUid == _this.myUid)&&const DeepCollectionEquality().equals(other.questions, _this.questions)&&(identical(other.pendingIndex, _this.pendingIndex) || other.pendingIndex == _this.pendingIndex)&&(identical(other.pendingOption, _this.pendingOption) || other.pendingOption == _this.pendingOption)&&(identical(other.starting, _this.starting) || other.starting == _this.starting)&&(identical(other.rematch, _this.rematch) || other.rematch == _this.rematch)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.failureCount, _this.failureCount) || other.failureCount == _this.failureCount));
}


@override
int get hashCode {
  final _this = this as GameState;
  return Object.hash(runtimeType,_this.room,_this.myUid,const DeepCollectionEquality().hash(_this.questions),_this.pendingIndex,_this.pendingOption,_this.starting,_this.rematch,_this.failure,_this.failureCount);
}

@override
String toString() {
  final _this = this as GameState;
  return 'GameState(room: ${_this.room}, myUid: ${_this.myUid}, questions: ${_this.questions}, pendingIndex: ${_this.pendingIndex}, pendingOption: ${_this.pendingOption}, starting: ${_this.starting}, rematch: ${_this.rematch}, failure: ${_this.failure}, failureCount: ${_this.failureCount})';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 Room? room, String? myUid, Map<String, Question> questions, int? pendingIndex, int? pendingOption, bool starting, bool rematch, Failure? failure, int failureCount
});


$RoomCopyWith<$Res>? get room;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? room = freezed,Object? myUid = freezed,Object? questions = null,Object? pendingIndex = freezed,Object? pendingOption = freezed,Object? starting = null,Object? rematch = null,Object? failure = freezed,Object? failureCount = null,}) {
  return _then(GameState(
room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as Room?,myUid: freezed == myUid ? _self.myUid : myUid // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as Map<String, Question>,pendingIndex: freezed == pendingIndex ? _self.pendingIndex : pendingIndex // ignore: cast_nullable_to_non_nullable
as int?,pendingOption: freezed == pendingOption ? _self.pendingOption : pendingOption // ignore: cast_nullable_to_non_nullable
as int?,starting: null == starting ? _self.starting : starting // ignore: cast_nullable_to_non_nullable
as bool,rematch: null == rematch ? _self.rematch : rematch // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCopyWith<$Res>? get room {
    if (_self.room == null) {
    return null;
  }

  return $RoomCopyWith<$Res>(_self.room!, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Room? room,  String? myUid,  Map<String, Question> questions,  int? pendingIndex,  int? pendingOption,  bool starting,  bool rematch,  Failure? failure,  int failureCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.room,_that.myUid,_that.questions,_that.pendingIndex,_that.pendingOption,_that.starting,_that.rematch,_that.failure,_that.failureCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Room? room,  String? myUid,  Map<String, Question> questions,  int? pendingIndex,  int? pendingOption,  bool starting,  bool rematch,  Failure? failure,  int failureCount)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.room,_that.myUid,_that.questions,_that.pendingIndex,_that.pendingOption,_that.starting,_that.rematch,_that.failure,_that.failureCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Room? room,  String? myUid,  Map<String, Question> questions,  int? pendingIndex,  int? pendingOption,  bool starting,  bool rematch,  Failure? failure,  int failureCount)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.room,_that.myUid,_that.questions,_that.pendingIndex,_that.pendingOption,_that.starting,_that.rematch,_that.failure,_that.failureCount);case _:
  return null;

}
}

}

/// @nodoc


class _GameState extends GameState {
  const _GameState({this.room, this.myUid,  Map<String, Question> questions = const <String, Question>{}, this.pendingIndex, this.pendingOption, this.starting = false, this.rematch = false, this.failure, this.failureCount = 0}): _questions = questions,super._();
  

@override final  Room? room;
@override final  String? myUid;
/// The room's category, by question id.
 final  Map<String, Question> _questions;
/// The room's category, by question id.
@override@JsonKey() Map<String, Question> get questions {
  if (_questions is EqualUnmodifiableMapView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_questions);
}

/// My pick while its write is in flight, for question [pendingIndex].
@override final  int? pendingIndex;
@override final  int? pendingOption;
/// Host is writing the start of the game.
@override@JsonKey() final  bool starting;
/// A player tapped "Play again" before the host did: show the lobby.
@override@JsonKey() final  bool rematch;
/// Last user-visible failure; [failureCount] changes with each one.
@override final  Failure? failure;
@override@JsonKey() final  int failureCount;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.room, room) || other.room == room)&&(identical(other.myUid, myUid) || other.myUid == myUid)&&const DeepCollectionEquality().equals(other.questions, _questions)&&(identical(other.pendingIndex, pendingIndex) || other.pendingIndex == pendingIndex)&&(identical(other.pendingOption, pendingOption) || other.pendingOption == pendingOption)&&(identical(other.starting, starting) || other.starting == starting)&&(identical(other.rematch, rematch) || other.rematch == rematch)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,room,myUid,const DeepCollectionEquality().hash(_questions),pendingIndex,pendingOption,starting,rematch,failure,failureCount);
}

@override
String toString() {
    return 'GameState(room: $room, myUid: $myUid, questions: $questions, pendingIndex: $pendingIndex, pendingOption: $pendingOption, starting: $starting, rematch: $rematch, failure: $failure, failureCount: $failureCount)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 Room? room, String? myUid, Map<String, Question> questions, int? pendingIndex, int? pendingOption, bool starting, bool rematch, Failure? failure, int failureCount
});


@override $RoomCopyWith<$Res>? get room;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? room = freezed,Object? myUid = freezed,Object? questions = null,Object? pendingIndex = freezed,Object? pendingOption = freezed,Object? starting = null,Object? rematch = null,Object? failure = freezed,Object? failureCount = null,}) {
  return _then(_GameState(
room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as Room?,myUid: freezed == myUid ? _self.myUid : myUid // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as Map<String, Question>,pendingIndex: freezed == pendingIndex ? _self.pendingIndex : pendingIndex // ignore: cast_nullable_to_non_nullable
as int?,pendingOption: freezed == pendingOption ? _self.pendingOption : pendingOption // ignore: cast_nullable_to_non_nullable
as int?,starting: null == starting ? _self.starting : starting // ignore: cast_nullable_to_non_nullable
as bool,rematch: null == rematch ? _self.rematch : rematch // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomCopyWith<$Res>? get room {
    if (_self.room == null) {
    return null;
  }

  return $RoomCopyWith<$Res>(_self.room!, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}

// dart format on

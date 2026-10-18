// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LobbyState {

 LobbyStatus get status; Room? get room; String? get myUid; bool get online; bool get leaving;/// Bumped each time this player is promoted to host (for a toast).
 int get promotedCount; Failure? get failure;
/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LobbyStateCopyWith<LobbyState> get copyWith => _$LobbyStateCopyWithImpl<LobbyState>(this as LobbyState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LobbyState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LobbyState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.myUid, _this.myUid) || other.myUid == _this.myUid)&&(identical(other.online, _this.online) || other.online == _this.online)&&(identical(other.leaving, _this.leaving) || other.leaving == _this.leaving)&&(identical(other.promotedCount, _this.promotedCount) || other.promotedCount == _this.promotedCount)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as LobbyState;
  return Object.hash(runtimeType,_this.status,_this.room,_this.myUid,_this.online,_this.leaving,_this.promotedCount,_this.failure);
}

@override
String toString() {
  final _this = this as LobbyState;
  return 'LobbyState(status: ${_this.status}, room: ${_this.room}, myUid: ${_this.myUid}, online: ${_this.online}, leaving: ${_this.leaving}, promotedCount: ${_this.promotedCount}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $LobbyStateCopyWith<$Res>  {
  factory $LobbyStateCopyWith(LobbyState value, $Res Function(LobbyState) _then) = _$LobbyStateCopyWithImpl;
@useResult
$Res call({
 LobbyStatus status, Room? room, String? myUid, bool online, bool leaving, int promotedCount, Failure? failure
});


$RoomCopyWith<$Res>? get room;

}
/// @nodoc
class _$LobbyStateCopyWithImpl<$Res>
    implements $LobbyStateCopyWith<$Res> {
  _$LobbyStateCopyWithImpl(this._self, this._then);

  final LobbyState _self;
  final $Res Function(LobbyState) _then;

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? room = freezed,Object? myUid = freezed,Object? online = null,Object? leaving = null,Object? promotedCount = null,Object? failure = freezed,}) {
  return _then(LobbyState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LobbyStatus,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as Room?,myUid: freezed == myUid ? _self.myUid : myUid // ignore: cast_nullable_to_non_nullable
as String?,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,leaving: null == leaving ? _self.leaving : leaving // ignore: cast_nullable_to_non_nullable
as bool,promotedCount: null == promotedCount ? _self.promotedCount : promotedCount // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of LobbyState
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


/// Adds pattern-matching-related methods to [LobbyState].
extension LobbyStatePatterns on LobbyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LobbyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LobbyState value)  $default,){
final _that = this;
switch (_that) {
case _LobbyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LobbyState value)?  $default,){
final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LobbyStatus status,  Room? room,  String? myUid,  bool online,  bool leaving,  int promotedCount,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
return $default(_that.status,_that.room,_that.myUid,_that.online,_that.leaving,_that.promotedCount,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LobbyStatus status,  Room? room,  String? myUid,  bool online,  bool leaving,  int promotedCount,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _LobbyState():
return $default(_that.status,_that.room,_that.myUid,_that.online,_that.leaving,_that.promotedCount,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LobbyStatus status,  Room? room,  String? myUid,  bool online,  bool leaving,  int promotedCount,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _LobbyState() when $default != null:
return $default(_that.status,_that.room,_that.myUid,_that.online,_that.leaving,_that.promotedCount,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _LobbyState extends LobbyState {
  const _LobbyState({this.status = LobbyStatus.loading, this.room, this.myUid, this.online = true, this.leaving = false, this.promotedCount = 0, this.failure}): super._();
  

@override@JsonKey() final  LobbyStatus status;
@override final  Room? room;
@override final  String? myUid;
@override@JsonKey() final  bool online;
@override@JsonKey() final  bool leaving;
/// Bumped each time this player is promoted to host (for a toast).
@override@JsonKey() final  int promotedCount;
@override final  Failure? failure;

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LobbyStateCopyWith<_LobbyState> get copyWith => __$LobbyStateCopyWithImpl<_LobbyState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LobbyState&&(identical(other.status, status) || other.status == status)&&(identical(other.room, room) || other.room == room)&&(identical(other.myUid, myUid) || other.myUid == myUid)&&(identical(other.online, online) || other.online == online)&&(identical(other.leaving, leaving) || other.leaving == leaving)&&(identical(other.promotedCount, promotedCount) || other.promotedCount == promotedCount)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,room,myUid,online,leaving,promotedCount,failure);
}

@override
String toString() {
    return 'LobbyState(status: $status, room: $room, myUid: $myUid, online: $online, leaving: $leaving, promotedCount: $promotedCount, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$LobbyStateCopyWith<$Res> implements $LobbyStateCopyWith<$Res> {
  factory _$LobbyStateCopyWith(_LobbyState value, $Res Function(_LobbyState) _then) = __$LobbyStateCopyWithImpl;
@override @useResult
$Res call({
 LobbyStatus status, Room? room, String? myUid, bool online, bool leaving, int promotedCount, Failure? failure
});


@override $RoomCopyWith<$Res>? get room;

}
/// @nodoc
class __$LobbyStateCopyWithImpl<$Res>
    implements _$LobbyStateCopyWith<$Res> {
  __$LobbyStateCopyWithImpl(this._self, this._then);

  final _LobbyState _self;
  final $Res Function(_LobbyState) _then;

/// Create a copy of LobbyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? room = freezed,Object? myUid = freezed,Object? online = null,Object? leaving = null,Object? promotedCount = null,Object? failure = freezed,}) {
  return _then(_LobbyState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LobbyStatus,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as Room?,myUid: freezed == myUid ? _self.myUid : myUid // ignore: cast_nullable_to_non_nullable
as String?,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,leaving: null == leaving ? _self.leaving : leaving // ignore: cast_nullable_to_non_nullable
as bool,promotedCount: null == promotedCount ? _self.promotedCount : promotedCount // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of LobbyState
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

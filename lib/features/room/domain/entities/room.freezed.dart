// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomSettings {

 String get category; int get questionCount; int get timePerQuestion; int get maxPlayers;
/// Create a copy of RoomSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSettingsCopyWith<RoomSettings> get copyWith => _$RoomSettingsCopyWithImpl<RoomSettings>(this as RoomSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoomSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSettings&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount)&&(identical(other.timePerQuestion, _this.timePerQuestion) || other.timePerQuestion == _this.timePerQuestion)&&(identical(other.maxPlayers, _this.maxPlayers) || other.maxPlayers == _this.maxPlayers));
}


@override
int get hashCode {
  final _this = this as RoomSettings;
  return Object.hash(runtimeType,_this.category,_this.questionCount,_this.timePerQuestion,_this.maxPlayers);
}

@override
String toString() {
  final _this = this as RoomSettings;
  return 'RoomSettings(category: ${_this.category}, questionCount: ${_this.questionCount}, timePerQuestion: ${_this.timePerQuestion}, maxPlayers: ${_this.maxPlayers})';
}


}

/// @nodoc
abstract mixin class $RoomSettingsCopyWith<$Res>  {
  factory $RoomSettingsCopyWith(RoomSettings value, $Res Function(RoomSettings) _then) = _$RoomSettingsCopyWithImpl;
@useResult
$Res call({
 String category, int questionCount, int timePerQuestion, int maxPlayers
});




}
/// @nodoc
class _$RoomSettingsCopyWithImpl<$Res>
    implements $RoomSettingsCopyWith<$Res> {
  _$RoomSettingsCopyWithImpl(this._self, this._then);

  final RoomSettings _self;
  final $Res Function(RoomSettings) _then;

/// Create a copy of RoomSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? questionCount = null,Object? timePerQuestion = null,Object? maxPlayers = null,}) {
  return _then(RoomSettings(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestion: null == timePerQuestion ? _self.timePerQuestion : timePerQuestion // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomSettings].
extension RoomSettingsPatterns on RoomSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSettings value)  $default,){
final _that = this;
switch (_that) {
case _RoomSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  int questionCount,  int timePerQuestion,  int maxPlayers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomSettings() when $default != null:
return $default(_that.category,_that.questionCount,_that.timePerQuestion,_that.maxPlayers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  int questionCount,  int timePerQuestion,  int maxPlayers)  $default,) {final _that = this;
switch (_that) {
case _RoomSettings():
return $default(_that.category,_that.questionCount,_that.timePerQuestion,_that.maxPlayers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  int questionCount,  int timePerQuestion,  int maxPlayers)?  $default,) {final _that = this;
switch (_that) {
case _RoomSettings() when $default != null:
return $default(_that.category,_that.questionCount,_that.timePerQuestion,_that.maxPlayers);case _:
  return null;

}
}

}

/// @nodoc


class _RoomSettings extends RoomSettings {
  const _RoomSettings({required this.category, this.questionCount = RoomRules.defaultQuestionCount, this.timePerQuestion = RoomRules.defaultTimePerQuestion, this.maxPlayers = RoomRules.maxPlayers}): super._();
  

@override final  String category;
@override@JsonKey() final  int questionCount;
@override@JsonKey() final  int timePerQuestion;
@override@JsonKey() final  int maxPlayers;

/// Create a copy of RoomSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSettingsCopyWith<_RoomSettings> get copyWith => __$RoomSettingsCopyWithImpl<_RoomSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSettings&&(identical(other.category, category) || other.category == category)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.timePerQuestion, timePerQuestion) || other.timePerQuestion == timePerQuestion)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,questionCount,timePerQuestion,maxPlayers);
}

@override
String toString() {
    return 'RoomSettings(category: $category, questionCount: $questionCount, timePerQuestion: $timePerQuestion, maxPlayers: $maxPlayers)';
}


}

/// @nodoc
abstract mixin class _$RoomSettingsCopyWith<$Res> implements $RoomSettingsCopyWith<$Res> {
  factory _$RoomSettingsCopyWith(_RoomSettings value, $Res Function(_RoomSettings) _then) = __$RoomSettingsCopyWithImpl;
@override @useResult
$Res call({
 String category, int questionCount, int timePerQuestion, int maxPlayers
});




}
/// @nodoc
class __$RoomSettingsCopyWithImpl<$Res>
    implements _$RoomSettingsCopyWith<$Res> {
  __$RoomSettingsCopyWithImpl(this._self, this._then);

  final _RoomSettings _self;
  final $Res Function(_RoomSettings) _then;

/// Create a copy of RoomSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? questionCount = null,Object? timePerQuestion = null,Object? maxPlayers = null,}) {
  return _then(_RoomSettings(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestion: null == timePerQuestion ? _self.timePerQuestion : timePerQuestion // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RoomPlayer {

 String get uid; String get name; int get avatarSeed; int get joinedAt; bool get connected; int get score; int get streak; int get lastPoints;/// Hosts the game on a big screen: doesn't answer and isn't ranked.
 bool get spectator;
/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPlayerCopyWith<RoomPlayer> get copyWith => _$RoomPlayerCopyWithImpl<RoomPlayer>(this as RoomPlayer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoomPlayer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPlayer&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatarSeed, _this.avatarSeed) || other.avatarSeed == _this.avatarSeed)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.connected, _this.connected) || other.connected == _this.connected)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.streak, _this.streak) || other.streak == _this.streak)&&(identical(other.lastPoints, _this.lastPoints) || other.lastPoints == _this.lastPoints)&&(identical(other.spectator, _this.spectator) || other.spectator == _this.spectator));
}


@override
int get hashCode {
  final _this = this as RoomPlayer;
  return Object.hash(runtimeType,_this.uid,_this.name,_this.avatarSeed,_this.joinedAt,_this.connected,_this.score,_this.streak,_this.lastPoints,_this.spectator);
}

@override
String toString() {
  final _this = this as RoomPlayer;
  return 'RoomPlayer(uid: ${_this.uid}, name: ${_this.name}, avatarSeed: ${_this.avatarSeed}, joinedAt: ${_this.joinedAt}, connected: ${_this.connected}, score: ${_this.score}, streak: ${_this.streak}, lastPoints: ${_this.lastPoints}, spectator: ${_this.spectator})';
}


}

/// @nodoc
abstract mixin class $RoomPlayerCopyWith<$Res>  {
  factory $RoomPlayerCopyWith(RoomPlayer value, $Res Function(RoomPlayer) _then) = _$RoomPlayerCopyWithImpl;
@useResult
$Res call({
 String uid, String name, int avatarSeed, int joinedAt, bool connected, int score, int streak, int lastPoints, bool spectator
});




}
/// @nodoc
class _$RoomPlayerCopyWithImpl<$Res>
    implements $RoomPlayerCopyWith<$Res> {
  _$RoomPlayerCopyWithImpl(this._self, this._then);

  final RoomPlayer _self;
  final $Res Function(RoomPlayer) _then;

/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? avatarSeed = null,Object? joinedAt = null,Object? connected = null,Object? score = null,Object? streak = null,Object? lastPoints = null,Object? spectator = null,}) {
  return _then(RoomPlayer(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarSeed: null == avatarSeed ? _self.avatarSeed : avatarSeed // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as int,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastPoints: null == lastPoints ? _self.lastPoints : lastPoints // ignore: cast_nullable_to_non_nullable
as int,spectator: null == spectator ? _self.spectator : spectator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomPlayer].
extension RoomPlayerPatterns on RoomPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPlayer value)  $default,){
final _that = this;
switch (_that) {
case _RoomPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String name,  int avatarSeed,  int joinedAt,  bool connected,  int score,  int streak,  int lastPoints,  bool spectator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
return $default(_that.uid,_that.name,_that.avatarSeed,_that.joinedAt,_that.connected,_that.score,_that.streak,_that.lastPoints,_that.spectator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String name,  int avatarSeed,  int joinedAt,  bool connected,  int score,  int streak,  int lastPoints,  bool spectator)  $default,) {final _that = this;
switch (_that) {
case _RoomPlayer():
return $default(_that.uid,_that.name,_that.avatarSeed,_that.joinedAt,_that.connected,_that.score,_that.streak,_that.lastPoints,_that.spectator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String name,  int avatarSeed,  int joinedAt,  bool connected,  int score,  int streak,  int lastPoints,  bool spectator)?  $default,) {final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
return $default(_that.uid,_that.name,_that.avatarSeed,_that.joinedAt,_that.connected,_that.score,_that.streak,_that.lastPoints,_that.spectator);case _:
  return null;

}
}

}

/// @nodoc


class _RoomPlayer implements RoomPlayer {
  const _RoomPlayer({required this.uid, required this.name, required this.avatarSeed, required this.joinedAt, required this.connected, this.score = 0, this.streak = 0, this.lastPoints = 0, this.spectator = false});
  

@override final  String uid;
@override final  String name;
@override final  int avatarSeed;
@override final  int joinedAt;
@override final  bool connected;
@override@JsonKey() final  int score;
@override@JsonKey() final  int streak;
@override@JsonKey() final  int lastPoints;
/// Hosts the game on a big screen: doesn't answer and isn't ranked.
@override@JsonKey() final  bool spectator;

/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPlayerCopyWith<_RoomPlayer> get copyWith => __$RoomPlayerCopyWithImpl<_RoomPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPlayer&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarSeed, avatarSeed) || other.avatarSeed == avatarSeed)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.score, score) || other.score == score)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.lastPoints, lastPoints) || other.lastPoints == lastPoints)&&(identical(other.spectator, spectator) || other.spectator == spectator));
}


@override
int get hashCode {
    return Object.hash(runtimeType,uid,name,avatarSeed,joinedAt,connected,score,streak,lastPoints,spectator);
}

@override
String toString() {
    return 'RoomPlayer(uid: $uid, name: $name, avatarSeed: $avatarSeed, joinedAt: $joinedAt, connected: $connected, score: $score, streak: $streak, lastPoints: $lastPoints, spectator: $spectator)';
}


}

/// @nodoc
abstract mixin class _$RoomPlayerCopyWith<$Res> implements $RoomPlayerCopyWith<$Res> {
  factory _$RoomPlayerCopyWith(_RoomPlayer value, $Res Function(_RoomPlayer) _then) = __$RoomPlayerCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, int avatarSeed, int joinedAt, bool connected, int score, int streak, int lastPoints, bool spectator
});




}
/// @nodoc
class __$RoomPlayerCopyWithImpl<$Res>
    implements _$RoomPlayerCopyWith<$Res> {
  __$RoomPlayerCopyWithImpl(this._self, this._then);

  final _RoomPlayer _self;
  final $Res Function(_RoomPlayer) _then;

/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? avatarSeed = null,Object? joinedAt = null,Object? connected = null,Object? score = null,Object? streak = null,Object? lastPoints = null,Object? spectator = null,}) {
  return _then(_RoomPlayer(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarSeed: null == avatarSeed ? _self.avatarSeed : avatarSeed // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as int,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastPoints: null == lastPoints ? _self.lastPoints : lastPoints // ignore: cast_nullable_to_non_nullable
as int,spectator: null == spectator ? _self.spectator : spectator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PlayerAnswer {

 int get option; int get answeredAt;
/// Create a copy of PlayerAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerAnswerCopyWith<PlayerAnswer> get copyWith => _$PlayerAnswerCopyWithImpl<PlayerAnswer>(this as PlayerAnswer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlayerAnswer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAnswer&&(identical(other.option, _this.option) || other.option == _this.option)&&(identical(other.answeredAt, _this.answeredAt) || other.answeredAt == _this.answeredAt));
}


@override
int get hashCode {
  final _this = this as PlayerAnswer;
  return Object.hash(runtimeType,_this.option,_this.answeredAt);
}

@override
String toString() {
  final _this = this as PlayerAnswer;
  return 'PlayerAnswer(option: ${_this.option}, answeredAt: ${_this.answeredAt})';
}


}

/// @nodoc
abstract mixin class $PlayerAnswerCopyWith<$Res>  {
  factory $PlayerAnswerCopyWith(PlayerAnswer value, $Res Function(PlayerAnswer) _then) = _$PlayerAnswerCopyWithImpl;
@useResult
$Res call({
 int option, int answeredAt
});




}
/// @nodoc
class _$PlayerAnswerCopyWithImpl<$Res>
    implements $PlayerAnswerCopyWith<$Res> {
  _$PlayerAnswerCopyWithImpl(this._self, this._then);

  final PlayerAnswer _self;
  final $Res Function(PlayerAnswer) _then;

/// Create a copy of PlayerAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? option = null,Object? answeredAt = null,}) {
  return _then(PlayerAnswer(
option: null == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as int,answeredAt: null == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerAnswer].
extension PlayerAnswerPatterns on PlayerAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerAnswer value)  $default,){
final _that = this;
switch (_that) {
case _PlayerAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int option,  int answeredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerAnswer() when $default != null:
return $default(_that.option,_that.answeredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int option,  int answeredAt)  $default,) {final _that = this;
switch (_that) {
case _PlayerAnswer():
return $default(_that.option,_that.answeredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int option,  int answeredAt)?  $default,) {final _that = this;
switch (_that) {
case _PlayerAnswer() when $default != null:
return $default(_that.option,_that.answeredAt);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerAnswer implements PlayerAnswer {
  const _PlayerAnswer({required this.option, required this.answeredAt});
  

@override final  int option;
@override final  int answeredAt;

/// Create a copy of PlayerAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerAnswerCopyWith<_PlayerAnswer> get copyWith => __$PlayerAnswerCopyWithImpl<_PlayerAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAnswer&&(identical(other.option, option) || other.option == option)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,option,answeredAt);
}

@override
String toString() {
    return 'PlayerAnswer(option: $option, answeredAt: $answeredAt)';
}


}

/// @nodoc
abstract mixin class _$PlayerAnswerCopyWith<$Res> implements $PlayerAnswerCopyWith<$Res> {
  factory _$PlayerAnswerCopyWith(_PlayerAnswer value, $Res Function(_PlayerAnswer) _then) = __$PlayerAnswerCopyWithImpl;
@override @useResult
$Res call({
 int option, int answeredAt
});




}
/// @nodoc
class __$PlayerAnswerCopyWithImpl<$Res>
    implements _$PlayerAnswerCopyWith<$Res> {
  __$PlayerAnswerCopyWithImpl(this._self, this._then);

  final _PlayerAnswer _self;
  final $Res Function(_PlayerAnswer) _then;

/// Create a copy of PlayerAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? option = null,Object? answeredAt = null,}) {
  return _then(_PlayerAnswer(
option: null == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as int,answeredAt: null == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Room {

 String get code; String get hostId; RoomStatus get status; int get createdAt; RoomSettings get settings;/// Sorted by `joinedAt`, oldest first.
 List<RoomPlayer> get players; List<String> get questionIds; int get currentQuestionIndex; int? get questionStartedAt; int? get phaseStartedAt;/// The last question whose scores were written; guards against scoring twice.
 int? get scoredQuestionIndex;/// Every question id this room has played, so "Play again" avoids repeats.
 Set<String> get usedQuestionIds;/// Question index → player uid → answer.
 Map<int, Map<String, PlayerAnswer>> get answers;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Room;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.hostId, _this.hostId) || other.hostId == _this.hostId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&const DeepCollectionEquality().equals(other.players, _this.players)&&const DeepCollectionEquality().equals(other.questionIds, _this.questionIds)&&(identical(other.currentQuestionIndex, _this.currentQuestionIndex) || other.currentQuestionIndex == _this.currentQuestionIndex)&&(identical(other.questionStartedAt, _this.questionStartedAt) || other.questionStartedAt == _this.questionStartedAt)&&(identical(other.phaseStartedAt, _this.phaseStartedAt) || other.phaseStartedAt == _this.phaseStartedAt)&&(identical(other.scoredQuestionIndex, _this.scoredQuestionIndex) || other.scoredQuestionIndex == _this.scoredQuestionIndex)&&const DeepCollectionEquality().equals(other.usedQuestionIds, _this.usedQuestionIds)&&const DeepCollectionEquality().equals(other.answers, _this.answers));
}


@override
int get hashCode {
  final _this = this as Room;
  return Object.hash(runtimeType,_this.code,_this.hostId,_this.status,_this.createdAt,_this.settings,const DeepCollectionEquality().hash(_this.players),const DeepCollectionEquality().hash(_this.questionIds),_this.currentQuestionIndex,_this.questionStartedAt,_this.phaseStartedAt,_this.scoredQuestionIndex,const DeepCollectionEquality().hash(_this.usedQuestionIds),const DeepCollectionEquality().hash(_this.answers));
}

@override
String toString() {
  final _this = this as Room;
  return 'Room(code: ${_this.code}, hostId: ${_this.hostId}, status: ${_this.status}, createdAt: ${_this.createdAt}, settings: ${_this.settings}, players: ${_this.players}, questionIds: ${_this.questionIds}, currentQuestionIndex: ${_this.currentQuestionIndex}, questionStartedAt: ${_this.questionStartedAt}, phaseStartedAt: ${_this.phaseStartedAt}, scoredQuestionIndex: ${_this.scoredQuestionIndex}, usedQuestionIds: ${_this.usedQuestionIds}, answers: ${_this.answers})';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
 String code, String hostId, RoomStatus status, int createdAt, RoomSettings settings, List<RoomPlayer> players, List<String> questionIds, int currentQuestionIndex, int? questionStartedAt, int? phaseStartedAt, int? scoredQuestionIndex, Set<String> usedQuestionIds, Map<int, Map<String, PlayerAnswer>> answers
});


$RoomSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? hostId = null,Object? status = null,Object? createdAt = null,Object? settings = null,Object? players = null,Object? questionIds = null,Object? currentQuestionIndex = null,Object? questionStartedAt = freezed,Object? phaseStartedAt = freezed,Object? scoredQuestionIndex = freezed,Object? usedQuestionIds = null,Object? answers = null,}) {
  return _then(Room(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RoomSettings,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<RoomPlayer>,questionIds: null == questionIds ? _self.questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,questionStartedAt: freezed == questionStartedAt ? _self.questionStartedAt : questionStartedAt // ignore: cast_nullable_to_non_nullable
as int?,phaseStartedAt: freezed == phaseStartedAt ? _self.phaseStartedAt : phaseStartedAt // ignore: cast_nullable_to_non_nullable
as int?,scoredQuestionIndex: freezed == scoredQuestionIndex ? _self.scoredQuestionIndex : scoredQuestionIndex // ignore: cast_nullable_to_non_nullable
as int?,usedQuestionIds: null == usedQuestionIds ? _self.usedQuestionIds : usedQuestionIds // ignore: cast_nullable_to_non_nullable
as Set<String>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<int, Map<String, PlayerAnswer>>,
  ));
}
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSettingsCopyWith<$Res> get settings {
  
  return $RoomSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [Room].
extension RoomPatterns on Room {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Room value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Room value)  $default,){
final _that = this;
switch (_that) {
case _Room():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Room value)?  $default,){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String hostId,  RoomStatus status,  int createdAt,  RoomSettings settings,  List<RoomPlayer> players,  List<String> questionIds,  int currentQuestionIndex,  int? questionStartedAt,  int? phaseStartedAt,  int? scoredQuestionIndex,  Set<String> usedQuestionIds,  Map<int, Map<String, PlayerAnswer>> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.code,_that.hostId,_that.status,_that.createdAt,_that.settings,_that.players,_that.questionIds,_that.currentQuestionIndex,_that.questionStartedAt,_that.phaseStartedAt,_that.scoredQuestionIndex,_that.usedQuestionIds,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String hostId,  RoomStatus status,  int createdAt,  RoomSettings settings,  List<RoomPlayer> players,  List<String> questionIds,  int currentQuestionIndex,  int? questionStartedAt,  int? phaseStartedAt,  int? scoredQuestionIndex,  Set<String> usedQuestionIds,  Map<int, Map<String, PlayerAnswer>> answers)  $default,) {final _that = this;
switch (_that) {
case _Room():
return $default(_that.code,_that.hostId,_that.status,_that.createdAt,_that.settings,_that.players,_that.questionIds,_that.currentQuestionIndex,_that.questionStartedAt,_that.phaseStartedAt,_that.scoredQuestionIndex,_that.usedQuestionIds,_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String hostId,  RoomStatus status,  int createdAt,  RoomSettings settings,  List<RoomPlayer> players,  List<String> questionIds,  int currentQuestionIndex,  int? questionStartedAt,  int? phaseStartedAt,  int? scoredQuestionIndex,  Set<String> usedQuestionIds,  Map<int, Map<String, PlayerAnswer>> answers)?  $default,) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.code,_that.hostId,_that.status,_that.createdAt,_that.settings,_that.players,_that.questionIds,_that.currentQuestionIndex,_that.questionStartedAt,_that.phaseStartedAt,_that.scoredQuestionIndex,_that.usedQuestionIds,_that.answers);case _:
  return null;

}
}

}

/// @nodoc


class _Room extends Room {
  const _Room({required this.code, required this.hostId, required this.status, required this.createdAt, required this.settings, required  List<RoomPlayer> players,  List<String> questionIds = const <String>[], this.currentQuestionIndex = 0, this.questionStartedAt, this.phaseStartedAt, this.scoredQuestionIndex,  Set<String> usedQuestionIds = const <String>{},  Map<int, Map<String, PlayerAnswer>> answers = const <int, Map<String, PlayerAnswer>>{}}): _players = players,_questionIds = questionIds,_usedQuestionIds = usedQuestionIds,_answers = answers,super._();
  

@override final  String code;
@override final  String hostId;
@override final  RoomStatus status;
@override final  int createdAt;
@override final  RoomSettings settings;
/// Sorted by `joinedAt`, oldest first.
 final  List<RoomPlayer> _players;
/// Sorted by `joinedAt`, oldest first.
@override List<RoomPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

 final  List<String> _questionIds;
@override@JsonKey() List<String> get questionIds {
  if (_questionIds is EqualUnmodifiableListView) return _questionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questionIds);
}

@override@JsonKey() final  int currentQuestionIndex;
@override final  int? questionStartedAt;
@override final  int? phaseStartedAt;
/// The last question whose scores were written; guards against scoring twice.
@override final  int? scoredQuestionIndex;
/// Every question id this room has played, so "Play again" avoids repeats.
 final  Set<String> _usedQuestionIds;
/// Every question id this room has played, so "Play again" avoids repeats.
@override@JsonKey() Set<String> get usedQuestionIds {
  if (_usedQuestionIds is EqualUnmodifiableSetView) return _usedQuestionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_usedQuestionIds);
}

/// Question index → player uid → answer.
 final  Map<int, Map<String, PlayerAnswer>> _answers;
/// Question index → player uid → answer.
@override@JsonKey() Map<int, Map<String, PlayerAnswer>> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}


/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.code, code) || other.code == code)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.players, _players)&&const DeepCollectionEquality().equals(other.questionIds, _questionIds)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.questionStartedAt, questionStartedAt) || other.questionStartedAt == questionStartedAt)&&(identical(other.phaseStartedAt, phaseStartedAt) || other.phaseStartedAt == phaseStartedAt)&&(identical(other.scoredQuestionIndex, scoredQuestionIndex) || other.scoredQuestionIndex == scoredQuestionIndex)&&const DeepCollectionEquality().equals(other.usedQuestionIds, _usedQuestionIds)&&const DeepCollectionEquality().equals(other.answers, _answers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,hostId,status,createdAt,settings,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_questionIds),currentQuestionIndex,questionStartedAt,phaseStartedAt,scoredQuestionIndex,const DeepCollectionEquality().hash(_usedQuestionIds),const DeepCollectionEquality().hash(_answers));
}

@override
String toString() {
    return 'Room(code: $code, hostId: $hostId, status: $status, createdAt: $createdAt, settings: $settings, players: $players, questionIds: $questionIds, currentQuestionIndex: $currentQuestionIndex, questionStartedAt: $questionStartedAt, phaseStartedAt: $phaseStartedAt, scoredQuestionIndex: $scoredQuestionIndex, usedQuestionIds: $usedQuestionIds, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
 String code, String hostId, RoomStatus status, int createdAt, RoomSettings settings, List<RoomPlayer> players, List<String> questionIds, int currentQuestionIndex, int? questionStartedAt, int? phaseStartedAt, int? scoredQuestionIndex, Set<String> usedQuestionIds, Map<int, Map<String, PlayerAnswer>> answers
});


@override $RoomSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? hostId = null,Object? status = null,Object? createdAt = null,Object? settings = null,Object? players = null,Object? questionIds = null,Object? currentQuestionIndex = null,Object? questionStartedAt = freezed,Object? phaseStartedAt = freezed,Object? scoredQuestionIndex = freezed,Object? usedQuestionIds = null,Object? answers = null,}) {
  return _then(_Room(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RoomSettings,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<RoomPlayer>,questionIds: null == questionIds ? _self._questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,questionStartedAt: freezed == questionStartedAt ? _self.questionStartedAt : questionStartedAt // ignore: cast_nullable_to_non_nullable
as int?,phaseStartedAt: freezed == phaseStartedAt ? _self.phaseStartedAt : phaseStartedAt // ignore: cast_nullable_to_non_nullable
as int?,scoredQuestionIndex: freezed == scoredQuestionIndex ? _self.scoredQuestionIndex : scoredQuestionIndex // ignore: cast_nullable_to_non_nullable
as int?,usedQuestionIds: null == usedQuestionIds ? _self._usedQuestionIds : usedQuestionIds // ignore: cast_nullable_to_non_nullable
as Set<String>,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<int, Map<String, PlayerAnswer>>,
  ));
}

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSettingsCopyWith<$Res> get settings {
  
  return $RoomSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on

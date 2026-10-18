// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomSettingsModel {

 String get category; int get questionCount; int get timePerQuestion; int get maxPlayers;
/// Create a copy of RoomSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSettingsModelCopyWith<RoomSettingsModel> get copyWith => _$RoomSettingsModelCopyWithImpl<RoomSettingsModel>(this as RoomSettingsModel, _$identity);

  /// Serializes this RoomSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoomSettingsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSettingsModel&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount)&&(identical(other.timePerQuestion, _this.timePerQuestion) || other.timePerQuestion == _this.timePerQuestion)&&(identical(other.maxPlayers, _this.maxPlayers) || other.maxPlayers == _this.maxPlayers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoomSettingsModel;
  return Object.hash(runtimeType,_this.category,_this.questionCount,_this.timePerQuestion,_this.maxPlayers);
}

@override
String toString() {
  final _this = this as RoomSettingsModel;
  return 'RoomSettingsModel(category: ${_this.category}, questionCount: ${_this.questionCount}, timePerQuestion: ${_this.timePerQuestion}, maxPlayers: ${_this.maxPlayers})';
}


}

/// @nodoc
abstract mixin class $RoomSettingsModelCopyWith<$Res>  {
  factory $RoomSettingsModelCopyWith(RoomSettingsModel value, $Res Function(RoomSettingsModel) _then) = _$RoomSettingsModelCopyWithImpl;
@useResult
$Res call({
 String category, int questionCount, int timePerQuestion, int maxPlayers
});




}
/// @nodoc
class _$RoomSettingsModelCopyWithImpl<$Res>
    implements $RoomSettingsModelCopyWith<$Res> {
  _$RoomSettingsModelCopyWithImpl(this._self, this._then);

  final RoomSettingsModel _self;
  final $Res Function(RoomSettingsModel) _then;

/// Create a copy of RoomSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? questionCount = null,Object? timePerQuestion = null,Object? maxPlayers = null,}) {
  return _then(RoomSettingsModel(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestion: null == timePerQuestion ? _self.timePerQuestion : timePerQuestion // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomSettingsModel].
extension RoomSettingsModelPatterns on RoomSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSettingsModel() when $default != null:
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
case _RoomSettingsModel() when $default != null:
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
case _RoomSettingsModel():
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
case _RoomSettingsModel() when $default != null:
return $default(_that.category,_that.questionCount,_that.timePerQuestion,_that.maxPlayers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomSettingsModel extends RoomSettingsModel {
  const _RoomSettingsModel({required this.category, required this.questionCount, required this.timePerQuestion, required this.maxPlayers}): super._();
  factory _RoomSettingsModel.fromJson(Map<String, dynamic> json) => _$RoomSettingsModelFromJson(json);

@override final  String category;
@override final  int questionCount;
@override final  int timePerQuestion;
@override final  int maxPlayers;

/// Create a copy of RoomSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSettingsModelCopyWith<_RoomSettingsModel> get copyWith => __$RoomSettingsModelCopyWithImpl<_RoomSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSettingsModel&&(identical(other.category, category) || other.category == category)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.timePerQuestion, timePerQuestion) || other.timePerQuestion == timePerQuestion)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,questionCount,timePerQuestion,maxPlayers);
}

@override
String toString() {
    return 'RoomSettingsModel(category: $category, questionCount: $questionCount, timePerQuestion: $timePerQuestion, maxPlayers: $maxPlayers)';
}


}

/// @nodoc
abstract mixin class _$RoomSettingsModelCopyWith<$Res> implements $RoomSettingsModelCopyWith<$Res> {
  factory _$RoomSettingsModelCopyWith(_RoomSettingsModel value, $Res Function(_RoomSettingsModel) _then) = __$RoomSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String category, int questionCount, int timePerQuestion, int maxPlayers
});




}
/// @nodoc
class __$RoomSettingsModelCopyWithImpl<$Res>
    implements _$RoomSettingsModelCopyWith<$Res> {
  __$RoomSettingsModelCopyWithImpl(this._self, this._then);

  final _RoomSettingsModel _self;
  final $Res Function(_RoomSettingsModel) _then;

/// Create a copy of RoomSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? questionCount = null,Object? timePerQuestion = null,Object? maxPlayers = null,}) {
  return _then(_RoomSettingsModel(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestion: null == timePerQuestion ? _self.timePerQuestion : timePerQuestion // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PlayerModel {

 String get name; int get avatarSeed; int get joinedAt; bool get connected; int get score; int get streak; int get lastPoints;
/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerModelCopyWith<PlayerModel> get copyWith => _$PlayerModelCopyWithImpl<PlayerModel>(this as PlayerModel, _$identity);

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerModel&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatarSeed, _this.avatarSeed) || other.avatarSeed == _this.avatarSeed)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.connected, _this.connected) || other.connected == _this.connected)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.streak, _this.streak) || other.streak == _this.streak)&&(identical(other.lastPoints, _this.lastPoints) || other.lastPoints == _this.lastPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerModel;
  return Object.hash(runtimeType,_this.name,_this.avatarSeed,_this.joinedAt,_this.connected,_this.score,_this.streak,_this.lastPoints);
}

@override
String toString() {
  final _this = this as PlayerModel;
  return 'PlayerModel(name: ${_this.name}, avatarSeed: ${_this.avatarSeed}, joinedAt: ${_this.joinedAt}, connected: ${_this.connected}, score: ${_this.score}, streak: ${_this.streak}, lastPoints: ${_this.lastPoints})';
}


}

/// @nodoc
abstract mixin class $PlayerModelCopyWith<$Res>  {
  factory $PlayerModelCopyWith(PlayerModel value, $Res Function(PlayerModel) _then) = _$PlayerModelCopyWithImpl;
@useResult
$Res call({
 String name, int avatarSeed, int joinedAt, bool connected, int score, int streak, int lastPoints
});




}
/// @nodoc
class _$PlayerModelCopyWithImpl<$Res>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._self, this._then);

  final PlayerModel _self;
  final $Res Function(PlayerModel) _then;

/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatarSeed = null,Object? joinedAt = null,Object? connected = null,Object? score = null,Object? streak = null,Object? lastPoints = null,}) {
  return _then(PlayerModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarSeed: null == avatarSeed ? _self.avatarSeed : avatarSeed // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as int,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastPoints: null == lastPoints ? _self.lastPoints : lastPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerModel].
extension PlayerModelPatterns on PlayerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerModel value)  $default,){
final _that = this;
switch (_that) {
case _PlayerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int avatarSeed,  int joinedAt,  bool connected,  int score,  int streak,  int lastPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
return $default(_that.name,_that.avatarSeed,_that.joinedAt,_that.connected,_that.score,_that.streak,_that.lastPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int avatarSeed,  int joinedAt,  bool connected,  int score,  int streak,  int lastPoints)  $default,) {final _that = this;
switch (_that) {
case _PlayerModel():
return $default(_that.name,_that.avatarSeed,_that.joinedAt,_that.connected,_that.score,_that.streak,_that.lastPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int avatarSeed,  int joinedAt,  bool connected,  int score,  int streak,  int lastPoints)?  $default,) {final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
return $default(_that.name,_that.avatarSeed,_that.joinedAt,_that.connected,_that.score,_that.streak,_that.lastPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerModel extends PlayerModel {
  const _PlayerModel({required this.name, required this.avatarSeed, required this.joinedAt, this.connected = false, this.score = 0, this.streak = 0, this.lastPoints = 0}): super._();
  factory _PlayerModel.fromJson(Map<String, dynamic> json) => _$PlayerModelFromJson(json);

@override final  String name;
@override final  int avatarSeed;
@override final  int joinedAt;
@override@JsonKey() final  bool connected;
@override@JsonKey() final  int score;
@override@JsonKey() final  int streak;
@override@JsonKey() final  int lastPoints;

/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerModelCopyWith<_PlayerModel> get copyWith => __$PlayerModelCopyWithImpl<_PlayerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerModel&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarSeed, avatarSeed) || other.avatarSeed == avatarSeed)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.score, score) || other.score == score)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.lastPoints, lastPoints) || other.lastPoints == lastPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,avatarSeed,joinedAt,connected,score,streak,lastPoints);
}

@override
String toString() {
    return 'PlayerModel(name: $name, avatarSeed: $avatarSeed, joinedAt: $joinedAt, connected: $connected, score: $score, streak: $streak, lastPoints: $lastPoints)';
}


}

/// @nodoc
abstract mixin class _$PlayerModelCopyWith<$Res> implements $PlayerModelCopyWith<$Res> {
  factory _$PlayerModelCopyWith(_PlayerModel value, $Res Function(_PlayerModel) _then) = __$PlayerModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int avatarSeed, int joinedAt, bool connected, int score, int streak, int lastPoints
});




}
/// @nodoc
class __$PlayerModelCopyWithImpl<$Res>
    implements _$PlayerModelCopyWith<$Res> {
  __$PlayerModelCopyWithImpl(this._self, this._then);

  final _PlayerModel _self;
  final $Res Function(_PlayerModel) _then;

/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatarSeed = null,Object? joinedAt = null,Object? connected = null,Object? score = null,Object? streak = null,Object? lastPoints = null,}) {
  return _then(_PlayerModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarSeed: null == avatarSeed ? _self.avatarSeed : avatarSeed // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as int,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastPoints: null == lastPoints ? _self.lastPoints : lastPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RoomModel {

 String get hostId;@JsonKey(unknownEnumValue: RoomStatus.lobby) RoomStatus get status; int get createdAt; RoomSettingsModel get settings; Map<String, PlayerModel> get players; List<String> get questionIds; int get currentQuestionIndex; int? get questionStartedAt; int? get phaseStartedAt;
/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomModelCopyWith<RoomModel> get copyWith => _$RoomModelCopyWithImpl<RoomModel>(this as RoomModel, _$identity);

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoomModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomModel&&(identical(other.hostId, _this.hostId) || other.hostId == _this.hostId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&const DeepCollectionEquality().equals(other.players, _this.players)&&const DeepCollectionEquality().equals(other.questionIds, _this.questionIds)&&(identical(other.currentQuestionIndex, _this.currentQuestionIndex) || other.currentQuestionIndex == _this.currentQuestionIndex)&&(identical(other.questionStartedAt, _this.questionStartedAt) || other.questionStartedAt == _this.questionStartedAt)&&(identical(other.phaseStartedAt, _this.phaseStartedAt) || other.phaseStartedAt == _this.phaseStartedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoomModel;
  return Object.hash(runtimeType,_this.hostId,_this.status,_this.createdAt,_this.settings,const DeepCollectionEquality().hash(_this.players),const DeepCollectionEquality().hash(_this.questionIds),_this.currentQuestionIndex,_this.questionStartedAt,_this.phaseStartedAt);
}

@override
String toString() {
  final _this = this as RoomModel;
  return 'RoomModel(hostId: ${_this.hostId}, status: ${_this.status}, createdAt: ${_this.createdAt}, settings: ${_this.settings}, players: ${_this.players}, questionIds: ${_this.questionIds}, currentQuestionIndex: ${_this.currentQuestionIndex}, questionStartedAt: ${_this.questionStartedAt}, phaseStartedAt: ${_this.phaseStartedAt})';
}


}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res>  {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) = _$RoomModelCopyWithImpl;
@useResult
$Res call({
 String hostId,@JsonKey(unknownEnumValue: RoomStatus.lobby) RoomStatus status, int createdAt, RoomSettingsModel settings, Map<String, PlayerModel> players, List<String> questionIds, int currentQuestionIndex, int? questionStartedAt, int? phaseStartedAt
});


$RoomSettingsModelCopyWith<$Res> get settings;

}
/// @nodoc
class _$RoomModelCopyWithImpl<$Res>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._self, this._then);

  final RoomModel _self;
  final $Res Function(RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? status = null,Object? createdAt = null,Object? settings = null,Object? players = null,Object? questionIds = null,Object? currentQuestionIndex = null,Object? questionStartedAt = freezed,Object? phaseStartedAt = freezed,}) {
  return _then(RoomModel(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RoomSettingsModel,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as Map<String, PlayerModel>,questionIds: null == questionIds ? _self.questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,questionStartedAt: freezed == questionStartedAt ? _self.questionStartedAt : questionStartedAt // ignore: cast_nullable_to_non_nullable
as int?,phaseStartedAt: freezed == phaseStartedAt ? _self.phaseStartedAt : phaseStartedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSettingsModelCopyWith<$Res> get settings {
  
  return $RoomSettingsModelCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomModel].
extension RoomModelPatterns on RoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hostId, @JsonKey(unknownEnumValue: RoomStatus.lobby)  RoomStatus status,  int createdAt,  RoomSettingsModel settings,  Map<String, PlayerModel> players,  List<String> questionIds,  int currentQuestionIndex,  int? questionStartedAt,  int? phaseStartedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.hostId,_that.status,_that.createdAt,_that.settings,_that.players,_that.questionIds,_that.currentQuestionIndex,_that.questionStartedAt,_that.phaseStartedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hostId, @JsonKey(unknownEnumValue: RoomStatus.lobby)  RoomStatus status,  int createdAt,  RoomSettingsModel settings,  Map<String, PlayerModel> players,  List<String> questionIds,  int currentQuestionIndex,  int? questionStartedAt,  int? phaseStartedAt)  $default,) {final _that = this;
switch (_that) {
case _RoomModel():
return $default(_that.hostId,_that.status,_that.createdAt,_that.settings,_that.players,_that.questionIds,_that.currentQuestionIndex,_that.questionStartedAt,_that.phaseStartedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hostId, @JsonKey(unknownEnumValue: RoomStatus.lobby)  RoomStatus status,  int createdAt,  RoomSettingsModel settings,  Map<String, PlayerModel> players,  List<String> questionIds,  int currentQuestionIndex,  int? questionStartedAt,  int? phaseStartedAt)?  $default,) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.hostId,_that.status,_that.createdAt,_that.settings,_that.players,_that.questionIds,_that.currentQuestionIndex,_that.questionStartedAt,_that.phaseStartedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomModel extends RoomModel {
  const _RoomModel({required this.hostId, @JsonKey(unknownEnumValue: RoomStatus.lobby) required this.status, required this.createdAt, required this.settings,  Map<String, PlayerModel> players = const <String, PlayerModel>{},  List<String> questionIds = const <String>[], this.currentQuestionIndex = 0, this.questionStartedAt, this.phaseStartedAt}): _players = players,_questionIds = questionIds,super._();
  factory _RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

@override final  String hostId;
@override@JsonKey(unknownEnumValue: RoomStatus.lobby) final  RoomStatus status;
@override final  int createdAt;
@override final  RoomSettingsModel settings;
 final  Map<String, PlayerModel> _players;
@override@JsonKey() Map<String, PlayerModel> get players {
  if (_players is EqualUnmodifiableMapView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_players);
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

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomModelCopyWith<_RoomModel> get copyWith => __$RoomModelCopyWithImpl<_RoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomModel&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.players, _players)&&const DeepCollectionEquality().equals(other.questionIds, _questionIds)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.questionStartedAt, questionStartedAt) || other.questionStartedAt == questionStartedAt)&&(identical(other.phaseStartedAt, phaseStartedAt) || other.phaseStartedAt == phaseStartedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hostId,status,createdAt,settings,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_questionIds),currentQuestionIndex,questionStartedAt,phaseStartedAt);
}

@override
String toString() {
    return 'RoomModel(hostId: $hostId, status: $status, createdAt: $createdAt, settings: $settings, players: $players, questionIds: $questionIds, currentQuestionIndex: $currentQuestionIndex, questionStartedAt: $questionStartedAt, phaseStartedAt: $phaseStartedAt)';
}


}

/// @nodoc
abstract mixin class _$RoomModelCopyWith<$Res> implements $RoomModelCopyWith<$Res> {
  factory _$RoomModelCopyWith(_RoomModel value, $Res Function(_RoomModel) _then) = __$RoomModelCopyWithImpl;
@override @useResult
$Res call({
 String hostId,@JsonKey(unknownEnumValue: RoomStatus.lobby) RoomStatus status, int createdAt, RoomSettingsModel settings, Map<String, PlayerModel> players, List<String> questionIds, int currentQuestionIndex, int? questionStartedAt, int? phaseStartedAt
});


@override $RoomSettingsModelCopyWith<$Res> get settings;

}
/// @nodoc
class __$RoomModelCopyWithImpl<$Res>
    implements _$RoomModelCopyWith<$Res> {
  __$RoomModelCopyWithImpl(this._self, this._then);

  final _RoomModel _self;
  final $Res Function(_RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? status = null,Object? createdAt = null,Object? settings = null,Object? players = null,Object? questionIds = null,Object? currentQuestionIndex = null,Object? questionStartedAt = freezed,Object? phaseStartedAt = freezed,}) {
  return _then(_RoomModel(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RoomSettingsModel,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as Map<String, PlayerModel>,questionIds: null == questionIds ? _self._questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,questionStartedAt: freezed == questionStartedAt ? _self.questionStartedAt : questionStartedAt // ignore: cast_nullable_to_non_nullable
as int?,phaseStartedAt: freezed == phaseStartedAt ? _self.phaseStartedAt : phaseStartedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSettingsModelCopyWith<$Res> get settings {
  
  return $RoomSettingsModelCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on

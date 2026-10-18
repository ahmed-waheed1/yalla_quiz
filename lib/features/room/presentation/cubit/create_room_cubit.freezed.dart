// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_room_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateRoomState {

 List<String> get categories;/// Questions available per category; counts above this are disabled.
 Map<String, int> get available; bool get loadingCategories; String? get category; int get questionCount; int get timePerQuestion;/// "Host on big screen" (true) or "I'll play too" (false); null until
/// the host picks, so the page can default by screen size.
 bool? get spectator; bool get creating; Failure? get failure;/// Set once the room exists; the page navigates to its lobby.
 String? get createdCode;
/// Create a copy of CreateRoomState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRoomStateCopyWith<CreateRoomState> get copyWith => _$CreateRoomStateCopyWithImpl<CreateRoomState>(this as CreateRoomState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CreateRoomState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRoomState&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.available, _this.available)&&(identical(other.loadingCategories, _this.loadingCategories) || other.loadingCategories == _this.loadingCategories)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount)&&(identical(other.timePerQuestion, _this.timePerQuestion) || other.timePerQuestion == _this.timePerQuestion)&&(identical(other.spectator, _this.spectator) || other.spectator == _this.spectator)&&(identical(other.creating, _this.creating) || other.creating == _this.creating)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.createdCode, _this.createdCode) || other.createdCode == _this.createdCode));
}


@override
int get hashCode {
  final _this = this as CreateRoomState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.available),_this.loadingCategories,_this.category,_this.questionCount,_this.timePerQuestion,_this.spectator,_this.creating,_this.failure,_this.createdCode);
}

@override
String toString() {
  final _this = this as CreateRoomState;
  return 'CreateRoomState(categories: ${_this.categories}, available: ${_this.available}, loadingCategories: ${_this.loadingCategories}, category: ${_this.category}, questionCount: ${_this.questionCount}, timePerQuestion: ${_this.timePerQuestion}, spectator: ${_this.spectator}, creating: ${_this.creating}, failure: ${_this.failure}, createdCode: ${_this.createdCode})';
}


}

/// @nodoc
abstract mixin class $CreateRoomStateCopyWith<$Res>  {
  factory $CreateRoomStateCopyWith(CreateRoomState value, $Res Function(CreateRoomState) _then) = _$CreateRoomStateCopyWithImpl;
@useResult
$Res call({
 List<String> categories, Map<String, int> available, bool loadingCategories, String? category, int questionCount, int timePerQuestion, bool? spectator, bool creating, Failure? failure, String? createdCode
});




}
/// @nodoc
class _$CreateRoomStateCopyWithImpl<$Res>
    implements $CreateRoomStateCopyWith<$Res> {
  _$CreateRoomStateCopyWithImpl(this._self, this._then);

  final CreateRoomState _self;
  final $Res Function(CreateRoomState) _then;

/// Create a copy of CreateRoomState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? available = null,Object? loadingCategories = null,Object? category = freezed,Object? questionCount = null,Object? timePerQuestion = null,Object? spectator = freezed,Object? creating = null,Object? failure = freezed,Object? createdCode = freezed,}) {
  return _then(CreateRoomState(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as Map<String, int>,loadingCategories: null == loadingCategories ? _self.loadingCategories : loadingCategories // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestion: null == timePerQuestion ? _self.timePerQuestion : timePerQuestion // ignore: cast_nullable_to_non_nullable
as int,spectator: freezed == spectator ? _self.spectator : spectator // ignore: cast_nullable_to_non_nullable
as bool?,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,createdCode: freezed == createdCode ? _self.createdCode : createdCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRoomState].
extension CreateRoomStatePatterns on CreateRoomState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRoomState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRoomState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRoomState value)  $default,){
final _that = this;
switch (_that) {
case _CreateRoomState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRoomState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRoomState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> categories,  Map<String, int> available,  bool loadingCategories,  String? category,  int questionCount,  int timePerQuestion,  bool? spectator,  bool creating,  Failure? failure,  String? createdCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRoomState() when $default != null:
return $default(_that.categories,_that.available,_that.loadingCategories,_that.category,_that.questionCount,_that.timePerQuestion,_that.spectator,_that.creating,_that.failure,_that.createdCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> categories,  Map<String, int> available,  bool loadingCategories,  String? category,  int questionCount,  int timePerQuestion,  bool? spectator,  bool creating,  Failure? failure,  String? createdCode)  $default,) {final _that = this;
switch (_that) {
case _CreateRoomState():
return $default(_that.categories,_that.available,_that.loadingCategories,_that.category,_that.questionCount,_that.timePerQuestion,_that.spectator,_that.creating,_that.failure,_that.createdCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> categories,  Map<String, int> available,  bool loadingCategories,  String? category,  int questionCount,  int timePerQuestion,  bool? spectator,  bool creating,  Failure? failure,  String? createdCode)?  $default,) {final _that = this;
switch (_that) {
case _CreateRoomState() when $default != null:
return $default(_that.categories,_that.available,_that.loadingCategories,_that.category,_that.questionCount,_that.timePerQuestion,_that.spectator,_that.creating,_that.failure,_that.createdCode);case _:
  return null;

}
}

}

/// @nodoc


class _CreateRoomState extends CreateRoomState {
  const _CreateRoomState({ List<String> categories = const <String>[],  Map<String, int> available = const <String, int>{}, this.loadingCategories = true, this.category, this.questionCount = RoomRules.defaultQuestionCount, this.timePerQuestion = RoomRules.defaultTimePerQuestion, this.spectator, this.creating = false, this.failure, this.createdCode}): _categories = categories,_available = available,super._();
  

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Questions available per category; counts above this are disabled.
 final  Map<String, int> _available;
/// Questions available per category; counts above this are disabled.
@override@JsonKey() Map<String, int> get available {
  if (_available is EqualUnmodifiableMapView) return _available;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_available);
}

@override@JsonKey() final  bool loadingCategories;
@override final  String? category;
@override@JsonKey() final  int questionCount;
@override@JsonKey() final  int timePerQuestion;
/// "Host on big screen" (true) or "I'll play too" (false); null until
/// the host picks, so the page can default by screen size.
@override final  bool? spectator;
@override@JsonKey() final  bool creating;
@override final  Failure? failure;
/// Set once the room exists; the page navigates to its lobby.
@override final  String? createdCode;

/// Create a copy of CreateRoomState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoomStateCopyWith<_CreateRoomState> get copyWith => __$CreateRoomStateCopyWithImpl<_CreateRoomState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoomState&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.available, _available)&&(identical(other.loadingCategories, loadingCategories) || other.loadingCategories == loadingCategories)&&(identical(other.category, category) || other.category == category)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.timePerQuestion, timePerQuestion) || other.timePerQuestion == timePerQuestion)&&(identical(other.spectator, spectator) || other.spectator == spectator)&&(identical(other.creating, creating) || other.creating == creating)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.createdCode, createdCode) || other.createdCode == createdCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_available),loadingCategories,category,questionCount,timePerQuestion,spectator,creating,failure,createdCode);
}

@override
String toString() {
    return 'CreateRoomState(categories: $categories, available: $available, loadingCategories: $loadingCategories, category: $category, questionCount: $questionCount, timePerQuestion: $timePerQuestion, spectator: $spectator, creating: $creating, failure: $failure, createdCode: $createdCode)';
}


}

/// @nodoc
abstract mixin class _$CreateRoomStateCopyWith<$Res> implements $CreateRoomStateCopyWith<$Res> {
  factory _$CreateRoomStateCopyWith(_CreateRoomState value, $Res Function(_CreateRoomState) _then) = __$CreateRoomStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> categories, Map<String, int> available, bool loadingCategories, String? category, int questionCount, int timePerQuestion, bool? spectator, bool creating, Failure? failure, String? createdCode
});




}
/// @nodoc
class __$CreateRoomStateCopyWithImpl<$Res>
    implements _$CreateRoomStateCopyWith<$Res> {
  __$CreateRoomStateCopyWithImpl(this._self, this._then);

  final _CreateRoomState _self;
  final $Res Function(_CreateRoomState) _then;

/// Create a copy of CreateRoomState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? available = null,Object? loadingCategories = null,Object? category = freezed,Object? questionCount = null,Object? timePerQuestion = null,Object? spectator = freezed,Object? creating = null,Object? failure = freezed,Object? createdCode = freezed,}) {
  return _then(_CreateRoomState(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,available: null == available ? _self._available : available // ignore: cast_nullable_to_non_nullable
as Map<String, int>,loadingCategories: null == loadingCategories ? _self.loadingCategories : loadingCategories // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestion: null == timePerQuestion ? _self.timePerQuestion : timePerQuestion // ignore: cast_nullable_to_non_nullable
as int,spectator: freezed == spectator ? _self.spectator : spectator // ignore: cast_nullable_to_non_nullable
as bool?,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,createdCode: freezed == createdCode ? _self.createdCode : createdCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

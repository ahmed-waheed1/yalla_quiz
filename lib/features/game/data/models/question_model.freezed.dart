// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalizedQuestionModel {

 String get q; List<String> get options;
/// Create a copy of LocalizedQuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalizedQuestionModelCopyWith<LocalizedQuestionModel> get copyWith => _$LocalizedQuestionModelCopyWithImpl<LocalizedQuestionModel>(this as LocalizedQuestionModel, _$identity);

  /// Serializes this LocalizedQuestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocalizedQuestionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalizedQuestionModel&&(identical(other.q, _this.q) || other.q == _this.q)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocalizedQuestionModel;
  return Object.hash(runtimeType,_this.q,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as LocalizedQuestionModel;
  return 'LocalizedQuestionModel(q: ${_this.q}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $LocalizedQuestionModelCopyWith<$Res>  {
  factory $LocalizedQuestionModelCopyWith(LocalizedQuestionModel value, $Res Function(LocalizedQuestionModel) _then) = _$LocalizedQuestionModelCopyWithImpl;
@useResult
$Res call({
 String q, List<String> options
});




}
/// @nodoc
class _$LocalizedQuestionModelCopyWithImpl<$Res>
    implements $LocalizedQuestionModelCopyWith<$Res> {
  _$LocalizedQuestionModelCopyWithImpl(this._self, this._then);

  final LocalizedQuestionModel _self;
  final $Res Function(LocalizedQuestionModel) _then;

/// Create a copy of LocalizedQuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? q = null,Object? options = null,}) {
  return _then(LocalizedQuestionModel(
q: null == q ? _self.q : q // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalizedQuestionModel].
extension LocalizedQuestionModelPatterns on LocalizedQuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalizedQuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalizedQuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalizedQuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _LocalizedQuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalizedQuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _LocalizedQuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String q,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalizedQuestionModel() when $default != null:
return $default(_that.q,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String q,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _LocalizedQuestionModel():
return $default(_that.q,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String q,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _LocalizedQuestionModel() when $default != null:
return $default(_that.q,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalizedQuestionModel implements LocalizedQuestionModel {
  const _LocalizedQuestionModel({required this.q, required  List<String> options}): _options = options;
  factory _LocalizedQuestionModel.fromJson(Map<String, dynamic> json) => _$LocalizedQuestionModelFromJson(json);

@override final  String q;
 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of LocalizedQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalizedQuestionModelCopyWith<_LocalizedQuestionModel> get copyWith => __$LocalizedQuestionModelCopyWithImpl<_LocalizedQuestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalizedQuestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalizedQuestionModel&&(identical(other.q, q) || other.q == q)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,q,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'LocalizedQuestionModel(q: $q, options: $options)';
}


}

/// @nodoc
abstract mixin class _$LocalizedQuestionModelCopyWith<$Res> implements $LocalizedQuestionModelCopyWith<$Res> {
  factory _$LocalizedQuestionModelCopyWith(_LocalizedQuestionModel value, $Res Function(_LocalizedQuestionModel) _then) = __$LocalizedQuestionModelCopyWithImpl;
@override @useResult
$Res call({
 String q, List<String> options
});




}
/// @nodoc
class __$LocalizedQuestionModelCopyWithImpl<$Res>
    implements _$LocalizedQuestionModelCopyWith<$Res> {
  __$LocalizedQuestionModelCopyWithImpl(this._self, this._then);

  final _LocalizedQuestionModel _self;
  final $Res Function(_LocalizedQuestionModel) _then;

/// Create a copy of LocalizedQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? q = null,Object? options = null,}) {
  return _then(_LocalizedQuestionModel(
q: null == q ? _self.q : q // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$QuestionModel {

 String get id; LocalizedQuestionModel get en; LocalizedQuestionModel get ar; int get answer;
/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionModelCopyWith<QuestionModel> get copyWith => _$QuestionModelCopyWithImpl<QuestionModel>(this as QuestionModel, _$identity);

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.en, _this.en) || other.en == _this.en)&&(identical(other.ar, _this.ar) || other.ar == _this.ar)&&(identical(other.answer, _this.answer) || other.answer == _this.answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionModel;
  return Object.hash(runtimeType,_this.id,_this.en,_this.ar,_this.answer);
}

@override
String toString() {
  final _this = this as QuestionModel;
  return 'QuestionModel(id: ${_this.id}, en: ${_this.en}, ar: ${_this.ar}, answer: ${_this.answer})';
}


}

/// @nodoc
abstract mixin class $QuestionModelCopyWith<$Res>  {
  factory $QuestionModelCopyWith(QuestionModel value, $Res Function(QuestionModel) _then) = _$QuestionModelCopyWithImpl;
@useResult
$Res call({
 String id, LocalizedQuestionModel en, LocalizedQuestionModel ar, int answer
});


$LocalizedQuestionModelCopyWith<$Res> get en;$LocalizedQuestionModelCopyWith<$Res> get ar;

}
/// @nodoc
class _$QuestionModelCopyWithImpl<$Res>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._self, this._then);

  final QuestionModel _self;
  final $Res Function(QuestionModel) _then;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? en = null,Object? ar = null,Object? answer = null,}) {
  return _then(QuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as LocalizedQuestionModel,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as LocalizedQuestionModel,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionModelCopyWith<$Res> get en {
  
  return $LocalizedQuestionModelCopyWith<$Res>(_self.en, (value) {
    return _then(_self.copyWith(en: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionModelCopyWith<$Res> get ar {
  
  return $LocalizedQuestionModelCopyWith<$Res>(_self.ar, (value) {
    return _then(_self.copyWith(ar: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuestionModel].
extension QuestionModelPatterns on QuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _QuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LocalizedQuestionModel en,  LocalizedQuestionModel ar,  int answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
return $default(_that.id,_that.en,_that.ar,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LocalizedQuestionModel en,  LocalizedQuestionModel ar,  int answer)  $default,) {final _that = this;
switch (_that) {
case _QuestionModel():
return $default(_that.id,_that.en,_that.ar,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LocalizedQuestionModel en,  LocalizedQuestionModel ar,  int answer)?  $default,) {final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
return $default(_that.id,_that.en,_that.ar,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionModel extends QuestionModel {
  const _QuestionModel({required this.id, required this.en, required this.ar, required this.answer}): super._();
  factory _QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

@override final  String id;
@override final  LocalizedQuestionModel en;
@override final  LocalizedQuestionModel ar;
@override final  int answer;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionModelCopyWith<_QuestionModel> get copyWith => __$QuestionModelCopyWithImpl<_QuestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.en, en) || other.en == en)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,en,ar,answer);
}

@override
String toString() {
    return 'QuestionModel(id: $id, en: $en, ar: $ar, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$QuestionModelCopyWith<$Res> implements $QuestionModelCopyWith<$Res> {
  factory _$QuestionModelCopyWith(_QuestionModel value, $Res Function(_QuestionModel) _then) = __$QuestionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, LocalizedQuestionModel en, LocalizedQuestionModel ar, int answer
});


@override $LocalizedQuestionModelCopyWith<$Res> get en;@override $LocalizedQuestionModelCopyWith<$Res> get ar;

}
/// @nodoc
class __$QuestionModelCopyWithImpl<$Res>
    implements _$QuestionModelCopyWith<$Res> {
  __$QuestionModelCopyWithImpl(this._self, this._then);

  final _QuestionModel _self;
  final $Res Function(_QuestionModel) _then;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? en = null,Object? ar = null,Object? answer = null,}) {
  return _then(_QuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as LocalizedQuestionModel,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as LocalizedQuestionModel,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionModelCopyWith<$Res> get en {
  
  return $LocalizedQuestionModelCopyWith<$Res>(_self.en, (value) {
    return _then(_self.copyWith(en: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionModelCopyWith<$Res> get ar {
  
  return $LocalizedQuestionModelCopyWith<$Res>(_self.ar, (value) {
    return _then(_self.copyWith(ar: value));
  });
}
}

// dart format on

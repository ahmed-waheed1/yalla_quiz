// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalizedQuestion {

 String get text; List<String> get options;
/// Create a copy of LocalizedQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalizedQuestionCopyWith<LocalizedQuestion> get copyWith => _$LocalizedQuestionCopyWithImpl<LocalizedQuestion>(this as LocalizedQuestion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LocalizedQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalizedQuestion&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.options, _this.options));
}


@override
int get hashCode {
  final _this = this as LocalizedQuestion;
  return Object.hash(runtimeType,_this.text,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as LocalizedQuestion;
  return 'LocalizedQuestion(text: ${_this.text}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $LocalizedQuestionCopyWith<$Res>  {
  factory $LocalizedQuestionCopyWith(LocalizedQuestion value, $Res Function(LocalizedQuestion) _then) = _$LocalizedQuestionCopyWithImpl;
@useResult
$Res call({
 String text, List<String> options
});




}
/// @nodoc
class _$LocalizedQuestionCopyWithImpl<$Res>
    implements $LocalizedQuestionCopyWith<$Res> {
  _$LocalizedQuestionCopyWithImpl(this._self, this._then);

  final LocalizedQuestion _self;
  final $Res Function(LocalizedQuestion) _then;

/// Create a copy of LocalizedQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? options = null,}) {
  return _then(LocalizedQuestion(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalizedQuestion].
extension LocalizedQuestionPatterns on LocalizedQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalizedQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalizedQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalizedQuestion value)  $default,){
final _that = this;
switch (_that) {
case _LocalizedQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalizedQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _LocalizedQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalizedQuestion() when $default != null:
return $default(_that.text,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _LocalizedQuestion():
return $default(_that.text,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _LocalizedQuestion() when $default != null:
return $default(_that.text,_that.options);case _:
  return null;

}
}

}

/// @nodoc


class _LocalizedQuestion implements LocalizedQuestion {
  const _LocalizedQuestion({required this.text, required  List<String> options}): _options = options;
  

@override final  String text;
 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of LocalizedQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalizedQuestionCopyWith<_LocalizedQuestion> get copyWith => __$LocalizedQuestionCopyWithImpl<_LocalizedQuestion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalizedQuestion&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.options, _options));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'LocalizedQuestion(text: $text, options: $options)';
}


}

/// @nodoc
abstract mixin class _$LocalizedQuestionCopyWith<$Res> implements $LocalizedQuestionCopyWith<$Res> {
  factory _$LocalizedQuestionCopyWith(_LocalizedQuestion value, $Res Function(_LocalizedQuestion) _then) = __$LocalizedQuestionCopyWithImpl;
@override @useResult
$Res call({
 String text, List<String> options
});




}
/// @nodoc
class __$LocalizedQuestionCopyWithImpl<$Res>
    implements _$LocalizedQuestionCopyWith<$Res> {
  __$LocalizedQuestionCopyWithImpl(this._self, this._then);

  final _LocalizedQuestion _self;
  final $Res Function(_LocalizedQuestion) _then;

/// Create a copy of LocalizedQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? options = null,}) {
  return _then(_LocalizedQuestion(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$Question {

 String get id; String get category; LocalizedQuestion get en; LocalizedQuestion get ar; int get answer;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Question;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.en, _this.en) || other.en == _this.en)&&(identical(other.ar, _this.ar) || other.ar == _this.ar)&&(identical(other.answer, _this.answer) || other.answer == _this.answer));
}


@override
int get hashCode {
  final _this = this as Question;
  return Object.hash(runtimeType,_this.id,_this.category,_this.en,_this.ar,_this.answer);
}

@override
String toString() {
  final _this = this as Question;
  return 'Question(id: ${_this.id}, category: ${_this.category}, en: ${_this.en}, ar: ${_this.ar}, answer: ${_this.answer})';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String id, String category, LocalizedQuestion en, LocalizedQuestion ar, int answer
});


$LocalizedQuestionCopyWith<$Res> get en;$LocalizedQuestionCopyWith<$Res> get ar;

}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? en = null,Object? ar = null,Object? answer = null,}) {
  return _then(Question(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as LocalizedQuestion,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as LocalizedQuestion,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionCopyWith<$Res> get en {
  
  return $LocalizedQuestionCopyWith<$Res>(_self.en, (value) {
    return _then(_self.copyWith(en: value));
  });
}/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionCopyWith<$Res> get ar {
  
  return $LocalizedQuestionCopyWith<$Res>(_self.ar, (value) {
    return _then(_self.copyWith(ar: value));
  });
}
}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  LocalizedQuestion en,  LocalizedQuestion ar,  int answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.category,_that.en,_that.ar,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  LocalizedQuestion en,  LocalizedQuestion ar,  int answer)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.id,_that.category,_that.en,_that.ar,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  LocalizedQuestion en,  LocalizedQuestion ar,  int answer)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.category,_that.en,_that.ar,_that.answer);case _:
  return null;

}
}

}

/// @nodoc


class _Question extends Question {
  const _Question({required this.id, required this.category, required this.en, required this.ar, required this.answer}): super._();
  

@override final  String id;
@override final  String category;
@override final  LocalizedQuestion en;
@override final  LocalizedQuestion ar;
@override final  int answer;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.en, en) || other.en == en)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.answer, answer) || other.answer == answer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,category,en,ar,answer);
}

@override
String toString() {
    return 'Question(id: $id, category: $category, en: $en, ar: $ar, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, LocalizedQuestion en, LocalizedQuestion ar, int answer
});


@override $LocalizedQuestionCopyWith<$Res> get en;@override $LocalizedQuestionCopyWith<$Res> get ar;

}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? en = null,Object? ar = null,Object? answer = null,}) {
  return _then(_Question(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as LocalizedQuestion,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as LocalizedQuestion,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionCopyWith<$Res> get en {
  
  return $LocalizedQuestionCopyWith<$Res>(_self.en, (value) {
    return _then(_self.copyWith(en: value));
  });
}/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedQuestionCopyWith<$Res> get ar {
  
  return $LocalizedQuestionCopyWith<$Res>(_self.ar, (value) {
    return _then(_self.copyWith(ar: value));
  });
}
}

// dart format on

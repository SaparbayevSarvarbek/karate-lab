// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mjt_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MjtStep {

 int get id; String get title; String get description; String get repetitions; String get rest; String get goal; List<String> get images;
/// Create a copy of MjtStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MjtStepCopyWith<MjtStep> get copyWith => _$MjtStepCopyWithImpl<MjtStep>(this as MjtStep, _$identity);

  /// Serializes this MjtStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MjtStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,repetitions,rest,goal,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'MjtStep(id: $id, title: $title, description: $description, repetitions: $repetitions, rest: $rest, goal: $goal, images: $images)';
}


}

/// @nodoc
abstract mixin class $MjtStepCopyWith<$Res>  {
  factory $MjtStepCopyWith(MjtStep value, $Res Function(MjtStep) _then) = _$MjtStepCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, String repetitions, String rest, String goal, List<String> images
});




}
/// @nodoc
class _$MjtStepCopyWithImpl<$Res>
    implements $MjtStepCopyWith<$Res> {
  _$MjtStepCopyWithImpl(this._self, this._then);

  final MjtStep _self;
  final $Res Function(MjtStep) _then;

/// Create a copy of MjtStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? repetitions = null,Object? rest = null,Object? goal = null,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MjtStep].
extension MjtStepPatterns on MjtStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MjtStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MjtStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MjtStep value)  $default,){
final _that = this;
switch (_that) {
case _MjtStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MjtStep value)?  $default,){
final _that = this;
switch (_that) {
case _MjtStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  String repetitions,  String rest,  String goal,  List<String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MjtStep() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.rest,_that.goal,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  String repetitions,  String rest,  String goal,  List<String> images)  $default,) {final _that = this;
switch (_that) {
case _MjtStep():
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.rest,_that.goal,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  String repetitions,  String rest,  String goal,  List<String> images)?  $default,) {final _that = this;
switch (_that) {
case _MjtStep() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.rest,_that.goal,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MjtStep implements MjtStep {
  const _MjtStep({this.id = 0, this.title = '', this.description = '', this.repetitions = '', this.rest = '', this.goal = '', final  List<String> images = const <String>[]}): _images = images;
  factory _MjtStep.fromJson(Map<String, dynamic> json) => _$MjtStepFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String repetitions;
@override@JsonKey() final  String rest;
@override@JsonKey() final  String goal;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of MjtStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MjtStepCopyWith<_MjtStep> get copyWith => __$MjtStepCopyWithImpl<_MjtStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MjtStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MjtStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,repetitions,rest,goal,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'MjtStep(id: $id, title: $title, description: $description, repetitions: $repetitions, rest: $rest, goal: $goal, images: $images)';
}


}

/// @nodoc
abstract mixin class _$MjtStepCopyWith<$Res> implements $MjtStepCopyWith<$Res> {
  factory _$MjtStepCopyWith(_MjtStep value, $Res Function(_MjtStep) _then) = __$MjtStepCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, String repetitions, String rest, String goal, List<String> images
});




}
/// @nodoc
class __$MjtStepCopyWithImpl<$Res>
    implements _$MjtStepCopyWith<$Res> {
  __$MjtStepCopyWithImpl(this._self, this._then);

  final _MjtStep _self;
  final $Res Function(_MjtStep) _then;

/// Create a copy of MjtStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? repetitions = null,Object? rest = null,Object? goal = null,Object? images = null,}) {
  return _then(_MjtStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$MjtTest {

 int get id; String get title; String get goal; String get ageGroup; String? get coverUrl; List<String> get qualities; List<MjtStep> get steps; String? get createdAt;
/// Create a copy of MjtTest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MjtTestCopyWith<MjtTest> get copyWith => _$MjtTestCopyWithImpl<MjtTest>(this as MjtTest, _$identity);

  /// Serializes this MjtTest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MjtTest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.qualities, qualities)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,goal,ageGroup,coverUrl,const DeepCollectionEquality().hash(qualities),const DeepCollectionEquality().hash(steps),createdAt);

@override
String toString() {
  return 'MjtTest(id: $id, title: $title, goal: $goal, ageGroup: $ageGroup, coverUrl: $coverUrl, qualities: $qualities, steps: $steps, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MjtTestCopyWith<$Res>  {
  factory $MjtTestCopyWith(MjtTest value, $Res Function(MjtTest) _then) = _$MjtTestCopyWithImpl;
@useResult
$Res call({
 int id, String title, String goal, String ageGroup, String? coverUrl, List<String> qualities, List<MjtStep> steps, String? createdAt
});




}
/// @nodoc
class _$MjtTestCopyWithImpl<$Res>
    implements $MjtTestCopyWith<$Res> {
  _$MjtTestCopyWithImpl(this._self, this._then);

  final MjtTest _self;
  final $Res Function(MjtTest) _then;

/// Create a copy of MjtTest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? goal = null,Object? ageGroup = null,Object? coverUrl = freezed,Object? qualities = null,Object? steps = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,ageGroup: null == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,qualities: null == qualities ? _self.qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<MjtStep>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MjtTest].
extension MjtTestPatterns on MjtTest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MjtTest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MjtTest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MjtTest value)  $default,){
final _that = this;
switch (_that) {
case _MjtTest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MjtTest value)?  $default,){
final _that = this;
switch (_that) {
case _MjtTest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String goal,  String ageGroup,  String? coverUrl,  List<String> qualities,  List<MjtStep> steps,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MjtTest() when $default != null:
return $default(_that.id,_that.title,_that.goal,_that.ageGroup,_that.coverUrl,_that.qualities,_that.steps,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String goal,  String ageGroup,  String? coverUrl,  List<String> qualities,  List<MjtStep> steps,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MjtTest():
return $default(_that.id,_that.title,_that.goal,_that.ageGroup,_that.coverUrl,_that.qualities,_that.steps,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String goal,  String ageGroup,  String? coverUrl,  List<String> qualities,  List<MjtStep> steps,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MjtTest() when $default != null:
return $default(_that.id,_that.title,_that.goal,_that.ageGroup,_that.coverUrl,_that.qualities,_that.steps,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MjtTest extends MjtTest {
  const _MjtTest({this.id = 0, this.title = '', this.goal = '', this.ageGroup = '', this.coverUrl, final  List<String> qualities = const <String>[], final  List<MjtStep> steps = const <MjtStep>[], this.createdAt}): _qualities = qualities,_steps = steps,super._();
  factory _MjtTest.fromJson(Map<String, dynamic> json) => _$MjtTestFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String goal;
@override@JsonKey() final  String ageGroup;
@override final  String? coverUrl;
 final  List<String> _qualities;
@override@JsonKey() List<String> get qualities {
  if (_qualities is EqualUnmodifiableListView) return _qualities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_qualities);
}

 final  List<MjtStep> _steps;
@override@JsonKey() List<MjtStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  String? createdAt;

/// Create a copy of MjtTest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MjtTestCopyWith<_MjtTest> get copyWith => __$MjtTestCopyWithImpl<_MjtTest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MjtTestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MjtTest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._qualities, _qualities)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,goal,ageGroup,coverUrl,const DeepCollectionEquality().hash(_qualities),const DeepCollectionEquality().hash(_steps),createdAt);

@override
String toString() {
  return 'MjtTest(id: $id, title: $title, goal: $goal, ageGroup: $ageGroup, coverUrl: $coverUrl, qualities: $qualities, steps: $steps, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MjtTestCopyWith<$Res> implements $MjtTestCopyWith<$Res> {
  factory _$MjtTestCopyWith(_MjtTest value, $Res Function(_MjtTest) _then) = __$MjtTestCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String goal, String ageGroup, String? coverUrl, List<String> qualities, List<MjtStep> steps, String? createdAt
});




}
/// @nodoc
class __$MjtTestCopyWithImpl<$Res>
    implements _$MjtTestCopyWith<$Res> {
  __$MjtTestCopyWithImpl(this._self, this._then);

  final _MjtTest _self;
  final $Res Function(_MjtTest) _then;

/// Create a copy of MjtTest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? goal = null,Object? ageGroup = null,Object? coverUrl = freezed,Object? qualities = null,Object? steps = null,Object? createdAt = freezed,}) {
  return _then(_MjtTest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,ageGroup: null == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,qualities: null == qualities ? _self._qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<MjtStep>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

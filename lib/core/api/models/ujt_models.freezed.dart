// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ujt_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UjtStep {

 int get id; String get title; String get description; String get repetitions; String get rest; String get distance; List<String> get images;
/// Create a copy of UjtStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UjtStepCopyWith<UjtStep> get copyWith => _$UjtStepCopyWithImpl<UjtStep>(this as UjtStep, _$identity);

  /// Serializes this UjtStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UjtStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.distance, distance) || other.distance == distance)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,repetitions,rest,distance,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'UjtStep(id: $id, title: $title, description: $description, repetitions: $repetitions, rest: $rest, distance: $distance, images: $images)';
}


}

/// @nodoc
abstract mixin class $UjtStepCopyWith<$Res>  {
  factory $UjtStepCopyWith(UjtStep value, $Res Function(UjtStep) _then) = _$UjtStepCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, String repetitions, String rest, String distance, List<String> images
});




}
/// @nodoc
class _$UjtStepCopyWithImpl<$Res>
    implements $UjtStepCopyWith<$Res> {
  _$UjtStepCopyWithImpl(this._self, this._then);

  final UjtStep _self;
  final $Res Function(UjtStep) _then;

/// Create a copy of UjtStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? repetitions = null,Object? rest = null,Object? distance = null,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UjtStep].
extension UjtStepPatterns on UjtStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UjtStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UjtStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UjtStep value)  $default,){
final _that = this;
switch (_that) {
case _UjtStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UjtStep value)?  $default,){
final _that = this;
switch (_that) {
case _UjtStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  String repetitions,  String rest,  String distance,  List<String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UjtStep() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.rest,_that.distance,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  String repetitions,  String rest,  String distance,  List<String> images)  $default,) {final _that = this;
switch (_that) {
case _UjtStep():
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.rest,_that.distance,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  String repetitions,  String rest,  String distance,  List<String> images)?  $default,) {final _that = this;
switch (_that) {
case _UjtStep() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.rest,_that.distance,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UjtStep implements UjtStep {
  const _UjtStep({this.id = 0, this.title = '', this.description = '', this.repetitions = '', this.rest = '', this.distance = '', final  List<String> images = const <String>[]}): _images = images;
  factory _UjtStep.fromJson(Map<String, dynamic> json) => _$UjtStepFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String repetitions;
@override@JsonKey() final  String rest;
@override@JsonKey() final  String distance;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of UjtStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UjtStepCopyWith<_UjtStep> get copyWith => __$UjtStepCopyWithImpl<_UjtStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UjtStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UjtStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.distance, distance) || other.distance == distance)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,repetitions,rest,distance,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'UjtStep(id: $id, title: $title, description: $description, repetitions: $repetitions, rest: $rest, distance: $distance, images: $images)';
}


}

/// @nodoc
abstract mixin class _$UjtStepCopyWith<$Res> implements $UjtStepCopyWith<$Res> {
  factory _$UjtStepCopyWith(_UjtStep value, $Res Function(_UjtStep) _then) = __$UjtStepCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, String repetitions, String rest, String distance, List<String> images
});




}
/// @nodoc
class __$UjtStepCopyWithImpl<$Res>
    implements _$UjtStepCopyWith<$Res> {
  __$UjtStepCopyWithImpl(this._self, this._then);

  final _UjtStep _self;
  final $Res Function(_UjtStep) _then;

/// Create a copy of UjtStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? repetitions = null,Object? rest = null,Object? distance = null,Object? images = null,}) {
  return _then(_UjtStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$UjtTest {

 int get id; String get title; String get goal; String get ageGroup; String? get coverUrl; List<String> get qualities;@JsonKey(includeFromJson: false) List<UjtStep> get steps; String? get createdAt;
/// Create a copy of UjtTest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UjtTestCopyWith<UjtTest> get copyWith => _$UjtTestCopyWithImpl<UjtTest>(this as UjtTest, _$identity);

  /// Serializes this UjtTest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UjtTest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.qualities, qualities)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,goal,ageGroup,coverUrl,const DeepCollectionEquality().hash(qualities),const DeepCollectionEquality().hash(steps),createdAt);

@override
String toString() {
  return 'UjtTest(id: $id, title: $title, goal: $goal, ageGroup: $ageGroup, coverUrl: $coverUrl, qualities: $qualities, steps: $steps, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UjtTestCopyWith<$Res>  {
  factory $UjtTestCopyWith(UjtTest value, $Res Function(UjtTest) _then) = _$UjtTestCopyWithImpl;
@useResult
$Res call({
 int id, String title, String goal, String ageGroup, String? coverUrl, List<String> qualities,@JsonKey(includeFromJson: false) List<UjtStep> steps, String? createdAt
});




}
/// @nodoc
class _$UjtTestCopyWithImpl<$Res>
    implements $UjtTestCopyWith<$Res> {
  _$UjtTestCopyWithImpl(this._self, this._then);

  final UjtTest _self;
  final $Res Function(UjtTest) _then;

/// Create a copy of UjtTest
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
as List<UjtStep>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UjtTest].
extension UjtTestPatterns on UjtTest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UjtTest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UjtTest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UjtTest value)  $default,){
final _that = this;
switch (_that) {
case _UjtTest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UjtTest value)?  $default,){
final _that = this;
switch (_that) {
case _UjtTest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String goal,  String ageGroup,  String? coverUrl,  List<String> qualities, @JsonKey(includeFromJson: false)  List<UjtStep> steps,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UjtTest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String goal,  String ageGroup,  String? coverUrl,  List<String> qualities, @JsonKey(includeFromJson: false)  List<UjtStep> steps,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UjtTest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String goal,  String ageGroup,  String? coverUrl,  List<String> qualities, @JsonKey(includeFromJson: false)  List<UjtStep> steps,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UjtTest() when $default != null:
return $default(_that.id,_that.title,_that.goal,_that.ageGroup,_that.coverUrl,_that.qualities,_that.steps,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UjtTest extends UjtTest {
  const _UjtTest({this.id = 0, this.title = '', this.goal = '', this.ageGroup = '', this.coverUrl, final  List<String> qualities = const <String>[], @JsonKey(includeFromJson: false) final  List<UjtStep> steps = const <UjtStep>[], this.createdAt}): _qualities = qualities,_steps = steps,super._();
  factory _UjtTest.fromJson(Map<String, dynamic> json) => _$UjtTestFromJson(json);

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

 final  List<UjtStep> _steps;
@override@JsonKey(includeFromJson: false) List<UjtStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  String? createdAt;

/// Create a copy of UjtTest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UjtTestCopyWith<_UjtTest> get copyWith => __$UjtTestCopyWithImpl<_UjtTest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UjtTestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UjtTest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._qualities, _qualities)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,goal,ageGroup,coverUrl,const DeepCollectionEquality().hash(_qualities),const DeepCollectionEquality().hash(_steps),createdAt);

@override
String toString() {
  return 'UjtTest(id: $id, title: $title, goal: $goal, ageGroup: $ageGroup, coverUrl: $coverUrl, qualities: $qualities, steps: $steps, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UjtTestCopyWith<$Res> implements $UjtTestCopyWith<$Res> {
  factory _$UjtTestCopyWith(_UjtTest value, $Res Function(_UjtTest) _then) = __$UjtTestCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String goal, String ageGroup, String? coverUrl, List<String> qualities,@JsonKey(includeFromJson: false) List<UjtStep> steps, String? createdAt
});




}
/// @nodoc
class __$UjtTestCopyWithImpl<$Res>
    implements _$UjtTestCopyWith<$Res> {
  __$UjtTestCopyWithImpl(this._self, this._then);

  final _UjtTest _self;
  final $Res Function(_UjtTest) _then;

/// Create a copy of UjtTest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? goal = null,Object? ageGroup = null,Object? coverUrl = freezed,Object? qualities = null,Object? steps = null,Object? createdAt = freezed,}) {
  return _then(_UjtTest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,ageGroup: null == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,qualities: null == qualities ? _self._qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<UjtStep>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

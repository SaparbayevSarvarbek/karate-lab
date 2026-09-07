// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 int get id; String get title; int get duration; String get description; String get category;@JsonKey(includeToJson: false) String? get image;@JsonKey(includeToJson: false) String? get videoUrl;@JsonKey(includeToJson: false) String? get createdAt;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.image, image) || other.image == image)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,duration,description,category,image,videoUrl,createdAt);

@override
String toString() {
  return 'Exercise(id: $id, title: $title, duration: $duration, description: $description, category: $category, image: $image, videoUrl: $videoUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 int id, String title, int duration, String description, String category,@JsonKey(includeToJson: false) String? image,@JsonKey(includeToJson: false) String? videoUrl,@JsonKey(includeToJson: false) String? createdAt
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? duration = null,Object? description = null,Object? category = null,Object? image = freezed,Object? videoUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  int duration,  String description,  String category, @JsonKey(includeToJson: false)  String? image, @JsonKey(includeToJson: false)  String? videoUrl, @JsonKey(includeToJson: false)  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.title,_that.duration,_that.description,_that.category,_that.image,_that.videoUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  int duration,  String description,  String category, @JsonKey(includeToJson: false)  String? image, @JsonKey(includeToJson: false)  String? videoUrl, @JsonKey(includeToJson: false)  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.title,_that.duration,_that.description,_that.category,_that.image,_that.videoUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  int duration,  String description,  String category, @JsonKey(includeToJson: false)  String? image, @JsonKey(includeToJson: false)  String? videoUrl, @JsonKey(includeToJson: false)  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.title,_that.duration,_that.description,_that.category,_that.image,_that.videoUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise extends Exercise {
  const _Exercise({this.id = 0, this.title = '', this.duration = 0, this.description = '', this.category = '', @JsonKey(includeToJson: false) this.image, @JsonKey(includeToJson: false) this.videoUrl, @JsonKey(includeToJson: false) this.createdAt}): super._();
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String description;
@override@JsonKey() final  String category;
@override@JsonKey(includeToJson: false) final  String? image;
@override@JsonKey(includeToJson: false) final  String? videoUrl;
@override@JsonKey(includeToJson: false) final  String? createdAt;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.image, image) || other.image == image)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,duration,description,category,image,videoUrl,createdAt);

@override
String toString() {
  return 'Exercise(id: $id, title: $title, duration: $duration, description: $description, category: $category, image: $image, videoUrl: $videoUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, int duration, String description, String category,@JsonKey(includeToJson: false) String? image,@JsonKey(includeToJson: false) String? videoUrl,@JsonKey(includeToJson: false) String? createdAt
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? duration = null,Object? description = null,Object? category = null,Object? image = freezed,Object? videoUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateExerciseRequest {

 String get title; int get duration; String get description;
/// Create a copy of CreateExerciseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateExerciseRequestCopyWith<CreateExerciseRequest> get copyWith => _$CreateExerciseRequestCopyWithImpl<CreateExerciseRequest>(this as CreateExerciseRequest, _$identity);

  /// Serializes this CreateExerciseRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateExerciseRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,duration,description);

@override
String toString() {
  return 'CreateExerciseRequest(title: $title, duration: $duration, description: $description)';
}


}

/// @nodoc
abstract mixin class $CreateExerciseRequestCopyWith<$Res>  {
  factory $CreateExerciseRequestCopyWith(CreateExerciseRequest value, $Res Function(CreateExerciseRequest) _then) = _$CreateExerciseRequestCopyWithImpl;
@useResult
$Res call({
 String title, int duration, String description
});




}
/// @nodoc
class _$CreateExerciseRequestCopyWithImpl<$Res>
    implements $CreateExerciseRequestCopyWith<$Res> {
  _$CreateExerciseRequestCopyWithImpl(this._self, this._then);

  final CreateExerciseRequest _self;
  final $Res Function(CreateExerciseRequest) _then;

/// Create a copy of CreateExerciseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? duration = null,Object? description = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateExerciseRequest].
extension CreateExerciseRequestPatterns on CreateExerciseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateExerciseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateExerciseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateExerciseRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateExerciseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateExerciseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateExerciseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int duration,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateExerciseRequest() when $default != null:
return $default(_that.title,_that.duration,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int duration,  String description)  $default,) {final _that = this;
switch (_that) {
case _CreateExerciseRequest():
return $default(_that.title,_that.duration,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int duration,  String description)?  $default,) {final _that = this;
switch (_that) {
case _CreateExerciseRequest() when $default != null:
return $default(_that.title,_that.duration,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateExerciseRequest implements CreateExerciseRequest {
  const _CreateExerciseRequest({required this.title, required this.duration, this.description = ''});
  factory _CreateExerciseRequest.fromJson(Map<String, dynamic> json) => _$CreateExerciseRequestFromJson(json);

@override final  String title;
@override final  int duration;
@override@JsonKey() final  String description;

/// Create a copy of CreateExerciseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateExerciseRequestCopyWith<_CreateExerciseRequest> get copyWith => __$CreateExerciseRequestCopyWithImpl<_CreateExerciseRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateExerciseRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateExerciseRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,duration,description);

@override
String toString() {
  return 'CreateExerciseRequest(title: $title, duration: $duration, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateExerciseRequestCopyWith<$Res> implements $CreateExerciseRequestCopyWith<$Res> {
  factory _$CreateExerciseRequestCopyWith(_CreateExerciseRequest value, $Res Function(_CreateExerciseRequest) _then) = __$CreateExerciseRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, int duration, String description
});




}
/// @nodoc
class __$CreateExerciseRequestCopyWithImpl<$Res>
    implements _$CreateExerciseRequestCopyWith<$Res> {
  __$CreateExerciseRequestCopyWithImpl(this._self, this._then);

  final _CreateExerciseRequest _self;
  final $Res Function(_CreateExerciseRequest) _then;

/// Create a copy of CreateExerciseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? duration = null,Object? description = null,}) {
  return _then(_CreateExerciseRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestStep {

 int get id; String get title; String get description; String get repetitions; int get duration;@JsonKey(name: 'image') String? get imageUrl;
/// Create a copy of TestStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestStepCopyWith<TestStep> get copyWith => _$TestStepCopyWithImpl<TestStep>(this as TestStep, _$identity);

  /// Serializes this TestStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,repetitions,duration,imageUrl);

@override
String toString() {
  return 'TestStep(id: $id, title: $title, description: $description, repetitions: $repetitions, duration: $duration, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $TestStepCopyWith<$Res>  {
  factory $TestStepCopyWith(TestStep value, $Res Function(TestStep) _then) = _$TestStepCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, String repetitions, int duration,@JsonKey(name: 'image') String? imageUrl
});




}
/// @nodoc
class _$TestStepCopyWithImpl<$Res>
    implements $TestStepCopyWith<$Res> {
  _$TestStepCopyWithImpl(this._self, this._then);

  final TestStep _self;
  final $Res Function(TestStep) _then;

/// Create a copy of TestStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? repetitions = null,Object? duration = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TestStep].
extension TestStepPatterns on TestStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestStep value)  $default,){
final _that = this;
switch (_that) {
case _TestStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestStep value)?  $default,){
final _that = this;
switch (_that) {
case _TestStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  String repetitions,  int duration, @JsonKey(name: 'image')  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestStep() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.duration,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  String repetitions,  int duration, @JsonKey(name: 'image')  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _TestStep():
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.duration,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  String repetitions,  int duration, @JsonKey(name: 'image')  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _TestStep() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.repetitions,_that.duration,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestStep extends TestStep {
  const _TestStep({this.id = 0, this.title = '', this.description = '', this.repetitions = '', this.duration = 0, @JsonKey(name: 'image') this.imageUrl}): super._();
  factory _TestStep.fromJson(Map<String, dynamic> json) => _$TestStepFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String repetitions;
@override@JsonKey() final  int duration;
@override@JsonKey(name: 'image') final  String? imageUrl;

/// Create a copy of TestStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestStepCopyWith<_TestStep> get copyWith => __$TestStepCopyWithImpl<_TestStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestStep&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,repetitions,duration,imageUrl);

@override
String toString() {
  return 'TestStep(id: $id, title: $title, description: $description, repetitions: $repetitions, duration: $duration, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$TestStepCopyWith<$Res> implements $TestStepCopyWith<$Res> {
  factory _$TestStepCopyWith(_TestStep value, $Res Function(_TestStep) _then) = __$TestStepCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, String repetitions, int duration,@JsonKey(name: 'image') String? imageUrl
});




}
/// @nodoc
class __$TestStepCopyWithImpl<$Res>
    implements _$TestStepCopyWith<$Res> {
  __$TestStepCopyWithImpl(this._self, this._then);

  final _TestStep _self;
  final $Res Function(_TestStep) _then;

/// Create a copy of TestStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? repetitions = null,Object? duration = null,Object? imageUrl = freezed,}) {
  return _then(_TestStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TestEntity {

 int get id; String get name; String get description; String get category; String get age; String get goal; List<String> get qualities; String? get coverUrl; List<TestStep> get steps; DateTime? get createdAt; bool get isActive; int? get ownerId; String get ownerName;
/// Create a copy of TestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestEntityCopyWith<TestEntity> get copyWith => _$TestEntityCopyWithImpl<TestEntity>(this as TestEntity, _$identity);

  /// Serializes this TestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.age, age) || other.age == age)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.qualities, qualities)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,age,goal,const DeepCollectionEquality().hash(qualities),coverUrl,const DeepCollectionEquality().hash(steps),createdAt,isActive,ownerId,ownerName);

@override
String toString() {
  return 'TestEntity(id: $id, name: $name, description: $description, category: $category, age: $age, goal: $goal, qualities: $qualities, coverUrl: $coverUrl, steps: $steps, createdAt: $createdAt, isActive: $isActive, ownerId: $ownerId, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class $TestEntityCopyWith<$Res>  {
  factory $TestEntityCopyWith(TestEntity value, $Res Function(TestEntity) _then) = _$TestEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, String category, String age, String goal, List<String> qualities, String? coverUrl, List<TestStep> steps, DateTime? createdAt, bool isActive, int? ownerId, String ownerName
});




}
/// @nodoc
class _$TestEntityCopyWithImpl<$Res>
    implements $TestEntityCopyWith<$Res> {
  _$TestEntityCopyWithImpl(this._self, this._then);

  final TestEntity _self;
  final $Res Function(TestEntity) _then;

/// Create a copy of TestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? age = null,Object? goal = null,Object? qualities = null,Object? coverUrl = freezed,Object? steps = null,Object? createdAt = freezed,Object? isActive = null,Object? ownerId = freezed,Object? ownerName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,qualities: null == qualities ? _self.qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<TestStep>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int?,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TestEntity].
extension TestEntityPatterns on TestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestEntity value)  $default,){
final _that = this;
switch (_that) {
case _TestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String category,  String age,  String goal,  List<String> qualities,  String? coverUrl,  List<TestStep> steps,  DateTime? createdAt,  bool isActive,  int? ownerId,  String ownerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities,_that.coverUrl,_that.steps,_that.createdAt,_that.isActive,_that.ownerId,_that.ownerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String category,  String age,  String goal,  List<String> qualities,  String? coverUrl,  List<TestStep> steps,  DateTime? createdAt,  bool isActive,  int? ownerId,  String ownerName)  $default,) {final _that = this;
switch (_that) {
case _TestEntity():
return $default(_that.id,_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities,_that.coverUrl,_that.steps,_that.createdAt,_that.isActive,_that.ownerId,_that.ownerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  String category,  String age,  String goal,  List<String> qualities,  String? coverUrl,  List<TestStep> steps,  DateTime? createdAt,  bool isActive,  int? ownerId,  String ownerName)?  $default,) {final _that = this;
switch (_that) {
case _TestEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities,_that.coverUrl,_that.steps,_that.createdAt,_that.isActive,_that.ownerId,_that.ownerName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestEntity extends TestEntity {
  const _TestEntity({this.id = 0, this.name = '', this.description = '', this.category = '', this.age = '', this.goal = '', final  List<String> qualities = const <String>[], this.coverUrl, final  List<TestStep> steps = const <TestStep>[], this.createdAt, this.isActive = true, this.ownerId, this.ownerName = ''}): _qualities = qualities,_steps = steps,super._();
  factory _TestEntity.fromJson(Map<String, dynamic> json) => _$TestEntityFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String category;
@override@JsonKey() final  String age;
@override@JsonKey() final  String goal;
 final  List<String> _qualities;
@override@JsonKey() List<String> get qualities {
  if (_qualities is EqualUnmodifiableListView) return _qualities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_qualities);
}

@override final  String? coverUrl;
 final  List<TestStep> _steps;
@override@JsonKey() List<TestStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  DateTime? createdAt;
@override@JsonKey() final  bool isActive;
@override final  int? ownerId;
@override@JsonKey() final  String ownerName;

/// Create a copy of TestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestEntityCopyWith<_TestEntity> get copyWith => __$TestEntityCopyWithImpl<_TestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.age, age) || other.age == age)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other._qualities, _qualities)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,age,goal,const DeepCollectionEquality().hash(_qualities),coverUrl,const DeepCollectionEquality().hash(_steps),createdAt,isActive,ownerId,ownerName);

@override
String toString() {
  return 'TestEntity(id: $id, name: $name, description: $description, category: $category, age: $age, goal: $goal, qualities: $qualities, coverUrl: $coverUrl, steps: $steps, createdAt: $createdAt, isActive: $isActive, ownerId: $ownerId, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class _$TestEntityCopyWith<$Res> implements $TestEntityCopyWith<$Res> {
  factory _$TestEntityCopyWith(_TestEntity value, $Res Function(_TestEntity) _then) = __$TestEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, String category, String age, String goal, List<String> qualities, String? coverUrl, List<TestStep> steps, DateTime? createdAt, bool isActive, int? ownerId, String ownerName
});




}
/// @nodoc
class __$TestEntityCopyWithImpl<$Res>
    implements _$TestEntityCopyWith<$Res> {
  __$TestEntityCopyWithImpl(this._self, this._then);

  final _TestEntity _self;
  final $Res Function(_TestEntity) _then;

/// Create a copy of TestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? age = null,Object? goal = null,Object? qualities = null,Object? coverUrl = freezed,Object? steps = null,Object? createdAt = freezed,Object? isActive = null,Object? ownerId = freezed,Object? ownerName = null,}) {
  return _then(_TestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,qualities: null == qualities ? _self._qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<TestStep>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int?,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TestResult {

 int get id; int get testId; String get name; String get description; String get category; String get age; String get goal; List<String> get qualities; String? get coverUrl; List<TestStep> get steps;@JsonKey(unknownEnumValue: TestStatus.unknown) TestStatus get status; double? get score; String get notes; TestEvaluation? get result; DateTime? get startedAt; DateTime? get finishedAt; int? get athleteId;
/// Create a copy of TestResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestResultCopyWith<TestResult> get copyWith => _$TestResultCopyWithImpl<TestResult>(this as TestResult, _$identity);

  /// Serializes this TestResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestResult&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.age, age) || other.age == age)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.qualities, qualities)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.status, status) || other.status == status)&&(identical(other.score, score) || other.score == score)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.result, result) || other.result == result)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.athleteId, athleteId) || other.athleteId == athleteId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testId,name,description,category,age,goal,const DeepCollectionEquality().hash(qualities),coverUrl,const DeepCollectionEquality().hash(steps),status,score,notes,result,startedAt,finishedAt,athleteId);

@override
String toString() {
  return 'TestResult(id: $id, testId: $testId, name: $name, description: $description, category: $category, age: $age, goal: $goal, qualities: $qualities, coverUrl: $coverUrl, steps: $steps, status: $status, score: $score, notes: $notes, result: $result, startedAt: $startedAt, finishedAt: $finishedAt, athleteId: $athleteId)';
}


}

/// @nodoc
abstract mixin class $TestResultCopyWith<$Res>  {
  factory $TestResultCopyWith(TestResult value, $Res Function(TestResult) _then) = _$TestResultCopyWithImpl;
@useResult
$Res call({
 int id, int testId, String name, String description, String category, String age, String goal, List<String> qualities, String? coverUrl, List<TestStep> steps,@JsonKey(unknownEnumValue: TestStatus.unknown) TestStatus status, double? score, String notes, TestEvaluation? result, DateTime? startedAt, DateTime? finishedAt, int? athleteId
});


$TestEvaluationCopyWith<$Res>? get result;

}
/// @nodoc
class _$TestResultCopyWithImpl<$Res>
    implements $TestResultCopyWith<$Res> {
  _$TestResultCopyWithImpl(this._self, this._then);

  final TestResult _self;
  final $Res Function(TestResult) _then;

/// Create a copy of TestResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? testId = null,Object? name = null,Object? description = null,Object? category = null,Object? age = null,Object? goal = null,Object? qualities = null,Object? coverUrl = freezed,Object? steps = null,Object? status = null,Object? score = freezed,Object? notes = null,Object? result = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,Object? athleteId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,qualities: null == qualities ? _self.qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<TestStep>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestStatus,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as TestEvaluation?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,athleteId: freezed == athleteId ? _self.athleteId : athleteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of TestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestEvaluationCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $TestEvaluationCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [TestResult].
extension TestResultPatterns on TestResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestResult value)  $default,){
final _that = this;
switch (_that) {
case _TestResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestResult value)?  $default,){
final _that = this;
switch (_that) {
case _TestResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int testId,  String name,  String description,  String category,  String age,  String goal,  List<String> qualities,  String? coverUrl,  List<TestStep> steps, @JsonKey(unknownEnumValue: TestStatus.unknown)  TestStatus status,  double? score,  String notes,  TestEvaluation? result,  DateTime? startedAt,  DateTime? finishedAt,  int? athleteId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestResult() when $default != null:
return $default(_that.id,_that.testId,_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities,_that.coverUrl,_that.steps,_that.status,_that.score,_that.notes,_that.result,_that.startedAt,_that.finishedAt,_that.athleteId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int testId,  String name,  String description,  String category,  String age,  String goal,  List<String> qualities,  String? coverUrl,  List<TestStep> steps, @JsonKey(unknownEnumValue: TestStatus.unknown)  TestStatus status,  double? score,  String notes,  TestEvaluation? result,  DateTime? startedAt,  DateTime? finishedAt,  int? athleteId)  $default,) {final _that = this;
switch (_that) {
case _TestResult():
return $default(_that.id,_that.testId,_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities,_that.coverUrl,_that.steps,_that.status,_that.score,_that.notes,_that.result,_that.startedAt,_that.finishedAt,_that.athleteId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int testId,  String name,  String description,  String category,  String age,  String goal,  List<String> qualities,  String? coverUrl,  List<TestStep> steps, @JsonKey(unknownEnumValue: TestStatus.unknown)  TestStatus status,  double? score,  String notes,  TestEvaluation? result,  DateTime? startedAt,  DateTime? finishedAt,  int? athleteId)?  $default,) {final _that = this;
switch (_that) {
case _TestResult() when $default != null:
return $default(_that.id,_that.testId,_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities,_that.coverUrl,_that.steps,_that.status,_that.score,_that.notes,_that.result,_that.startedAt,_that.finishedAt,_that.athleteId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestResult extends TestResult {
  const _TestResult({this.id = 0, this.testId = 0, this.name = '', this.description = '', this.category = '', this.age = '', this.goal = '', final  List<String> qualities = const <String>[], this.coverUrl, final  List<TestStep> steps = const <TestStep>[], @JsonKey(unknownEnumValue: TestStatus.unknown) this.status = TestStatus.unknown, this.score, this.notes = '', this.result, this.startedAt, this.finishedAt, this.athleteId}): _qualities = qualities,_steps = steps,super._();
  factory _TestResult.fromJson(Map<String, dynamic> json) => _$TestResultFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  int testId;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String category;
@override@JsonKey() final  String age;
@override@JsonKey() final  String goal;
 final  List<String> _qualities;
@override@JsonKey() List<String> get qualities {
  if (_qualities is EqualUnmodifiableListView) return _qualities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_qualities);
}

@override final  String? coverUrl;
 final  List<TestStep> _steps;
@override@JsonKey() List<TestStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override@JsonKey(unknownEnumValue: TestStatus.unknown) final  TestStatus status;
@override final  double? score;
@override@JsonKey() final  String notes;
@override final  TestEvaluation? result;
@override final  DateTime? startedAt;
@override final  DateTime? finishedAt;
@override final  int? athleteId;

/// Create a copy of TestResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestResultCopyWith<_TestResult> get copyWith => __$TestResultCopyWithImpl<_TestResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestResult&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.age, age) || other.age == age)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other._qualities, _qualities)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.status, status) || other.status == status)&&(identical(other.score, score) || other.score == score)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.result, result) || other.result == result)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.athleteId, athleteId) || other.athleteId == athleteId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testId,name,description,category,age,goal,const DeepCollectionEquality().hash(_qualities),coverUrl,const DeepCollectionEquality().hash(_steps),status,score,notes,result,startedAt,finishedAt,athleteId);

@override
String toString() {
  return 'TestResult(id: $id, testId: $testId, name: $name, description: $description, category: $category, age: $age, goal: $goal, qualities: $qualities, coverUrl: $coverUrl, steps: $steps, status: $status, score: $score, notes: $notes, result: $result, startedAt: $startedAt, finishedAt: $finishedAt, athleteId: $athleteId)';
}


}

/// @nodoc
abstract mixin class _$TestResultCopyWith<$Res> implements $TestResultCopyWith<$Res> {
  factory _$TestResultCopyWith(_TestResult value, $Res Function(_TestResult) _then) = __$TestResultCopyWithImpl;
@override @useResult
$Res call({
 int id, int testId, String name, String description, String category, String age, String goal, List<String> qualities, String? coverUrl, List<TestStep> steps,@JsonKey(unknownEnumValue: TestStatus.unknown) TestStatus status, double? score, String notes, TestEvaluation? result, DateTime? startedAt, DateTime? finishedAt, int? athleteId
});


@override $TestEvaluationCopyWith<$Res>? get result;

}
/// @nodoc
class __$TestResultCopyWithImpl<$Res>
    implements _$TestResultCopyWith<$Res> {
  __$TestResultCopyWithImpl(this._self, this._then);

  final _TestResult _self;
  final $Res Function(_TestResult) _then;

/// Create a copy of TestResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? testId = null,Object? name = null,Object? description = null,Object? category = null,Object? age = null,Object? goal = null,Object? qualities = null,Object? coverUrl = freezed,Object? steps = null,Object? status = null,Object? score = freezed,Object? notes = null,Object? result = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,Object? athleteId = freezed,}) {
  return _then(_TestResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,qualities: null == qualities ? _self._qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<TestStep>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestStatus,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as TestEvaluation?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,athleteId: freezed == athleteId ? _self.athleteId : athleteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of TestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestEvaluationCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $TestEvaluationCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// @nodoc
mixin _$TestEvaluation {

 double get score; String get rating; String get color; int? get age; List<StepResult> get steps;
/// Create a copy of TestEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestEvaluationCopyWith<TestEvaluation> get copyWith => _$TestEvaluationCopyWithImpl<TestEvaluation>(this as TestEvaluation, _$identity);

  /// Serializes this TestEvaluation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestEvaluation&&(identical(other.score, score) || other.score == score)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.color, color) || other.color == color)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,rating,color,age,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'TestEvaluation(score: $score, rating: $rating, color: $color, age: $age, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $TestEvaluationCopyWith<$Res>  {
  factory $TestEvaluationCopyWith(TestEvaluation value, $Res Function(TestEvaluation) _then) = _$TestEvaluationCopyWithImpl;
@useResult
$Res call({
 double score, String rating, String color, int? age, List<StepResult> steps
});




}
/// @nodoc
class _$TestEvaluationCopyWithImpl<$Res>
    implements $TestEvaluationCopyWith<$Res> {
  _$TestEvaluationCopyWithImpl(this._self, this._then);

  final TestEvaluation _self;
  final $Res Function(TestEvaluation) _then;

/// Create a copy of TestEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? rating = null,Object? color = null,Object? age = freezed,Object? steps = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<StepResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [TestEvaluation].
extension TestEvaluationPatterns on TestEvaluation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestEvaluation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _TestEvaluation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _TestEvaluation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double score,  String rating,  String color,  int? age,  List<StepResult> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestEvaluation() when $default != null:
return $default(_that.score,_that.rating,_that.color,_that.age,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double score,  String rating,  String color,  int? age,  List<StepResult> steps)  $default,) {final _that = this;
switch (_that) {
case _TestEvaluation():
return $default(_that.score,_that.rating,_that.color,_that.age,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double score,  String rating,  String color,  int? age,  List<StepResult> steps)?  $default,) {final _that = this;
switch (_that) {
case _TestEvaluation() when $default != null:
return $default(_that.score,_that.rating,_that.color,_that.age,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestEvaluation implements TestEvaluation {
  const _TestEvaluation({this.score = 0, this.rating = '', this.color = 'grey', this.age, final  List<StepResult> steps = const <StepResult>[]}): _steps = steps;
  factory _TestEvaluation.fromJson(Map<String, dynamic> json) => _$TestEvaluationFromJson(json);

@override@JsonKey() final  double score;
@override@JsonKey() final  String rating;
@override@JsonKey() final  String color;
@override final  int? age;
 final  List<StepResult> _steps;
@override@JsonKey() List<StepResult> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of TestEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestEvaluationCopyWith<_TestEvaluation> get copyWith => __$TestEvaluationCopyWithImpl<_TestEvaluation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestEvaluationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestEvaluation&&(identical(other.score, score) || other.score == score)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.color, color) || other.color == color)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,rating,color,age,const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'TestEvaluation(score: $score, rating: $rating, color: $color, age: $age, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$TestEvaluationCopyWith<$Res> implements $TestEvaluationCopyWith<$Res> {
  factory _$TestEvaluationCopyWith(_TestEvaluation value, $Res Function(_TestEvaluation) _then) = __$TestEvaluationCopyWithImpl;
@override @useResult
$Res call({
 double score, String rating, String color, int? age, List<StepResult> steps
});




}
/// @nodoc
class __$TestEvaluationCopyWithImpl<$Res>
    implements _$TestEvaluationCopyWith<$Res> {
  __$TestEvaluationCopyWithImpl(this._self, this._then);

  final _TestEvaluation _self;
  final $Res Function(_TestEvaluation) _then;

/// Create a copy of TestEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? rating = null,Object? color = null,Object? age = freezed,Object? steps = null,}) {
  return _then(_TestEvaluation(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<StepResult>,
  ));
}


}


/// @nodoc
mixin _$StepResult {

 int get stepId; int get order; String get title; double get seconds; int get reps; String get target; double get percent; String get rating; String get color;
/// Create a copy of StepResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepResultCopyWith<StepResult> get copyWith => _$StepResultCopyWithImpl<StepResult>(this as StepResult, _$identity);

  /// Serializes this StepResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepResult&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.target, target) || other.target == target)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,order,title,seconds,reps,target,percent,rating,color);

@override
String toString() {
  return 'StepResult(stepId: $stepId, order: $order, title: $title, seconds: $seconds, reps: $reps, target: $target, percent: $percent, rating: $rating, color: $color)';
}


}

/// @nodoc
abstract mixin class $StepResultCopyWith<$Res>  {
  factory $StepResultCopyWith(StepResult value, $Res Function(StepResult) _then) = _$StepResultCopyWithImpl;
@useResult
$Res call({
 int stepId, int order, String title, double seconds, int reps, String target, double percent, String rating, String color
});




}
/// @nodoc
class _$StepResultCopyWithImpl<$Res>
    implements $StepResultCopyWith<$Res> {
  _$StepResultCopyWithImpl(this._self, this._then);

  final StepResult _self;
  final $Res Function(StepResult) _then;

/// Create a copy of StepResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepId = null,Object? order = null,Object? title = null,Object? seconds = null,Object? reps = null,Object? target = null,Object? percent = null,Object? rating = null,Object? color = null,}) {
  return _then(_self.copyWith(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StepResult].
extension StepResultPatterns on StepResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepResult value)  $default,){
final _that = this;
switch (_that) {
case _StepResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepResult value)?  $default,){
final _that = this;
switch (_that) {
case _StepResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepId,  int order,  String title,  double seconds,  int reps,  String target,  double percent,  String rating,  String color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepResult() when $default != null:
return $default(_that.stepId,_that.order,_that.title,_that.seconds,_that.reps,_that.target,_that.percent,_that.rating,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepId,  int order,  String title,  double seconds,  int reps,  String target,  double percent,  String rating,  String color)  $default,) {final _that = this;
switch (_that) {
case _StepResult():
return $default(_that.stepId,_that.order,_that.title,_that.seconds,_that.reps,_that.target,_that.percent,_that.rating,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepId,  int order,  String title,  double seconds,  int reps,  String target,  double percent,  String rating,  String color)?  $default,) {final _that = this;
switch (_that) {
case _StepResult() when $default != null:
return $default(_that.stepId,_that.order,_that.title,_that.seconds,_that.reps,_that.target,_that.percent,_that.rating,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepResult implements StepResult {
  const _StepResult({this.stepId = 0, this.order = 0, this.title = '', this.seconds = 0, this.reps = 0, this.target = '', this.percent = 0, this.rating = '', this.color = 'grey'});
  factory _StepResult.fromJson(Map<String, dynamic> json) => _$StepResultFromJson(json);

@override@JsonKey() final  int stepId;
@override@JsonKey() final  int order;
@override@JsonKey() final  String title;
@override@JsonKey() final  double seconds;
@override@JsonKey() final  int reps;
@override@JsonKey() final  String target;
@override@JsonKey() final  double percent;
@override@JsonKey() final  String rating;
@override@JsonKey() final  String color;

/// Create a copy of StepResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepResultCopyWith<_StepResult> get copyWith => __$StepResultCopyWithImpl<_StepResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepResult&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.target, target) || other.target == target)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,order,title,seconds,reps,target,percent,rating,color);

@override
String toString() {
  return 'StepResult(stepId: $stepId, order: $order, title: $title, seconds: $seconds, reps: $reps, target: $target, percent: $percent, rating: $rating, color: $color)';
}


}

/// @nodoc
abstract mixin class _$StepResultCopyWith<$Res> implements $StepResultCopyWith<$Res> {
  factory _$StepResultCopyWith(_StepResult value, $Res Function(_StepResult) _then) = __$StepResultCopyWithImpl;
@override @useResult
$Res call({
 int stepId, int order, String title, double seconds, int reps, String target, double percent, String rating, String color
});




}
/// @nodoc
class __$StepResultCopyWithImpl<$Res>
    implements _$StepResultCopyWith<$Res> {
  __$StepResultCopyWithImpl(this._self, this._then);

  final _StepResult _self;
  final $Res Function(_StepResult) _then;

/// Create a copy of StepResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepId = null,Object? order = null,Object? title = null,Object? seconds = null,Object? reps = null,Object? target = null,Object? percent = null,Object? rating = null,Object? color = null,}) {
  return _then(_StepResult(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateTestRequest {

 String get name; String get description; String get category; String get age; String get goal; List<String> get qualities;
/// Create a copy of CreateTestRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTestRequestCopyWith<CreateTestRequest> get copyWith => _$CreateTestRequestCopyWithImpl<CreateTestRequest>(this as CreateTestRequest, _$identity);

  /// Serializes this CreateTestRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTestRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.age, age) || other.age == age)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.qualities, qualities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,category,age,goal,const DeepCollectionEquality().hash(qualities));

@override
String toString() {
  return 'CreateTestRequest(name: $name, description: $description, category: $category, age: $age, goal: $goal, qualities: $qualities)';
}


}

/// @nodoc
abstract mixin class $CreateTestRequestCopyWith<$Res>  {
  factory $CreateTestRequestCopyWith(CreateTestRequest value, $Res Function(CreateTestRequest) _then) = _$CreateTestRequestCopyWithImpl;
@useResult
$Res call({
 String name, String description, String category, String age, String goal, List<String> qualities
});




}
/// @nodoc
class _$CreateTestRequestCopyWithImpl<$Res>
    implements $CreateTestRequestCopyWith<$Res> {
  _$CreateTestRequestCopyWithImpl(this._self, this._then);

  final CreateTestRequest _self;
  final $Res Function(CreateTestRequest) _then;

/// Create a copy of CreateTestRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? category = null,Object? age = null,Object? goal = null,Object? qualities = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,qualities: null == qualities ? _self.qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTestRequest].
extension CreateTestRequestPatterns on CreateTestRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTestRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTestRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTestRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTestRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTestRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTestRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  String category,  String age,  String goal,  List<String> qualities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTestRequest() when $default != null:
return $default(_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  String category,  String age,  String goal,  List<String> qualities)  $default,) {final _that = this;
switch (_that) {
case _CreateTestRequest():
return $default(_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  String category,  String age,  String goal,  List<String> qualities)?  $default,) {final _that = this;
switch (_that) {
case _CreateTestRequest() when $default != null:
return $default(_that.name,_that.description,_that.category,_that.age,_that.goal,_that.qualities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTestRequest implements CreateTestRequest {
  const _CreateTestRequest({required this.name, this.description = '', this.category = '', this.age = '', this.goal = '', final  List<String> qualities = const <String>[]}): _qualities = qualities;
  factory _CreateTestRequest.fromJson(Map<String, dynamic> json) => _$CreateTestRequestFromJson(json);

@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String category;
@override@JsonKey() final  String age;
@override@JsonKey() final  String goal;
 final  List<String> _qualities;
@override@JsonKey() List<String> get qualities {
  if (_qualities is EqualUnmodifiableListView) return _qualities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_qualities);
}


/// Create a copy of CreateTestRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTestRequestCopyWith<_CreateTestRequest> get copyWith => __$CreateTestRequestCopyWithImpl<_CreateTestRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTestRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTestRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.age, age) || other.age == age)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other._qualities, _qualities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,category,age,goal,const DeepCollectionEquality().hash(_qualities));

@override
String toString() {
  return 'CreateTestRequest(name: $name, description: $description, category: $category, age: $age, goal: $goal, qualities: $qualities)';
}


}

/// @nodoc
abstract mixin class _$CreateTestRequestCopyWith<$Res> implements $CreateTestRequestCopyWith<$Res> {
  factory _$CreateTestRequestCopyWith(_CreateTestRequest value, $Res Function(_CreateTestRequest) _then) = __$CreateTestRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, String category, String age, String goal, List<String> qualities
});




}
/// @nodoc
class __$CreateTestRequestCopyWithImpl<$Res>
    implements _$CreateTestRequestCopyWith<$Res> {
  __$CreateTestRequestCopyWithImpl(this._self, this._then);

  final _CreateTestRequest _self;
  final $Res Function(_CreateTestRequest) _then;

/// Create a copy of CreateTestRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? category = null,Object? age = null,Object? goal = null,Object? qualities = null,}) {
  return _then(_CreateTestRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,qualities: null == qualities ? _self._qualities : qualities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$FinishStepInput {

 int get stepId; double get seconds; int get reps;
/// Create a copy of FinishStepInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishStepInputCopyWith<FinishStepInput> get copyWith => _$FinishStepInputCopyWithImpl<FinishStepInput>(this as FinishStepInput, _$identity);

  /// Serializes this FinishStepInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishStepInput&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.reps, reps) || other.reps == reps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,seconds,reps);

@override
String toString() {
  return 'FinishStepInput(stepId: $stepId, seconds: $seconds, reps: $reps)';
}


}

/// @nodoc
abstract mixin class $FinishStepInputCopyWith<$Res>  {
  factory $FinishStepInputCopyWith(FinishStepInput value, $Res Function(FinishStepInput) _then) = _$FinishStepInputCopyWithImpl;
@useResult
$Res call({
 int stepId, double seconds, int reps
});




}
/// @nodoc
class _$FinishStepInputCopyWithImpl<$Res>
    implements $FinishStepInputCopyWith<$Res> {
  _$FinishStepInputCopyWithImpl(this._self, this._then);

  final FinishStepInput _self;
  final $Res Function(FinishStepInput) _then;

/// Create a copy of FinishStepInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepId = null,Object? seconds = null,Object? reps = null,}) {
  return _then(_self.copyWith(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as int,seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FinishStepInput].
extension FinishStepInputPatterns on FinishStepInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishStepInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishStepInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishStepInput value)  $default,){
final _that = this;
switch (_that) {
case _FinishStepInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishStepInput value)?  $default,){
final _that = this;
switch (_that) {
case _FinishStepInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepId,  double seconds,  int reps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishStepInput() when $default != null:
return $default(_that.stepId,_that.seconds,_that.reps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepId,  double seconds,  int reps)  $default,) {final _that = this;
switch (_that) {
case _FinishStepInput():
return $default(_that.stepId,_that.seconds,_that.reps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepId,  double seconds,  int reps)?  $default,) {final _that = this;
switch (_that) {
case _FinishStepInput() when $default != null:
return $default(_that.stepId,_that.seconds,_that.reps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishStepInput implements FinishStepInput {
  const _FinishStepInput({required this.stepId, this.seconds = 0, this.reps = 0});
  factory _FinishStepInput.fromJson(Map<String, dynamic> json) => _$FinishStepInputFromJson(json);

@override final  int stepId;
@override@JsonKey() final  double seconds;
@override@JsonKey() final  int reps;

/// Create a copy of FinishStepInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishStepInputCopyWith<_FinishStepInput> get copyWith => __$FinishStepInputCopyWithImpl<_FinishStepInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishStepInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishStepInput&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.reps, reps) || other.reps == reps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,seconds,reps);

@override
String toString() {
  return 'FinishStepInput(stepId: $stepId, seconds: $seconds, reps: $reps)';
}


}

/// @nodoc
abstract mixin class _$FinishStepInputCopyWith<$Res> implements $FinishStepInputCopyWith<$Res> {
  factory _$FinishStepInputCopyWith(_FinishStepInput value, $Res Function(_FinishStepInput) _then) = __$FinishStepInputCopyWithImpl;
@override @useResult
$Res call({
 int stepId, double seconds, int reps
});




}
/// @nodoc
class __$FinishStepInputCopyWithImpl<$Res>
    implements _$FinishStepInputCopyWith<$Res> {
  __$FinishStepInputCopyWithImpl(this._self, this._then);

  final _FinishStepInput _self;
  final $Res Function(_FinishStepInput) _then;

/// Create a copy of FinishStepInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepId = null,Object? seconds = null,Object? reps = null,}) {
  return _then(_FinishStepInput(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as int,seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinishTestRequest {

 String get notes; List<FinishStepInput> get stepTimes;
/// Create a copy of FinishTestRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishTestRequestCopyWith<FinishTestRequest> get copyWith => _$FinishTestRequestCopyWithImpl<FinishTestRequest>(this as FinishTestRequest, _$identity);

  /// Serializes this FinishTestRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishTestRequest&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.stepTimes, stepTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notes,const DeepCollectionEquality().hash(stepTimes));

@override
String toString() {
  return 'FinishTestRequest(notes: $notes, stepTimes: $stepTimes)';
}


}

/// @nodoc
abstract mixin class $FinishTestRequestCopyWith<$Res>  {
  factory $FinishTestRequestCopyWith(FinishTestRequest value, $Res Function(FinishTestRequest) _then) = _$FinishTestRequestCopyWithImpl;
@useResult
$Res call({
 String notes, List<FinishStepInput> stepTimes
});




}
/// @nodoc
class _$FinishTestRequestCopyWithImpl<$Res>
    implements $FinishTestRequestCopyWith<$Res> {
  _$FinishTestRequestCopyWithImpl(this._self, this._then);

  final FinishTestRequest _self;
  final $Res Function(FinishTestRequest) _then;

/// Create a copy of FinishTestRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notes = null,Object? stepTimes = null,}) {
  return _then(_self.copyWith(
notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,stepTimes: null == stepTimes ? _self.stepTimes : stepTimes // ignore: cast_nullable_to_non_nullable
as List<FinishStepInput>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinishTestRequest].
extension FinishTestRequestPatterns on FinishTestRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishTestRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishTestRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishTestRequest value)  $default,){
final _that = this;
switch (_that) {
case _FinishTestRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishTestRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FinishTestRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String notes,  List<FinishStepInput> stepTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishTestRequest() when $default != null:
return $default(_that.notes,_that.stepTimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String notes,  List<FinishStepInput> stepTimes)  $default,) {final _that = this;
switch (_that) {
case _FinishTestRequest():
return $default(_that.notes,_that.stepTimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String notes,  List<FinishStepInput> stepTimes)?  $default,) {final _that = this;
switch (_that) {
case _FinishTestRequest() when $default != null:
return $default(_that.notes,_that.stepTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishTestRequest implements FinishTestRequest {
  const _FinishTestRequest({this.notes = '', final  List<FinishStepInput> stepTimes = const <FinishStepInput>[]}): _stepTimes = stepTimes;
  factory _FinishTestRequest.fromJson(Map<String, dynamic> json) => _$FinishTestRequestFromJson(json);

@override@JsonKey() final  String notes;
 final  List<FinishStepInput> _stepTimes;
@override@JsonKey() List<FinishStepInput> get stepTimes {
  if (_stepTimes is EqualUnmodifiableListView) return _stepTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stepTimes);
}


/// Create a copy of FinishTestRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishTestRequestCopyWith<_FinishTestRequest> get copyWith => __$FinishTestRequestCopyWithImpl<_FinishTestRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishTestRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishTestRequest&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._stepTimes, _stepTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notes,const DeepCollectionEquality().hash(_stepTimes));

@override
String toString() {
  return 'FinishTestRequest(notes: $notes, stepTimes: $stepTimes)';
}


}

/// @nodoc
abstract mixin class _$FinishTestRequestCopyWith<$Res> implements $FinishTestRequestCopyWith<$Res> {
  factory _$FinishTestRequestCopyWith(_FinishTestRequest value, $Res Function(_FinishTestRequest) _then) = __$FinishTestRequestCopyWithImpl;
@override @useResult
$Res call({
 String notes, List<FinishStepInput> stepTimes
});




}
/// @nodoc
class __$FinishTestRequestCopyWithImpl<$Res>
    implements _$FinishTestRequestCopyWith<$Res> {
  __$FinishTestRequestCopyWithImpl(this._self, this._then);

  final _FinishTestRequest _self;
  final $Res Function(_FinishTestRequest) _then;

/// Create a copy of FinishTestRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notes = null,Object? stepTimes = null,}) {
  return _then(_FinishTestRequest(
notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,stepTimes: null == stepTimes ? _self._stepTimes : stepTimes // ignore: cast_nullable_to_non_nullable
as List<FinishStepInput>,
  ));
}


}

// dart format on

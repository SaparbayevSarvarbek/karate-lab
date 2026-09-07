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
mixin _$TestAssignment {

 int get id; int get testId; String get name; List<Exercise> get exercises;@JsonKey(unknownEnumValue: TestStatus.unknown) TestStatus get status; double? get score; String get notes; DateTime? get assignedAt; DateTime? get startedAt; DateTime? get finishedAt;
/// Create a copy of TestAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestAssignmentCopyWith<TestAssignment> get copyWith => _$TestAssignmentCopyWithImpl<TestAssignment>(this as TestAssignment, _$identity);

  /// Serializes this TestAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.status, status) || other.status == status)&&(identical(other.score, score) || other.score == score)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testId,name,const DeepCollectionEquality().hash(exercises),status,score,notes,assignedAt,startedAt,finishedAt);

@override
String toString() {
  return 'TestAssignment(id: $id, testId: $testId, name: $name, exercises: $exercises, status: $status, score: $score, notes: $notes, assignedAt: $assignedAt, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $TestAssignmentCopyWith<$Res>  {
  factory $TestAssignmentCopyWith(TestAssignment value, $Res Function(TestAssignment) _then) = _$TestAssignmentCopyWithImpl;
@useResult
$Res call({
 int id, int testId, String name, List<Exercise> exercises,@JsonKey(unknownEnumValue: TestStatus.unknown) TestStatus status, double? score, String notes, DateTime? assignedAt, DateTime? startedAt, DateTime? finishedAt
});




}
/// @nodoc
class _$TestAssignmentCopyWithImpl<$Res>
    implements $TestAssignmentCopyWith<$Res> {
  _$TestAssignmentCopyWithImpl(this._self, this._then);

  final TestAssignment _self;
  final $Res Function(TestAssignment) _then;

/// Create a copy of TestAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? testId = null,Object? name = null,Object? exercises = null,Object? status = null,Object? score = freezed,Object? notes = null,Object? assignedAt = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestStatus,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TestAssignment].
extension TestAssignmentPatterns on TestAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestAssignment value)  $default,){
final _that = this;
switch (_that) {
case _TestAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _TestAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int testId,  String name,  List<Exercise> exercises, @JsonKey(unknownEnumValue: TestStatus.unknown)  TestStatus status,  double? score,  String notes,  DateTime? assignedAt,  DateTime? startedAt,  DateTime? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestAssignment() when $default != null:
return $default(_that.id,_that.testId,_that.name,_that.exercises,_that.status,_that.score,_that.notes,_that.assignedAt,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int testId,  String name,  List<Exercise> exercises, @JsonKey(unknownEnumValue: TestStatus.unknown)  TestStatus status,  double? score,  String notes,  DateTime? assignedAt,  DateTime? startedAt,  DateTime? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _TestAssignment():
return $default(_that.id,_that.testId,_that.name,_that.exercises,_that.status,_that.score,_that.notes,_that.assignedAt,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int testId,  String name,  List<Exercise> exercises, @JsonKey(unknownEnumValue: TestStatus.unknown)  TestStatus status,  double? score,  String notes,  DateTime? assignedAt,  DateTime? startedAt,  DateTime? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _TestAssignment() when $default != null:
return $default(_that.id,_that.testId,_that.name,_that.exercises,_that.status,_that.score,_that.notes,_that.assignedAt,_that.startedAt,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestAssignment extends TestAssignment {
  const _TestAssignment({this.id = 0, this.testId = 0, this.name = '', final  List<Exercise> exercises = const [], @JsonKey(unknownEnumValue: TestStatus.unknown) this.status = TestStatus.unknown, this.score, this.notes = '', this.assignedAt, this.startedAt, this.finishedAt}): _exercises = exercises,super._();
  factory _TestAssignment.fromJson(Map<String, dynamic> json) => _$TestAssignmentFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  int testId;
@override@JsonKey() final  String name;
 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey(unknownEnumValue: TestStatus.unknown) final  TestStatus status;
@override final  double? score;
@override@JsonKey() final  String notes;
@override final  DateTime? assignedAt;
@override final  DateTime? startedAt;
@override final  DateTime? finishedAt;

/// Create a copy of TestAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestAssignmentCopyWith<_TestAssignment> get copyWith => __$TestAssignmentCopyWithImpl<_TestAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.status, status) || other.status == status)&&(identical(other.score, score) || other.score == score)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testId,name,const DeepCollectionEquality().hash(_exercises),status,score,notes,assignedAt,startedAt,finishedAt);

@override
String toString() {
  return 'TestAssignment(id: $id, testId: $testId, name: $name, exercises: $exercises, status: $status, score: $score, notes: $notes, assignedAt: $assignedAt, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$TestAssignmentCopyWith<$Res> implements $TestAssignmentCopyWith<$Res> {
  factory _$TestAssignmentCopyWith(_TestAssignment value, $Res Function(_TestAssignment) _then) = __$TestAssignmentCopyWithImpl;
@override @useResult
$Res call({
 int id, int testId, String name, List<Exercise> exercises,@JsonKey(unknownEnumValue: TestStatus.unknown) TestStatus status, double? score, String notes, DateTime? assignedAt, DateTime? startedAt, DateTime? finishedAt
});




}
/// @nodoc
class __$TestAssignmentCopyWithImpl<$Res>
    implements _$TestAssignmentCopyWith<$Res> {
  __$TestAssignmentCopyWithImpl(this._self, this._then);

  final _TestAssignment _self;
  final $Res Function(_TestAssignment) _then;

/// Create a copy of TestAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? testId = null,Object? name = null,Object? exercises = null,Object? status = null,Object? score = freezed,Object? notes = null,Object? assignedAt = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_TestAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestStatus,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TestEntity {

 int get id; String get name; List<Exercise> get exercises; DateTime? get createdAt;
/// Create a copy of TestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestEntityCopyWith<TestEntity> get copyWith => _$TestEntityCopyWithImpl<TestEntity>(this as TestEntity, _$identity);

  /// Serializes this TestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(exercises),createdAt);

@override
String toString() {
  return 'TestEntity(id: $id, name: $name, exercises: $exercises, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TestEntityCopyWith<$Res>  {
  factory $TestEntityCopyWith(TestEntity value, $Res Function(TestEntity) _then) = _$TestEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<Exercise> exercises, DateTime? createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? exercises = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<Exercise> exercises,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestEntity() when $default != null:
return $default(_that.id,_that.name,_that.exercises,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<Exercise> exercises,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TestEntity():
return $default(_that.id,_that.name,_that.exercises,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<Exercise> exercises,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TestEntity() when $default != null:
return $default(_that.id,_that.name,_that.exercises,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestEntity extends TestEntity {
  const _TestEntity({this.id = 0, this.name = '', final  List<Exercise> exercises = const [], this.createdAt}): _exercises = exercises,super._();
  factory _TestEntity.fromJson(Map<String, dynamic> json) => _$TestEntityFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override final  DateTime? createdAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_exercises),createdAt);

@override
String toString() {
  return 'TestEntity(id: $id, name: $name, exercises: $exercises, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TestEntityCopyWith<$Res> implements $TestEntityCopyWith<$Res> {
  factory _$TestEntityCopyWith(_TestEntity value, $Res Function(_TestEntity) _then) = __$TestEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<Exercise> exercises, DateTime? createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? exercises = null,Object? createdAt = freezed,}) {
  return _then(_TestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CreateTestRequest {

 String get name; List<int> get exerciseIds;
/// Create a copy of CreateTestRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTestRequestCopyWith<CreateTestRequest> get copyWith => _$CreateTestRequestCopyWithImpl<CreateTestRequest>(this as CreateTestRequest, _$identity);

  /// Serializes this CreateTestRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTestRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.exerciseIds, exerciseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(exerciseIds));

@override
String toString() {
  return 'CreateTestRequest(name: $name, exerciseIds: $exerciseIds)';
}


}

/// @nodoc
abstract mixin class $CreateTestRequestCopyWith<$Res>  {
  factory $CreateTestRequestCopyWith(CreateTestRequest value, $Res Function(CreateTestRequest) _then) = _$CreateTestRequestCopyWithImpl;
@useResult
$Res call({
 String name, List<int> exerciseIds
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? exerciseIds = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exerciseIds: null == exerciseIds ? _self.exerciseIds : exerciseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<int> exerciseIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTestRequest() when $default != null:
return $default(_that.name,_that.exerciseIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<int> exerciseIds)  $default,) {final _that = this;
switch (_that) {
case _CreateTestRequest():
return $default(_that.name,_that.exerciseIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<int> exerciseIds)?  $default,) {final _that = this;
switch (_that) {
case _CreateTestRequest() when $default != null:
return $default(_that.name,_that.exerciseIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTestRequest implements CreateTestRequest {
  const _CreateTestRequest({required this.name, required final  List<int> exerciseIds}): _exerciseIds = exerciseIds;
  factory _CreateTestRequest.fromJson(Map<String, dynamic> json) => _$CreateTestRequestFromJson(json);

@override final  String name;
 final  List<int> _exerciseIds;
@override List<int> get exerciseIds {
  if (_exerciseIds is EqualUnmodifiableListView) return _exerciseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exerciseIds);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTestRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._exerciseIds, _exerciseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_exerciseIds));

@override
String toString() {
  return 'CreateTestRequest(name: $name, exerciseIds: $exerciseIds)';
}


}

/// @nodoc
abstract mixin class _$CreateTestRequestCopyWith<$Res> implements $CreateTestRequestCopyWith<$Res> {
  factory _$CreateTestRequestCopyWith(_CreateTestRequest value, $Res Function(_CreateTestRequest) _then) = __$CreateTestRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, List<int> exerciseIds
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? exerciseIds = null,}) {
  return _then(_CreateTestRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exerciseIds: null == exerciseIds ? _self._exerciseIds : exerciseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$AssignTestRequest {

 List<int> get athleteIds;
/// Create a copy of AssignTestRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignTestRequestCopyWith<AssignTestRequest> get copyWith => _$AssignTestRequestCopyWithImpl<AssignTestRequest>(this as AssignTestRequest, _$identity);

  /// Serializes this AssignTestRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignTestRequest&&const DeepCollectionEquality().equals(other.athleteIds, athleteIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(athleteIds));

@override
String toString() {
  return 'AssignTestRequest(athleteIds: $athleteIds)';
}


}

/// @nodoc
abstract mixin class $AssignTestRequestCopyWith<$Res>  {
  factory $AssignTestRequestCopyWith(AssignTestRequest value, $Res Function(AssignTestRequest) _then) = _$AssignTestRequestCopyWithImpl;
@useResult
$Res call({
 List<int> athleteIds
});




}
/// @nodoc
class _$AssignTestRequestCopyWithImpl<$Res>
    implements $AssignTestRequestCopyWith<$Res> {
  _$AssignTestRequestCopyWithImpl(this._self, this._then);

  final AssignTestRequest _self;
  final $Res Function(AssignTestRequest) _then;

/// Create a copy of AssignTestRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? athleteIds = null,}) {
  return _then(_self.copyWith(
athleteIds: null == athleteIds ? _self.athleteIds : athleteIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignTestRequest].
extension AssignTestRequestPatterns on AssignTestRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignTestRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignTestRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignTestRequest value)  $default,){
final _that = this;
switch (_that) {
case _AssignTestRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignTestRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AssignTestRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> athleteIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignTestRequest() when $default != null:
return $default(_that.athleteIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> athleteIds)  $default,) {final _that = this;
switch (_that) {
case _AssignTestRequest():
return $default(_that.athleteIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> athleteIds)?  $default,) {final _that = this;
switch (_that) {
case _AssignTestRequest() when $default != null:
return $default(_that.athleteIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignTestRequest implements AssignTestRequest {
  const _AssignTestRequest({required final  List<int> athleteIds}): _athleteIds = athleteIds;
  factory _AssignTestRequest.fromJson(Map<String, dynamic> json) => _$AssignTestRequestFromJson(json);

 final  List<int> _athleteIds;
@override List<int> get athleteIds {
  if (_athleteIds is EqualUnmodifiableListView) return _athleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_athleteIds);
}


/// Create a copy of AssignTestRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignTestRequestCopyWith<_AssignTestRequest> get copyWith => __$AssignTestRequestCopyWithImpl<_AssignTestRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignTestRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignTestRequest&&const DeepCollectionEquality().equals(other._athleteIds, _athleteIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_athleteIds));

@override
String toString() {
  return 'AssignTestRequest(athleteIds: $athleteIds)';
}


}

/// @nodoc
abstract mixin class _$AssignTestRequestCopyWith<$Res> implements $AssignTestRequestCopyWith<$Res> {
  factory _$AssignTestRequestCopyWith(_AssignTestRequest value, $Res Function(_AssignTestRequest) _then) = __$AssignTestRequestCopyWithImpl;
@override @useResult
$Res call({
 List<int> athleteIds
});




}
/// @nodoc
class __$AssignTestRequestCopyWithImpl<$Res>
    implements _$AssignTestRequestCopyWith<$Res> {
  __$AssignTestRequestCopyWithImpl(this._self, this._then);

  final _AssignTestRequest _self;
  final $Res Function(_AssignTestRequest) _then;

/// Create a copy of AssignTestRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? athleteIds = null,}) {
  return _then(_AssignTestRequest(
athleteIds: null == athleteIds ? _self._athleteIds : athleteIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$FinishTestRequest {

 double get score; String get notes;
/// Create a copy of FinishTestRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishTestRequestCopyWith<FinishTestRequest> get copyWith => _$FinishTestRequestCopyWithImpl<FinishTestRequest>(this as FinishTestRequest, _$identity);

  /// Serializes this FinishTestRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishTestRequest&&(identical(other.score, score) || other.score == score)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,notes);

@override
String toString() {
  return 'FinishTestRequest(score: $score, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $FinishTestRequestCopyWith<$Res>  {
  factory $FinishTestRequestCopyWith(FinishTestRequest value, $Res Function(FinishTestRequest) _then) = _$FinishTestRequestCopyWithImpl;
@useResult
$Res call({
 double score, String notes
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
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? notes = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double score,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishTestRequest() when $default != null:
return $default(_that.score,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double score,  String notes)  $default,) {final _that = this;
switch (_that) {
case _FinishTestRequest():
return $default(_that.score,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double score,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _FinishTestRequest() when $default != null:
return $default(_that.score,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishTestRequest implements FinishTestRequest {
  const _FinishTestRequest({required this.score, this.notes = ''});
  factory _FinishTestRequest.fromJson(Map<String, dynamic> json) => _$FinishTestRequestFromJson(json);

@override final  double score;
@override@JsonKey() final  String notes;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishTestRequest&&(identical(other.score, score) || other.score == score)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,notes);

@override
String toString() {
  return 'FinishTestRequest(score: $score, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$FinishTestRequestCopyWith<$Res> implements $FinishTestRequestCopyWith<$Res> {
  factory _$FinishTestRequestCopyWith(_FinishTestRequest value, $Res Function(_FinishTestRequest) _then) = __$FinishTestRequestCopyWithImpl;
@override @useResult
$Res call({
 double score, String notes
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
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? notes = null,}) {
  return _then(_FinishTestRequest(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
